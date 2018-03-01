if ngx.var.request_method == "POST" then
	local cjson = require("cjson.safe")		-- JSon library ("Safe" because its return "nil" instead of error)
	ngx.req.read_body()							-- Read post data (body)
	local args, err = ngx.req.get_post_args()	-- Get POST vars
	if not args then
		ngx.say("Failed to get POST data!")
		ngx.exit(ngx.OK)
		return
	end

	local client_email = ""
	local client_ip = ngx.var.remote_addr		-- Remote_addr by default. Not work if use Proxy or Nat
	
	local regex = "^[%w_.]+@%w+%.%w+$"		-- Email match
	for key, val in pairs(args) do
		if type(val) ~= "table" then
			local m, err = string.match(val, regex)
			if m then client_email = m end
		end
	end
	
	local regex = "^%d+.%d+.%d+.%d+$"		-- IP match
	for key, val in pairs(args) do
		if type(val) ~= "table" then
			local m, err = string.match(val, regex)
			if m then client_ip = m end
		end
	end

	--if args["email"] then client_email = args["email"] end
	--if args["ip"] then client_ip = args["ip"] end

	-- Make a call to our service
	local res = ngx.location.capture(
		'/spam_check',
		{
			method = ngx.HTTP_GET,
			args = {
				method_name = 'spam_check',
				auth_key = ngx.var.apikey,
				email = client_email,
				ip = client_ip
			}
		}
	)

	if res.status == ngx.HTTP_OK then
		-- Parse answer
		--ngx.print(res.body)
		local data = cjson.decode("["..res.body.."]")
		--ngx.say(cjson.encode(data))
		if data == nil then
			ngx.say("Error: No answer from server")
			ngx.exit(ngx.OK)
		end
		
		local good_email = false
		local good_ip = false
		
		if (data ~= nul and data[1] ~= nil) then
			if (data[1]["data"] ~= nil) then

				-- Check Email
				if (data[1]["data"][client_email] ~= nil and
					data[1]["data"][client_email]["appears"] ~= nil and
					data[1]["data"][client_email]["appears"] == 0) then
					good_email = true
				end

				-- Check IP
				if (data[1]["data"][client_ip] ~= nil and
					data[1]["data"][client_ip]["appears"] ~= nil and
					data[1]["data"][client_ip]["appears"] == 0) then
					good_ip = true
				end
			end

			if (data[1]["error_no"] ~= nil and
				data[1]["error_no"] > 0) then
				ngx.say("Error:"..data[1]["error_no"])
				ngx.exit(ngx.OK)
			end

			if (good_email and good_ip) then
				-- All good, continue
				return
			else
				-- Email or IP is banned
				--ngx.exit(ngx.HTTP_FORBIDDEN)
				return ngx.redirect("https://blog.cleantalk.org/?security_test_ip="..client_ip)
			end
		end
	else
		ngx.say("Error: Service not respond. Status: " .. res.status)
		--ngx.say(res.body)	-- Uncomment for debug
		ngx.exit(ngx.OK)
	end
end
