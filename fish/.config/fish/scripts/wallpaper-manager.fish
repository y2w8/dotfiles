#!/usr/bin/env fish

set state_file "$HOME/.local/state/current_wallpaper"
set wall_dir "$HOME/Pictures/Wallpapers"
set wallpapers (ls $wall_dir/*.* 2>/dev/null)
set current_wall (cat $state_file 2>/dev/null; or echo $wallpapers[1])
set action $argv[1]

switch $action
    case next prev
        set index (contains -i -- $current_wall $wallpapers)

        if test "$action" = next
            set index (math $index + 1)
            if test $index -gt (count $wallpapers)
                set index 1
            end
        else if test "$action" = prev
            set index (math $index - 1)
            if test $index -lt 1
                set index (count $wallpapers)
            end
        end
    
    set new_wall $wallpapers[$index]
    awww img $new_wall
    echo $new_wall > $state_file

    case "*"
        echo "Usage: wallpaper_manager.fish [next|prev]"
end
