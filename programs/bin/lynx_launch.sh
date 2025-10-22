#!/bin/sh

choice=$(printf "%s\n" "Duckduckgo" "VeronicaV2" "Gopherpedia" | dmenu -p "Engine: ")

# Exit if choice is empty
[ -z "$choice" ] && exit 0

query=$(dmenu -p "Search query: " < /dev/null)

# Exit if query is empty
[ -z "$query" ] && exit 0

case "$choice" in
  Duckduckgo)
    enc=$(printf "%s" "$query" | sed "s/ /+/g")
    url="https://lite.duckduckgo.com/lite/?q=${enc}"
  ;;
  VeronicaV2)
    enc=$(printf "%s" "$query" | sed "s/ /%20/g")
    url="gopher://gopher.floodgap.com:70/7/v2/vs?${enc}"
  ;;
  Gopherpedia)
    enc=$(printf "%s" "$query" | sed "s/ /%20/g")
    url="gopher://gopherpedia.com:70/7/lookup?${enc}"
  ;;
  *) exit 0 ;;
esac

# Launch lynx inside a new st terminal
exec st -e lynx "$url"
