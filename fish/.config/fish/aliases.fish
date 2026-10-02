# Abbrevs
# abbr -a N '>/dev/null'
# abbr -a NN '2>/dev/null'
# abbr -a A '&>/dev/null'
# abbr -a NI '</dev/null'
# abbr -a C '| wl-copy'
# abbr -a P 'wl-paste |'
# abbr -a PR '| paste'

alias yay paru
abbr -a c clear
alias watch viddy
alias v _v
alias sv "sudo -E nvim"
alias sy "sudo -E yazi"
alias cat bat
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
alias grep "grep --color=auto"
alias shell "exec $SHELL -l"
abbr -a fk "sudo $history[1]"
alias ip 'ip -c a'
alias mkdir 'mkdir -pv'
alias cp 'cp -ig'
alias mv "mv -i"
alias rm "rm -Iv"
alias df "df -h"
alias du "du -h -d 1"
alias ka killall
alias psa "ps aux | grep -i"
alias man batman
alias lsbc "lsblk | bat -l conf -p"
alias ls 'eza --icons --group-directories-first'
alias la 'eza -a --icons --group-directories-first'
alias ll 'eza -lh --icons --group-directories-first'
alias lla 'eza -lah --icons --group-directories-first'
alias lt 'eza --tree --icons'
alias ltl 'eza --tree --level=2 --icons'
alias lg 'eza --git --icons'
alias lgl 'eza -lah --git --icons'
alias freec "free -h | bat -l cpuinfo -p"
alias sensors "sensors | bat -l cpuinfo -p"
alias exiftool /usr/bin/vendor_perl/exiftool
alias bathelp 'bat --plain --language=help'
alias ports "sudo ss -tulpn"

function help
    $argv --help 2>&1 | bathelp
end

function take
    mkdir -p $argv[1]
    cd $argv[1]
end

function _v
    set -l use_sudo 0
    if not test -w "$PWD"; or not test -r "$PWD"; or not test -x "$PWD"
        set use_sudo 1
    end
    for arg in $argv
        if test -e "$arg"; and not test -w "$arg"
            set use_sudo 1
            break
        else if not test -e "$arg"
            set -l parent_dir (dirname "$arg")
            if not test -w "$parent_dir"
                set use_sudo 1
                break
            end
        end
    end
    if test "$use_sudo" -eq 1
        sudo -E nvim $argv
    else
        nvim $argv
    end
end
# abbr -a v _v

function yazi_cd
    set -l cache_dir "$HOME/.cache/yazi"
    mkdir -p "$cache_dir"
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    if not test -w "$PWD"; or not test -r "$PWD"; or not test -x "$PWD"
        sudo -E yazi --cwd-file="$tmp"
    else
        yazi --cwd-file="$tmp"
    end
    if test -f "$tmp"
        set -l dir (cat "$tmp")
        if test -d "$dir"
            cd "$dir"
            commandline -f repaint
        end
        rm -f "$tmp"
    end
end

# ==========================================
# 💥 fkill - kill process
# ==========================================
function fkill
    set -l pids (ps -ef | sed 1d | fzf -m \
        --ansi \
        --preview="echo {} | awk '{print \$2}' | xargs ps -fp" \
        --preview-window="top:3:wrap" \
        | awk '{print $2}')

    if test -n "$pids"
        if set -q argv[1]
            echo $pids | xargs kill -$argv[1]
        else
            echo $pids | xargs kill -9
        end
        commandline -f repaint
    end
end

