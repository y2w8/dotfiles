# source ~/.config/fish/init.fish
source ~/.config/fish/aliases.fish
source ~/.config/fish/env.fish

bind \t fuzzy_complete
# function starship_transient_prompt_func
#   starship module character
# end
# function starship_transient_rprompt_func
#   starship module time
# end

function fish_user_key_bindings
    fish_vi_key_bindings
    
    # bind -M insert \t fuzzy_complete
    bind \el clear-screen
    bind -M insert \cf yazi_cd
end

if status is-interactive
  fish_config theme choose catppuccin-mocha --color-theme=dark
  set -g fish_greeting
    # Initializations
    zoxide init fish --cmd cd | source
    starship init fish | source
    # enable_transience
    eval (zellij setup --generate-auto-start fish | string collect)
    fastfetch
# Commands to run in interactive sessions can go here
end



# Added by Antigravity CLI installer
set -gx PATH "/home/y2w8/.local/bin" $PATH
