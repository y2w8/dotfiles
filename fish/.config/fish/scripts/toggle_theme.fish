#!/bin/fish

set state_file "$HOME/.local/state/theme_mode"

mkdir -p (dirname $state_file)

set current_mode (cat $state_file 2>/dev/null; or echo "dms")

if test "$current_mode" = wayle
    echo "Switching to DMS mode..."

    killall wl-paste 2>/dev/null
    killall wayle 2>/dev/null
    killall awww-daemon 2>/dev/null
    killall vicinae-server 2>/dev/null
    killall ie-r 2>/dev/null

    wl-paste --watch cliphist store &
    dms run --session &

    echo dms >$state_file

else if test "$current_mode" = dms
    echo "Switching to Waybar mode..."

    killall wl-paste 2>/dev/null
    killall qs 2>/dev/null

    waybar &
    cclipd -s 2 -t image/png -t "image/*" -t "text/plain;charset=utf-8" -t "text/*" -t "*" &
    ie-r &
    swaync &
    swayosd-libinput-backend &
    swayosd-server &
    awww-daemon &
    sleep 0.2

    echo waybar >$state_file

else if test "$current_mode" = waybar
    echo "Switching to yshell mode..."

    killall waybar 2>/dev/null
    killall cclipd 2>/dev/null
    killall ie-r 2>/dev/null
    killall swaync 2>/dev/null
    killall swayosd-libinput 2>/dev/null
    killall swayosd-server 2>/dev/null
    killall awww-daemon 2>/dev/null

    wl-paste --watch cliphist store &
    qs -c yshell &
    ie-r &

    echo yshell >$state_file

else if test "$current_mode" = yshell
    echo "Switching to wayle mode..."

    killall qs 2>/dev/null
    killall ie-r 2>/dev/null
    killall wl-paste 2>/dev/null

    wl-paste --watch cliphist store &
    wayle shell &
    ie-r &
    vicinae server &

    echo wayle >$state_file
end
