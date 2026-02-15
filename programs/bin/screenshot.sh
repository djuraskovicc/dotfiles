#!/bin/sh
filename=$(dmenu -p "Filename: " < /dev/null)
size="1920x1080"
display=":0.0"

[ -z "$filename" ] && exit 0
filepath="$HOME/Pictures/$filename.jpg"

sleep 0.5
ffmpeg -f x11grab -video_size "$size" -i "$display" -update 1 -frames:v 1 -q:v 2 -an "$filepath"
