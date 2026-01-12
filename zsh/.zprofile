#!/bin/sh
# env vars to set on login, zsh settings in ~/config/zsh/.zshrc
# add `export ZDOTDIR="$HOME/.config/zsh"` to /etc/zsh/zshenv in order to place this file at .config/zsh/.zprofile
#
# default programs
export EDITOR="nvim"
export TERM="ghostty"
export TERMINAL="ghostty"
export MUSPLAYER="termusic"
export BROWSER="zen-browser"

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# history files
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# add scripts to path
export PATH="$XDG_CONFIG_HOME/scripts:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# moving other files and some other vars
export DATE=$(date "+%A, %B %e  %_I:%M%P")

# bg+:#313244,bg:#1E1E2E,
# --color=selected-bg:#45475A \
# ,label:#CDD6F4
export FZF_DEFAULT_OPTS=" \
--style minimal \
--preview='bat -p --color=always {}' \
--layout=reverse \
--height 30% \
--color=bg+:#181825,gutter:#313244,spinner:#fab387,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#F5E0DC,pointer:#fab387 \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#F5E0DC,hl+:#F38BA8 \
--color=border:#6C7086"
export FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS --info inline --no-sort --no-preview" # separate opts for history widget
export MANPAGER="less -R --use-color -Dd+r -Du+b" # colored man pages

# colored less + termcap vars
export LESS="R --use-color -Dd+r -Du+b"
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
