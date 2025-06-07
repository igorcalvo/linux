```
                   -`                
                  .o+`               
                 `ooo/               
                `+oooo:              
               `+oooooo:             
               -+oooooo+:            
             `/:-:++oooo+:           
            `/++++/+++++++:          
           `/++++++++++++++:         
          `/+++ooooooooooooo/`       
         ./ooosssso++osssssso+`      
        .oossssso-````/ossssss+`     
       -osssssso.      :ssssssso.    
      :osssssss/        osssso+++.   
     /ossssssss/        +ssssooo/-   
   `/ossssso+/:-        -:/+osssso+- 
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+
 .`                                 `/
```

### TODO
color.sh

### Arch Install
#### 0. Getting image ready
```bash
https://archlinux.org/download/

sha256sum -b yourfile.iso
gnome-disks
# https://etcher.balena.io/#download-etcher
```

#### 1. Verifying boot and maybe setting font
```bash
efivar -l

setfont ter-u20b
```

#### 2. Internet connection
```bash
ip link

iwctl
help
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect ¨AP 81 - 5G¨
exit

ping archlinux.org
```

#### 3. Disk partitioning

| Type | Size |
|--------------- | --------------- |
| EFI | +2G |
| SWAP | +16G |
| ROOT | |
<!-- |    |    | -->

If disk is in use, might have to reboot right after creating partition
##### Patitioning
```bash
fdisk -l
fdisk /dev/nvme0n1
m
p
l
n
t

1 19 23
...
w
```

##### Types
```bash
mkfs.fat -F32 /dev/nvme0n1p5
mkswap /dev/nvme0n1p6
mkfs.ext4 /dev/nvme0n1p7
```

##### Mounting
```bash
# mount -o fmask=0077,dmask=0077 --mkdir /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p7 /mnt
mount --mkdir /dev/nvme0n1p5 /mnt/boot
swapon /dev/nvme0n1p6
```

#### 4. Update Image & Root
##### Basics
```bash
sudo pacman -Sy archlinux-keyring pacman-contrib
```

##### Pacman
```bash
vim /etc/pacman.conf

parallel 10
uncomment colors
```

##### Image
```bash
pacstrap -K /mnt base linux linux-firmware
```

##### Fstab
```bash
genfstab -U -p /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab
```

##### Chroot & Mounting
```bash
arch-chroot /mnt
mount --mkdir /dev/nvme0n1p2 /mnt/win #(windows EFI)
mount --mkdir /dev/nvme0n1p5 /mnt/boot/efi #(Arch EFI)
```

##### Install Basics to disk
```bash
pacman -Sy --needed neovim archlinux-keyring pacman-contrib
```

#### 5. Pacman
##### Mirrors
```bash
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
```

##### Parallel and 32bit
```bash
vim /etc/pacman.conf

color
parallel 15
/multilib
```

##### Essentials
```bash
pacman -Syu
pacman -S --needed sudo amd-ucode linux-headers networkmanager git base-devel stow openssh kitty wl-clipboard

intel-ucode
iucode-tool 
dhcpcd 
```

#### 6. Config 
##### Language
```bash
nvim /etc/locale.gen

/en_US.UTF-8
```

##### Time
```bash
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

ln -s /usr/share/zoneinfo/America/Sao_Paulo > /etc/localtime
hwclock --systohc --utc
```

##### Hostname
hostname = machine name
```bash
echo arch-hostname > /etc/hostname
nvim /etc/hosts

127.0.0.1 localhost
127.0.0.1 arch-pc
```

##### User
```bash
passwd
useradd -m -g users -G wheel,storage,power,plugdev -s /bin/bash calvo
passwd calvo

EDITOR=nvim visudo
/%wheel # just to find it

# User privilege specification
root	ALL=(ALL:ALL) ALL
calvo	ALL=(ALL) ALL

G
Defaults rootpw
```

#### 8. Boot
##### Grub
```bash
pacman -S --needed grub efibootmgr os-prober

mount --mkdir /dev/nvme0n1p2 /mnt/win #(windows EFI)
mount --mkdir /dev/nvme0n1p5 /mnt/boot/efi #(Arch EFI)

grub-install --target=x86_64-efi --efi-directory=/mnt/win --bootloader-id=GRUB
grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id=GRUB

nvim /etc/default/grub
GRUB_DISABLE_OS_PROBER=false
GRUB_DISABLE_SUBMENU=y
GRUB_SAVEDEFAULT=true
GRUB_COLOR_NORMAL="light-blue/black"
GRUB_COLOR_HIGHLIGHT="light-cyan/black"
GRUB_TIMEOUT=3
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet ipv6.disable=1 pcie_aspm=off"
GRUB_DEFAULT=saved

