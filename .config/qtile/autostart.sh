#!/usr/bin/env sh
if [ "$XDG_SESSION_TYPE" == "x11" ]; then
    numlockx on
    autorandr --change &
    picom &
else
    kanshi &
fi
dunst &
nm-applet &
pasystray &
kdeconnect-indicator &
caffeine-indicator &
nextcloud &
