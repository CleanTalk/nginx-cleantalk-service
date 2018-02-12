# Nginx lua-based antispam module example

## Dependencies:
* nginx-extras
* lua-cjson

## Install:
* Debian/Ubuntu:
`apt install nginx-extras lua-cjson`
* Redhat:
`yum install nginx-extras lua-cjson`
* Add "access_by_lua_block" code to your "location" block
* Change "api_key" to your API key (Got one at https://cleantalk.org/my/)
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
