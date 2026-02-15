#!/bin/sh

# Default settings
FPS=21
RESOLUTION="1920x1080"
AUDIO_BITRATE="128k"
VIDEO_CODEC="libx265"
QUALITY="medium"
AUDIO_CODEC="aac"
SAVE_PATH="$HOME/Videos"
VIDEO_OUTPUT="$SAVE_PATH/output.mp4"

# If you don't have multiple monitors you can remove this
# Set recording for HDMI-1 monitor
MONITOR_OFFSET="0,0" # Coordinates for HDMI-1 from xrandr output

# Audio device
echo "You can run 'pactl list sources short' to see available audio sources"
echo "In my case it is 2\n"
AUDIO_SOURCE=4

read -p "Enter framerate (default $FPS): " input
FPS=${input:-$FPS}

echo "Select video quality:"
echo "1. ultrafast"
echo "2. superfast"
echo "3. veryfast"
echo "4. faster"
echo "5. fast"
echo "6. medium (default)"
echo "7. slow"
echo "8. slower"
echo "9. veryslow"

read -p "Enter the number corresponding to quality: " input_quality

# Use the selected number to set the quality preset
case "$input_quality" in
    1) QUALITY="ultrafast" ;;
    2) QUALITY="superfast" ;;
    3) QUALITY="veryfast" ;;
    4) QUALITY="faster" ;;
    5) QUALITY="fast" ;;
    6) QUALITY="medium" ;;  # default
    7) QUALITY="slow" ;;
    8) QUALITY="slower" ;;
    9) QUALITY="veryslow" ;;
    *) QUALITY="medium" ;;  # If input is invalid or empty, default to medium
esac

read -p "Enter file name (default $VIDEO_OUTPUT): " output
VIDEO_OUTPUT=${output:-$VIDEO_OUTPUT}

# Should produce around 2.5-3.0 MB per minute of HD video
ffmpeg -probesize 17M -video_size "$RESOLUTION" -framerate "$FPS" -f x11grab -i :0.0+"$MONITOR_OFFSET" \
       -f pulse -guess_layout_max 0 -i "$AUDIO_SOURCE" -b:a "$AUDIO_BITRATE" -c:v "$VIDEO_CODEC" -preset "$QUALITY" \
       -crf 28 -b:v 85k -pix_fmt yuv420p -g 120 -c:a "$AUDIO_CODEC" -ac 2 "$VIDEO_OUTPUT"

# Instructions to isolate application sound if necesarry
#
# ---------------
# pactl load-module module-null-sink sink_name=virtual_sink sink_properties=device.description=Virtual_Sink
# Redirect the application's audio: Open pavucontrol and:
#
# Go to the Playback tab.
# Redirect the audio output of the application you want to record to Virtual_Sink.
#
# pactl load-module module-loopback source=virtual_sink.monitor sink=<physical_sink_name>
#
#
# ---------------
# Clean up loopback afterwards
# 
# pactl unload-module module-null-sink
# pactl unload-module module-loopback

# ffmpeg -probesize 17M -video_size "$RESOLUTION" -framerate "$FPS" -f x11grab -i :0.0+"$MONITOR_OFFSET" \
#        -f pulse -guess_layout_max 0 -i virtual_sink.monitor \
#        -c:v "$VIDEO_CODEC" -preset "$QUALITY" -crf 28 -b:v 85k -pix_fmt yuv420p -g 120 \
#        -c:a "$AUDIO_CODEC" -b:a "$AUDIO_BITRATE" -ac 2 "$VIDEO_OUTPUT"
