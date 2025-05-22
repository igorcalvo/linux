if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr -a wallpaper-set --set-cursor -- "nitrogen % --set-auto --save"
abbr -a gpt-latest-parse --set-cursor -- "cat % | jq 'sort_by(.created) | reverse | .[0].id'"
abbr -a encrypt --set-cursor -- "openssl enc -aes-256-cbc -pbkdf2 -salt -in % -out % -pass pass:gpt"
abbr -a decrypt --set-cursor -- "openssl enc -aes-256-cbc -pbkdf2 -d -in % -pass pass:gpt"
abbr -a f --set-cursor -- 'cd / | sudo find . -name "*%*"'
abbr -a hs --set-cursor "history search --contains %"

alias mouse "sh /home/calvo/code/scripts/track-mouse.sh"
alias sudo "command sudo"
alias python "command python3"
alias nvim2 "command screen -d -m /usr/bin/neovide"
alias disk "screen -d -m qdirstat"
alias cat "command bat"
alias ls "command eza"
alias rm "command trash"
alias tasks "nvim ~/lists/tasks.txt"
alias fs "yazi"
alias services "systemctl list-unit-files | grep enabled"
alias cal "cal 2025 --monday"
alias neofetch "command fastfetch"
alias img "command wezterm imgcat"
alias grub-update "sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias network "iftop"
alias bigprint "command figlet -f big -t -c"
alias s "command screen -d -m"
alias copy "command xclip -sel c"
alias pdf "command screen -d -m evince"
alias reset-mouse "sh /home/calvo/code/scripts/reset-mouse.sh"
alias reset-mouse-laptop "sh /home/calvo/code/scripts/reset-mouse.laptop.sh"
alias workout "wezterm imgcat ~/documents/workout.png"
alias download-music "command yt-dlp --extract-audio --audio-format mp3 --audio-quality 0"
alias download-video "command yt-dlp"
alias gpt "chatgpt -t 0.5 -m gpt-4o-2024-11-20"
alias webcam "screen -d -m mpv av://v4l2:/dev/video0"
alias btop "screen -d -m tilix"
alias lg "lazygit"
alias unzip "screen -d -m xarchiver"
alias yay-updates "grep '\[ALPM\] upgraded' /var/log/pacman.log"
alias yay-clean "command yay -Sc"
alias pacman-clean "command sudo pacman -Sc"
alias disks "ncdu"
alias keys "wev"

### OUTDATED
## GNOME
# alias gedit "command gnome-text-editor"
# alias wallpaper "dconf write /org/gnome/desktop/background/picture-options \"'spanned'\""
## OTHERS
# alias memory "python /home/calvo/code/memory/main.py"
# alias learn-java "screen -d -m sh .local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea.sh"
# alias gpt "ollama run deepseek-r1:7b"

function tree
    eza --tree --level=$argv
end
# funcsave tree

function how
    tldr $argv; cheat $argv
end
# commandline -f execute

zoxide init fish --cmd cd | source
# bind -k sf forward-word

set -Ux EDITOR /usr/bin/nvim
set -Ux SUDO_EDITOR /usr/bin/nvim
set -Ux VISUAL /usr/bin/nvim
set -Ux ANDROID_HOME /opt/android-sdk
set -Ux XDG_CONFIG_HOME $HOME/.config
# set -Ux OPENAI_API_KEY$(decrypt -in ~/documents/gpt.enc -pass pass:gpt)

# fish_add_path ~/.local/bin/
