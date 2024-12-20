if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias gedit "command gnome-text-editor"
# alias wallpaper "dconf write /org/gnome/desktop/background/picture-options \"'spanned'\""
# nitrogen ~/images/wallpapers/2024-06/pc/wallpaper5.png --set-auto --save
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
alias grub-update "sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias network "iftop"
alias bigprint "command figlet -f big -t -c"
alias s "command screen -d -m"
alias copy "command xclip -sel c"
alias pdf "command screen -d -m evince"
alias memory "python /home/calvo/code/memory/main.py"
alias reset-mouse "sh /home/calvo/code/scripts/reset-mouse.sh"
alias workout "command wezterm imgcat ~/documents/workout.png"
alias learn-java "screen -d -m sh .local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea.sh"
alias download-music "command yt-dlp --extract-audio --audio-format mp3 --audio-quality 0"
alias download-video "command yt-dlp"

function tree
    eza --tree --level=$argv
end
# funcsave tree

zoxide init fish --cmd cd | source
# bind -k sf forward-word

set -Ux EDITOR /usr/bin/nvim
set -Ux SUDO_EDITOR /usr/bin/nvim
set -Ux VISUAL /usr/bin/nvim
