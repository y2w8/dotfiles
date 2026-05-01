#!/usr/bin/env fish

set -l state_file "$HOME/.local/state/theme_mode"
set -l mode (cat $state_file 2>/dev/null; or echo "dms")
set -l action $argv[1]

switch $action
    case launcher
        if test "$mode" = dms
            dms ipc call spotlight toggle
        else if test "$mode" = waybar
            alacritty --title launcher -e fsel -d
        else if test "$mode" = yshell
            qs -c yshell ipc call launcher toggle
        else if test "$mode" = wayle
            vicinae toggle
        end

    case clipboard
        if test "$mode" = dms
            dms ipc call clipboard toggle
        else if test "$mode" = waybar
            alacritty --title clipboard -e fsel --cclip
        else if test "$mode" = yshell
            qs -c yshell ipc call clipboard toggle
        else if test "$mode" = wayle
            vicinae vicinae://launch/clipboard/history
        end

    case color-picker
        if test "$mode" = dms
            dms color pick -a
        else
            # hyprpicker -a
            pkill -SIGUSR1 ie-r
        end

    case settings
        if test "$mode" = dms
            dms ipc call settings focusOrToggle
        else if test "$mode" = waybar
            swaync-client -t
        else if test "$mode" = yshell
            qs -c yshell ipc call controlcenter toggle
        end

    case screenshot
        if test "$mode" = dms
            dms screenshot region
        else
            niri msg action screenshot
        end

    case toggle-dpm
        ~/.config/scripts/niri/screen_toggle eDP-1

    case lock
        if test "$mode" = dms
            dms ipc call lock lock
        else if test "$mode" = waybar
            set outputs (niri msg -j outputs | jq -r '.[].name')

            for o in $outputs
                grim -o $o /tmp/$o.png
                magick /tmp/$o.png -sample 25% -blur 0x5 -resize 400% /tmp/$o.png &
            end

            wait
            gtklock -s ~/.config/gtklock/style.css

        else if test "$mode" = yshell
            qs -c yshell ipc call sessionlock lock
        end

    case brightness
        if test "$mode" = dms
            switch $argv[2]
                case raise
                    brightnessctl set +10%

                case lower
                    brightnessctl set 10%-
            end
        else
            switch $argv[2]
                case raise
                    swayosd-client --brightness +10

                case lower
                    swayosd-client --brightness -10
            end
        end

    case profile
        set state_file "$HOME/.local/state/tlp_profile"
        mkdir -p (dirname $state_file)

        set current (cat $state_file 2>/dev/null; or echo "balanced")

        switch $current
            case balanced
                set next performance
                set icon ~/.config/swaync/performance.png
            case performance
                set next power-saver
                set icon ~/.config/swaync/powersave.png
            case powersave
                set next balanced
                set icon ~/.config/swaync/balanced.png
            case "*"
                set next balanced
                set icon ~/.config/swaync/balanced.png
        end

        sudo tlp $next

        echo $next >$state_file

        notify-send -u low -i $icon -a "TLP Profile" "TLP Profile" "Switched to: $next mode"

    case "*"
        echo "Unknown action: $action"
end
