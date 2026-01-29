# Load profile
# source global shell alias & variables files
[ -f "$HOME/.zprofile" ] && source $HOME/.zprofile
[ -f "$XDG_CONFIG_HOME/shell/aliases" ] && source "$XDG_CONFIG_HOME/shell/aliases"

# --------------------
# Prompt Config
# --------------------
source "$HOME/.config/shell/plugins/zsh-transient-prompt/transient-prompt.zsh-theme"
eval "$(starship init zsh)"

# 1. البرومبت الأساسي (قبل التنفيذ)
TRANSIENT_PROMPT_PROMPT='$(starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_RPROMPT='$(starship prompt --right --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'

# 2. البرومبت الانتقالي اليسار (مع سطر جديد)
TRANSIENT_PROMPT_TRANSIENT_PROMPT=$'\n''$(starship module character)'

# TRANSIENT_PROMPT_TRANSIENT_RPROMPT='%F{#6c7086}%D{%Y-%m-%d %H:%M:%S}%f'

# --------------------
# Zoxide
# --------------------
eval "$(zoxide init zsh)"
alias cd=z

# --------------------
# Vim mode
# --------------------
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

# Cursor shape for vi mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q'   # block cursor
  else
    echo -ne '\e[5 q'   # beam cursor
  fi
}
zle -N zle-keymap-select

# Set cursor on startup
echo -ne '\e[5 q'

# --------------------
# History
# --------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

# --------------------
# Completion
# --------------------
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --------------------
# fzf
# --------------------
source ~/.config/shell/plugins/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' use-fzf-default-opts yes

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# --------------------
# Autosuggestions (ghost text)
# --------------------
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# --------------------
# autocd
# --------------------
setopt autocd

# --------------------
# Keymap
# --------------------
# Change clear to ALT+L
# bindkey -r '^L'
bindkey '\el' clear-screen

# --------------------
# Yazi with cwd change
# --------------------
function yazi_cd() {
  local cache_dir tmp

  # Prefer XDG cache, fallback to /tmp
  cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/yazi"
  mkdir -p "$cache_dir"

  tmp="$(mktemp "$cache_dir/cwd.XXXXXX")"

  # Check if we have permission to access cwd
  if [ -r "$PWD" ] && [ -x "$PWD" ]; then
    yazi --cwd-file="$tmp"
  else
    sudo -E yazi --cwd-file="$tmp"
  fi

  if [ -f "$tmp" ]; then
    local dir
    dir="$(cat "$tmp")"
    if [ -d "$dir" ]; then
      cd "$dir"
      zle reset-prompt
    fi
    rm -f "$tmp" &> /dev/null
  fi
}

zle -N yazi_cd
bindkey '^[f' yazi_cd   # Alt+F


# --------------------
# Paste bin
# --------------------
# paste to paste.rs
function paste() {
  local file url ext final_url

  file="${1:-/dev/stdin}"

  # get extension if file exists
  if [[ -f "$file" && "$file" == *.* ]]; then
    ext=".${file##*.}"
  else
    ext=""
  fi

  url=$(curl -fsS --data-binary @"$file" https://paste.rs) || return 1
  final_url="${url}${ext}"

  echo "$final_url"

  # copy to clipboard
  if command -v wl-copy >/dev/null; then
    echo -n "$final_url" | wl-copy
  elif command -v xclip >/dev/null; then
    echo -n "$final_url" | xclip -selection clipboard
  fi
}

# delete paste.rs paste
function paste-del() {
  local id

  id="$1"

  if [[ -z "$id" ]]; then
    echo "❌ usage: paste-del <id|url>"
    return 1
  fi

  # extract id if full URL
  id="${id##*/}"

  curl -fsS -X DELETE "https://paste.rs/$id" \
    && echo "🗑️ deleted: $id"
}

# --------------------
# Syntax highlighting (LAST)
# --------------------
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/shell/catppuccin_mocha-zsh-syntax-highlighting.zsh
eval "$(zellij setup --generate-auto-start zsh)"
