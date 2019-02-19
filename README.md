# Nginx lua-based anti-spam module example

### Dependencies:
* nginx-extras
* lua-cjson

### Install:
* Debian/Ubuntu:
`apt install nginx-extras lua-cjson`
* Add `nginx/conf.d/cache.conf` to `/etc/nginx/conf.d/` and set cache params as you want.
* Add `include /etc/nginx/snippets/cleantalk-api.conf;` before protected location (Its API cache location)
* Add this to "location" that you want to protect:
`set $apikey '123456789';`
`access_by_lua_file /etc/nginx/scripts/cleantalk.lua`
* Set $apikey to your key (Get it from: https://cleantalk.org/register?platform=api)
* Do `service nginx reload` for apply changes

### How its works?
When someone makes a POST request, parse it and grab email and IP (regex-based). IP and Email will be checked with the CleanTalk Database and if they are currently blacklisted then the visitor sees the block screen. If not then the POST request will be approved.

If there is no IP in the POST request — "http_remote_addr" (Real client address) will be used.

### How Does the CleanTalk Database of Spam IP & Email Work?
CleanTalk analyzes spambots activity from more than 320,000 websites. We process about 2 millions of requests every day.

IPs and emails are being added to the CleanTalk Database only if they showed spam activity on several websites at once in a short period of time. Addresses that haven't shown any spam activity for the past 14 days will be deleted from the database. It allows us to keep the database information in the freshest state.

Spam activity data of IPs/emails are being updated in real-time.

[Learn more about CleanTalk BlackList](https://cleantalk.org/blacklists)


### How Is It Helpful
CleanTalk anti-spam module allows you to block bad IP addresses on your web server. 
Protect from spam attacks
Block requests with fake emails
Block other types of attacks on a web server from bad IP addresses using POST requests.
Reduce web server load

Also, you can use [CleanTalk API "spam_check"](https://cleantalk.org/help/api-spam-check) to check IP and Email via [CleanTalk BlackList](https://cleantalk.org/blacklists/submited_today).


#### TODO:
- [ ] Remove additional "/spam_check" location for proxy requests
- [ ] Add session mechanics support (for protect entire folder w/o additional requests)?
- [ ] Remove cjson dependencies (Possible to parse Json to native "lua table")
- [ ] Add "GET" data support?
- [ ] Better code and optimisation?