os-prober
grub-mkconfig -o /boot/grub/grub.cfg
cat /etc/fstab
```

#### 9. Nvidia & Image
```bash
sudo pacman -S nvidia-open-dkms linux-headers nvidia-utils lib32-nvidia-utils egl-wayland libglvnd lib32-libglvnd opencl-nvidia lib32-opencl-nvidia nvidia-settings
```

```bash
nvim /etc/modprobe.d/nvidia.conf

option nvidia_drm modeset=1
```

##### Config
```bash
nvim /etc/mkinitcpio.conf

MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
HOOKS(= -kms)
```

##### Hooks
```bash
mkdir /etc/pacman.d/hooks
nvim /etc/pacman.d/hooks/nvidia.hook

[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = nvidia

[Action]
Depends = mkinitcpio
When = PostTransaction
Exec = /usr/bin/mkinitcpio -P
```

```bash
nvim /etc/pacman.d/hooks/grub.hook

[Trigger]
Type = File
Operation = Install
Operation = Upgrade
Operation = Remove
Target = usr/lib/modules/*/vmlinuz

[Action]
Description = Updating grub configuration ...
When = PostTransaction
Exec = /usr/bin/grub-mkconfig -o /boot/grub/grub.cfg
```

```bash
mkinitcpio -P
```

#### 10. Services
```bash
sudo systemctl enable fstrim.timer |
sudo systemctl enable NetworkManager.service |
sudo systemctl enable systemd-resolved |
sudo systemctl enable paccache.timer
```

#### 11. Reboot
```bash
exit (until red)
umount -R /mnt
reboot
```

#### 12. Internet
```bash
nmtui
ping archlinux.org

ip link

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
```

#### 13. Display Manager
```bash
sudo pacman -S hyprland
Hyprland

super + q
super + c
```

#### 14. YAY & Browser
```bash
sudo pacman -Syu

cd apps
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

```bash
yay -S librewolf-bin

Settings
    Enable Firefox Sync
    Log in
    Ask to save passwords
    Remove Import Bookmarks
    Save downloads folder
    Always ask you where to save files
    Search engine
    Theme
```

#### 15. Clone repos
```bash
cd
ssh-keygen -t rsa
cd /home/calvo/.ssh

cat id_rsa.pub
xclip -sel c id_rsa.pub

librewolf
clone linux
clone scripts
```

#### 16. Directories
```bash
sh ~/code/scripts/dirs.sh
```

#### 17. Installing
##### Libraries
```bash
sudo pacman -S --needed noto-fonts-cjk noto-fonts-emoji noto-fonts gnu-free-fonts \
ttf-jetbrains-mono ttf-liberation noto-fonts-emoji vulkan-icd-loader ttf-space-mono-nerd\
otf-font-awesome lib32-vulkan-icd-loader vulkan-tools ttf-nerd-fonts-symbols-mono fuse2 \
fuse3 libxkbcommon-x11 unrar p7zip clutter clutter-gtk inkscape xorg-xcursorgen ripgrep \
playerctl lm_sensors xdg-user-dirs-gtk gnome-backgrounds sox dosfstools composer unzip \
wget less python-pip dconf pipewire pipewire-audio pipewire-alsa pipewire-pulse wireplumber \
qt5-wayland qt6-wayland xdg-desktop-portal-hyprland xcur2png fd
```

```bash
vulkan-intel
lib32-vulkan-intel
```

##### Apps
```bash
sudo pacman -S --needed fastfetch qbittorrent screen nodejs npm \
calibre ffmpeg trash-cli xarchiver fish jq fzf tldr bat eza zoxide mpv \
stress glmark2 neovide fail2ban ufw imagemagick yazi pavucontrol\
python-weasyprint clipcat calcurse nautilus iftop figlet gnome-disk-utility \
progress evince docker lazygit ncdu drawing speedtest-cli wev hyprpicker \
wl-clipboard imv cliphist fuzzel gimp wofi man-db man-pages mako \
hyprpaper hyprsunset hyprcursor grim slurp sddm pandoc
```

```bash
krita
steam
discord
taskwarrior-tui
```

##### AUR
```bash
yay -S polychromatic wezterm qdirstat-bin youtube-music-bin ttf-juliamono \
ttf-weather-icons ttf-kanjistrokeorders cava fish-done cheat-bin librewolf-bin \
ttf-joypixels
```

```bash
###### Android
yay -S android-sdk-build-tools android-sdk-cmdline-tools-latest android-platform android-sdk-platform-tools android-sdk
```

```bash
tetrio
vscodium
zoom
anki
ahk_x11-bin
chatgpt-shell-cli 
```

##### GPT
###### Consider AUR instead
```bash
https://github.com/kardolus/chatgpt-cli

curl -L -o chatgpt https://github.com/kardolus/chatgpt-cli/releases/latest/download/chatgpt-linux-amd64 && chmod +x chatgpt && sudo mv chatgpt /usr/local/bin/
set -Ux OPENAI_API_KEY $(openssl enc -aes-256-cbc -pbkdf2 -d -in ~/gpt.enc -pass pass:gpt)
chatgpt --config
chatgpt --set-model gpt-4
```

##### OLLAMA
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama --version
sudo systemctl enable ollama.service
ollama run deepseek-r1:7b
ollama run llama3.2
```

```bash
sudo pacman -Sy
sudo pacman -S docker nvidia-container-toolkit --needed
sudo usermod -aG docker $USER
bash
newgrp docker
systemctl enable docker.service --now
reboot

docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main
docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 -e ENABLE_RAG_WEB_SEARCH=true --name open-webui --restart always ghcr.io/open-webui/open-webui:main
docker ps -a
docker stop

Settings -> Admin Settings -> Web Search
Download web search tool
```

##### VM
```bash
sudo pacman -S qemu-full libvirt dnsmasq dmidecode lxqt-policykit virt-manager --needed
sudo systemctl enable libvirtd --now
sudo systemctl enable dnsmasq.service --now
sudo usermod -aG libvirt $USER

reboot
virt-manager

virsh net-list --all
sudo virsh net-start default
virsh net-autostart default
bash
```

```bash
cat <<EOF | virsh net-define /dev/stdin
<network>
  <name>default</name>
  <uuid>$(uuidgen)</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
EOF
```

```bash
https://www.microsoft.com/en-us/software-download/windows10iso
https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers
https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso
```

1. add Channel (qemu-ga)
2. vCPU = 4; Copy host CPU configuraion (host-passthrough); 1, 4, 1 (4 Cores)
3. Video Virtio (no 3D acceleatarion)
4. mount visio drivers img
5. install it from inside VM
6. reboot
7. `wmic cpu get NumberOfCores,NumberOfLogicalProcessors`

#### 18. Python
```bash
sudo pacman -S python-pandas python-numpy python-scipy python-matplotlib python-beautifulsoup4 \
python-openpyxl python-requests python-pyperclip python-opencv python-debugpy python-pywal \
python-virtualenv jupyter-notebook yt-dlp python-flask python-pillow python-numba \
cython mypy --needed
```

```bash
yay -S python-pipreqs python-pyautogui python-translate
```

```bash
pipx ensurepath

sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED

python-pipx 
python-yarg 
selenium 
```


#### 19. Websites
##### AppImages
```bash
https://www.onlyoffice.com/download-desktop.aspx
https://github.com/Nixola/VRRTest/releases/
```

##### Must Compile
[Btop](https://github.com/aristocratos/btop?tab=readme-ov-file#compilation-linux) 
```bash
cd ~/apps
git clone https://github.com/aristocratos/btop.git
cd btop
make GPU_SUPPORT=true VERBOSE=true
sudo make install
```

#### 20. Stow
```bash
stow --target="/home/calvo" --dir="/home/calvo/code/linux/dotfiles" -v --simulate . 
stow --target="/home/calvo" --dir="/home/calvo/code/linux/dotfiles" -v --adopt . 
sh ~/code/scripts/define-links.sh

cd ~/code/linux/dotfiles/.config/
mkdir x 
mv ~/.config/x/* ~/code/linux/dotfiles/x
stow --target="/home/calvo/.config/x" --dir="/home/calvo/code/linux/dotfiles/.config/x" -v --simulate .
```

#### 21. System Config
##### Directories
```bash
rm Pictures Music Videos Documents Downloads Templates Public Desktop

cp ~/code/linux/files/icons/* ~/images/icons/
sudoedit /etc/xdg/user-dirs.defaults
nvim ~/.config/user-dirs.dirs
```

##### Misc I
```bash
dconf write /system/locale/region "'en_GB.UTF-8'" |
git config --global user.email "igorcalvob@gmail.com" |
git config --global user.name "igorcalvo" | 
systemctl --user enable --now hyprpolkitagent.service |
sudo locale-gen en_US.UTF-8 |
export LANG=en_US.UTF-8 |
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

##### Audio
```bash
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service
pactl info
```

##### NOT NEEDED ANYMORE
```bash
xdg-settings set default-web-browser firefox.desktop
```

##### Time
```bash
timedatectl set-timezone America/Sao_Paulo |
timedatectl set-ntp true |
timedatectl status
```

```bash
reboot
```

##### Misc II
```bash
sudo modprobe razerkbd
sudo gpasswd -a $USER plugdev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo sensors-detect

sudo pacman -S bluez
sudo systemctl enable bluetooth 
```

##### Neovim
```bash
cd ~/.local/share/nvim/mason/
img ~/code/linux/mason.png
:MasonUpdate

cd ~/.local/share/nvim/lazy/markdown-preview.nvim
npm i
```

/![Mason](./mason.png)

##### Fish
```bash
fish_update_completions
mkdir ~/.config/fish/completions/
cp /usr/share/fish/completions/*  ~/.config/fish/completions/
cp ~/.cache/fish/generated_completions/* ~/.config/fish/completions/
mv ~/.config/fish/completions/convert.fish ~/.config/fish/completions/magick.fish
sed -i 's/convert/magick/g' ~/.config/fish/completions/magick.fish
cat ~/.config/fish/completions/magick.fish | head -n 10
```

##### Pacman & Haskel
```bash
pacman -Qq | grep '^haskell' | tr '\n' ' '

sudoedit /etc/pacman.conf
/ignore
```

#### 23. Files
```bash
start krita
cp ~/code/linux/files/krita-workspace.kws ~/.local/share/krita/workspaces/

cp ~/code/linux/files/icons/* ~/images/icons/

MEGA
```

#### 24. Applications
```
Razer
    500 Dpi
Qbittorrent
    Downloads
        destination at ~/downloads/
        disable popup
    Behavior
        confirm when deleting torrents false
Steam
    Login
    In Game
        FPS Counter Top Right
        High Contrat True
    Notifications
        Disable friend join game
    Compatibility
        Enable Steam Play for all other titles
            Proton 9.0-2
    cs2 launch options
        -fullscreen -sdlaudiodriver pipewire
Discord
    Login
    Voice & Video Defaults
    Keybindings
        Toggle Mute
        Push to Mute
Youtube Music
    Login
LibreWolf
    Download directory
    Remove
        Import bookmarks
    Icons and Logins
    Theme Catpuccin Teal
    Search -> Brave
    Extensions
        Blocksite
            chess.com
            lichess.org
            p
    Unhook
        Recommended
    Youtube Enhancer
        Dark theme
        Place Controls Within the Player
        1080
    Momentum
        New tab -> Name
Krita
    Load workspace -> Last
    Themes -> Krita Darker
Pavucontrol
    Configuration
        Disable what's necessary
    Input Devices
        150%
```

#### 25. Security
```bash
sudo ufw limit 22/tcp |
sudo ufw allow 80/tcp |
sudo ufw allow 443/tcp |
sudo ufw allow from 88.99.58.246 |
sudo ufw default deny incoming |
sudo ufw enable
```

```bash
# https://www.networkworld.com/article/968526/linux-firewall-basics-with-ufw.html

iftop
anki
ping sync3.ankiweb.net
allow from
```

```bash
sudoedit /etc/fail2ban/jail.local

[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
```

```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

#### 26. Backup Kernel
```bash
sudo pacman -S linux-zen-headers linux-zen
# nvidia-lts
```

#### 27. Ricing
##### Display Manager
```bash
https://github.com/Keyitdev/sddm-astronaut-theme/tree/master?tab=readme-ov-file
sudoedit /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
sudoedit /usr/share/sddm/scripts/Xsetup

xrandr --output HDMI-A-1 --mode 1920x1080@240 --pos 0x0 \
       --output DP-1 --mode 1920x1080@240 --pos 1920x0
```

##### Cursors
Volantes Cursors
Light
https://github.com/varlesh/volantes-cursors
https://www.gnome-look.org/p/1356095

```bash
cd apps
git clone git@github.com:varlesh/volantes-cursors.git
cd volantes-cursors

# Hyprland
sudo mkdir hypr
hyprcursor-util --extract volantes_light_cursors -o hypr
cd hypr
sudo nvim manigest.hl

name = VolantesLightHypr
description = Volantes Light Hyprcursor
:wq

sudo mkdir result
hyprcursor-util --create hypr -o result
sudo mv result ../VolantesLightHypr
# /usr/share/icons/VolantesLightHypr
```

##### Wallpaper
1. Get it
2. Hyprpaper
```bash
hyprctl monitors
preload = /home/calvo/images/wallpapers/2025-06/l.png
preload = /home/calvo/images/wallpapers/2025-06/r.png
wallpaper = HDMI-A-1, /home/calvo/images/wallpapers/2025-06/l.png
wallpaper = DP-1, /home/calvo/images/wallpapers/2025-06/r.png
```

##### Colors
```bash
edit ~/colors.sh
python ~/code/rice/load_colors.py
python ~/code/rice/offset_colors.py ~/.config/rofi/rounded-pink-dark.rasi 0.5
nvim ~/code/rice/wallpaper.sh
```

#### 30. Gaming
##### Zelda 3Ds
```bash
stow
```

##### Ship
```bash
cp ~/code/linux/files/games/shipofharkinian.json ~/apps/appimages/soh/
```

