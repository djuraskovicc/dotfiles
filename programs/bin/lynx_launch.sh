#!/bin/sh

query=$(dmenu -p "DuckDuckGo search: " < /dev/null)

# Exit if query is empty
[ -z "$query" ] && exit 0

# URL-encode spaces as '+'
enc=$(echo "$query" | sed 's/ /+/g')
url="https://lite.duckduckgo.com/lite/?q=${enc}"

# Launch lynx inside a new st terminal
exec st -e lynx "$url"
