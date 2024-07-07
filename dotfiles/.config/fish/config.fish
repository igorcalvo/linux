if status is-interactive
    # Commands to run in interactive sessions can go here
end
alias gedit "gnome-text-editor"
alias wallpaper "dconf write /org/gnome/desktop/background/picture-options \"'spanned'\""
alias mouse "sh /home/calvo/code/scripts/track-mouse.sh"
alias sudo "command sudo"
alias python "command python3"
alias nvim2 "/usr/bin/neovide"
alias disk "ncdu"
alias cat "command bat"
alias ls "command eza"
alias rm "command trash"
# alias tasks "command taskwarrior-tui"
alias tasks "nvim ~/lists/tasks.txt"
alias fs "yazi"
alias services "systemctl list-unit-files | grep enabled"
alias calendar "cal 2024 --monday"
alias neofetch "command fastfetch"
alias img "command wezterm imgcat"

zoxide init fish --cmd cd | source

# bind -k sf forward-word
