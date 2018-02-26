# Nginx lua-based antispam module example

## Dependencies:
* nginx-extras
* lua-cjson

## Install:
* Debian/Ubuntu:
`apt install nginx-extras lua-cjson`
* Redhat:
`yum install nginx-extras lua-cjson`
* Add this to "location" that you want to protect:
`set $apikey '123456789';
access_by_lua_file /etc/nginx/scripts/cleantalk.lua`
* Set $apikey to your key (Get it here: https://cleantalk.org/register?platform=api)
* Do `service nginx reload` for apply changes

## How its works?
* If someone do POST request, parse it and grab email and IP (regex-based)
* If no IP present - use "http_remote_addr" (Real client address)
* Make a call to antispam service and parse answer
* If got error - display it and exit (Do not show requested page)
* If service say "all good" - show requested page

# TODO:
- [ ] Remove additional "/spam_check" location for proxy requests
- [ ] Add session mechanics support (for protect entire folder w/o additional requests)?
- [ ] Remove cjson dependencies (Possible to parse Json to native "lua table")
- [ ] Add "GET" data support?
- [ ] Better code and optimisation?
