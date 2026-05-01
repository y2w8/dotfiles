# env vars to set on login, zsh settings in ~/config/zsh/.zshrc
# add `export ZDOTDIR="$HOME/.config/zsh"` to /etc/zsh/zshenv in order to place this file at .config/zsh/.zprofile

# xdg stuff
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

set -gx XDG_DESKTOP_DIR "$HOME/Desktop"
set -gx XDG_DOWNLOAD_DIR "$HOME/Downloads"
set -gx XDG_TEMPLATES_DIR "$HOME/Templates"
set -gx XDG_PUBLICSHARE_DIR "$HOME/Public"
set -gx XDG_DOCUMENTS_DIR "$HOME/Documents"
set -gx XDG_MUSIC_DIR "$HOME/Music"
set -gx XDG_PICTURES_DIR "$HOME/Pictures"
set -gx XDG_VIDEOS_DIR "$HOME/Videos"
set -gx XDG_PROJECTS_DIR "$HOME/Projects"

# default programs
set -gx EDITOR nvim
set -gx TERM xterm-256color
set -gx TERMINAL alacritty
set -gx MUSPLAYER termusic
set -gx BROWSER zen-browser

# history files
set -gx LESSHISTFILE "$XDG_CACHE_HOME/less_history"
set -gx PYTHON_HISTORY "$XDG_DATA_HOME/python/history"

# add scripts to path
fish_add_path "$XDG_CONFIG_HOME/scripts"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.rustowl"
fish_add_path "$HOME/.local/bin"

# moving other files and some other vars
set -gx DATE $(date "+%A, %B %e  %_I:%M%P")

# bg+:#313244,bg:#1E1E2E,
# --color=selected-bg:#45475A \
# ,label:#CDD6F4
set -gx FZF_DEFAULT_OPTS " \
--style minimal \
--preview='[ -d {} ] && eza -lh --icons --group-directories-first --color=always {} || bat -p --color=always {}' \
--layout=reverse \
--prompt="❯  " \
--height 50% \
--color=bg+:#181825,gutter:#313244,spinner:#fab387,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#F5E0DC,pointer:#fab387 \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#F5E0DC,hl+:#F38BA8 \
--color=border:#6C7086"
set -gx FZF_CTRL_R_OPTS "$FZF_DEFAULT_OPTS --info inline --no-sort --no-preview" # separate opts for history widget
set -gx MANPAGER "less -R --use-color -Dd+r -Du+b" # colored man pages

# colored less + termcap vars
set -gx LESS "R --use-color -Dd+r -Du+b"
set -gx LESS_TERMCAP_mb "$(printf '%b' '[1;31m')"
set -gx LESS_TERMCAP_md "$(printf '%b' '[1;36m')"
set -gx LESS_TERMCAP_me "$(printf '%b' '[0m')"
set -gx LESS_TERMCAP_so "$(printf '%b' '[01;44;33m')"
set -gx LESS_TERMCAP_se "$(printf '%b' '[0m')"
set -gx LESS_TERMCAP_us "$(printf '%b' '[1;32m')"
set -gx LESS_TERMCAP_ue "$(printf '%b' '[0m')"
