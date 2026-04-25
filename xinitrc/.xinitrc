# For these custom programs below
[ -f ~/.profile ] && source ~/.profile

xhost +SI:localuser:$(whoami)

setxkbmap us -option ctrl:nocaps # Sometimes xmodmap breaks, this should fix it
[ -f "$HOME/.Xmodmap" ] && xmodmap "$HOME/.Xmodmap"

export CURRENT_WM="exwm"
exec dbus-launch --exit-with-session emacs

#export CURRENT_WM="dwm"
#xrandr --output HDMI-1 --above eDP-1 --mode 1920x1080
#health &
#slstatus &
#startdwm.sh
