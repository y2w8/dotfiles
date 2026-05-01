#!/bin/fish

set state_file "$HOME/.local/state/theme_mode"

mkdir -p (dirname $state_file)

set current_mode (cat $state_file 2>/dev/null; or echo "dms")

if test "$current_mode" = waybar
    echo "Starting Waybar mode..."

    waybar &
    cclipd -s 2 -t image/png -t "image/*" -t "text/plain;charset=utf-8" -t "text/*" -t "*" &
    ie-r &
    swaync &
    swayosd-libinput-backend &
    swayosd-server &
    awww-daemon &
    sleep 0.2

    echo waybar >$state_file
else if test "$current_mode" = dms
    echo "Starting DMS mode..."

    wl-paste --watch cliphist store &
    dms run --session &

    echo dms >$state_file
else if test "$current_mode" = yshell
    wl-paste --watch cliphist store &
    qs -c yshell &
    ie-r &

    echo yshell >$state_file
else if test "$current_mode" = wayle
    wl-paste --watch cliphist store &
    wayle shell &
    ie-r &
    vicinae server &

    echo wayle >$state_file
end
