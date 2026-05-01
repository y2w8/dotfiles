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
        --header="Tab: تحديد متعدد | Enter: إنهاء" \
        --preview="echo {} | awk '{print \$2}' | xargs ps -fp" \
        --preview-window="top:3:wrap" \
        | awk '{print $2}')

    if test -n "$pids"
        # دعم الحذف المتعدد بيمر بأريحية لكل الـ PIDs
        if set -q argv[1]
            echo $pids | xargs kill -$argv[1]
        else
            echo $pids | xargs kill -9
        end
        commandline -f repaint
    end
end

# ==========================================
# 🛠️ Helper function to integrate yay and fzf
# ==========================================
function yzf
    set -l pos $argv[1]
    set -e argv[1]

    if test -z "$pos"
        set pos 1
    end

    set -q XDG_STATE_HOME; and set -l fzf_hist "$XDG_STATE_HOME/fzf"; or set -l fzf_hist "$HOME/.local/state/fzf"
    mkdir -p $fzf_hist

    # التعديل هنا: xargs يطبع الأسطر مفرقة عشان Fish يقراها كمصفوفة للحزم
    sed "s/ /\t/g" | \
    fzf --nth=$pos --multi --history="$fzf_hist/history-yzf$pos" \
        --ansi \
        --preview-window=60%,border-left \
        --bind="double-click:execute(xdg-open 'https://archlinux.org/packages/{{'$pos'}}'),alt-enter:execute(xdg-open 'https://aur.archlinux.org/packages?K={{'$pos'}}&SB=p&SO=d&PP=100')" \
        $argv | cut -f$pos | xargs -n1
end

# ==========================================
# 📦 yas - List and install packages
# ==========================================
function yas
    set -l cache_dir "/tmp/yas-$USER"
    
    if test "$argv[1]" = "-y"
        rm -rf "$cache_dir"
        set -e argv[1]
    end
    
    mkdir -p "$cache_dir"
    set -l preview_cache "$cache_dir/preview_{2}"
    set -l list_cache "$cache_dir/list"

    if test -f "$list_cache$argv"
        if test (cat "$list_cache$argv" | wc -l) -lt 50000
            rm "$list_cache$argv"
        end
    end

    set -l pkgs (begin
        cat "$list_cache$argv" 2>/dev/null; or begin
            pacman --color=always -Sl $argv 2>/dev/null
            yay --color=always -Sl aur $argv 2>/dev/null
        end | sed -E 's/ [^ ]*unknown-version[^ ]*//g' | tee "$list_cache$argv"
    end | yzf 2 --tiebreak=index \
        --prompt="Install Package ❯ " \
        --preview="yay --color=always -Si {2} 2>/dev/null | grep -v 'Querying' || pacman -Si {2} 2>/dev/null")

    if test -n "$pkgs"
        echo "Installing: $pkgs... ⏳"
        set -l cmd "yay -S $pkgs"
        history insert "$cmd"
        eval $cmd </dev/tty
    end
    commandline -f repaint
end

# ==========================================
# 🗑️ yar - List and remove packages
# ==========================================
function yar
    set -l pkgs (yay --color=always -Q $argv 2>/dev/null | yzf 1 --tiebreak=length \
        --prompt="Remove Package ❯ " \
        --preview="yay --color=always -Qli {1} 2>/dev/null || pacman -Qi {1}")
        
    if test -n "$pkgs"
        echo "Removing: $pkgs... 🚨"
        set -l cmd "yay -R --cascade --recursive $pkgs"
        history insert "$cmd"
        eval $cmd </dev/tty
    end
    commandline -f repaint
end

# ==========================================
# 🚀 fzf-flatpak-install-widget
# ==========================================
function fzf-flatpak-install-widget
    set -l YLW (tput setaf 3); set -l WHT (tput setaf 7); set -l BLD (tput bold); set -l RST (tput sgr0)

    flatpak remote-ls flathub --cached --columns=app,name,description | \
    awk -v cyn=(tput setaf 6) -v blu=(tput setaf 4) -v bld=(tput bold) -v res=(tput sgr0) '
    {
        app_info="";
        for(i=2;i<=NF;i++){
            app_info=cyn app_info" "$i
        };
        print blu bld $2" -" res app_info "|" $1
    }' | \
    column -t -s "|" -R0 | \
    fzf \
        --ansi \
        --with-nth=1.. \
        --prompt="Install> " \
        --preview-window "nohidden,40%,<50(down,50%,border-rounded)" \
        --preview "flatpak --system remote-info flathub {-1} | awk -F':' -v YLW='$YLW' -v BLD='$BLD' -v RST='$RST' -v WHT='$WHT' '{print YLW BLD \$1 RST WHT \$2}'" \
        --bind "enter:execute(flatpak install flathub {-1} </dev/tty)"

    commandline -f repaint
end

# ==========================================
# ❌ fzf-flatpak-uninstall-widget
# ==========================================
function fzf-flatpak-uninstall-widget
    set -l RED (tput setaf 1); set -l BLD (tput bold); set -l RST (tput sgr0)
    touch /tmp/uns

    flatpak list --columns=application,name | \
    awk -v cyn=(tput setaf 6) -v blu=(tput setaf 4) -v bld=(tput bold) -v res=(tput sgr0) '
    {
        app_id="";
        for(i=2;i<=NF;i++){
            app_id" "$i
        };
        print bld cyn $2 " - " res blu $1
    }' | \
    column -t | \
    fzf \
        --ansi \
        --with-nth=1.. \
        --prompt="  Uninstall> " \
        --header="M-u: Uninstall | M-r: Run" \
        --header-first \
        --preview-window "nohidden,50%,<50(up,50%,border-rounded)" \
        --preview "flatpak info {3} | awk -F':' -v RED='$RED' -v BLD='$BLD' -v RST='$RST' '{print RED BLD \$1 RST \$2}'" \
        --bind "alt-r:change-prompt(Run > )+execute-silent(touch /tmp/run && rm -f /tmp/uns)" \
        --bind "alt-u:change-prompt(Uninstall > )+execute-silent(touch /tmp/uns && rm -f /tmp/run)" \
        --bind "enter:execute(
        if [ -f /tmp/uns ]; then
            flatpak uninstall -y {3} </dev/tty;
        elif [ -f /tmp/run ]; then
            flatpak run {3} </dev/tty;
        fi
        )" 

    rm -f /tmp/uns /tmp/run &>/dev/null
    commandline -f repaint
end

# إعداد الاختصارات
function fish_user_key_bindings
    bind \ef\ei fzf-flatpak-install-widget
    bind \ef\eu fzf-flatpak-uninstall-widget
end
