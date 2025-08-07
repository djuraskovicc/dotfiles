#!/bin/bash

query=$(dmenu -p "DuckDuckGo search: " < /dev/null)

# Exit if query is empty
[ -z "$query" ] && exit 0

# URL-encode spaces as '+'
enc=$(sed 's/ /+/g' <<< "$query")
url="https://lite.duckduckgo.com/lite/?q=${enc}"

# Launch lynx inside a new st terminal
exec st -e lynx "$url"
