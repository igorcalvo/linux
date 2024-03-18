if status is-interactive
    # Commands to run in interactive sessions can go here
end
alias gedit "gnome-text-editor"
alias wallpaper "dconf write /org/gnome/desktop/background/picture-options \"'spanned'\""
alias mouse "sh /home/calvo/Code/Scripts/track-mouse.sh"
alias sudo "command sudo"
alias python "command python3"
alias nvim2 "/home/calvo/.cargo/bin/neovide"
alias disk "ncdu"
alias cat "command batcat"
alias ls "command eza"
alias rm "command trash"

zoxide init fish --cmd cd | source

# bind -k sf forward-word
