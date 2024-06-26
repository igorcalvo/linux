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

### Arch Install
#### 0. Getting image ready
```bash
https://archlinux.org/download/
sha256sum -b yourfile.iso

https://etcher.balena.io/
```

#### 1. Verifying boot and setting font
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

#### 3. Disk partiotioning

| Type | Size |
|--------------- | --------------- |
| EFI | +1G |
| SWAP | +4G |
| ROOT | |
<!-- |    |    | -->

If disk is in use, might have to reboot right after creating partition
```bash
fdisk -l
fdisk /dev/nvme0n1
m
w

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
mount -o fmask=0077,dmask=0077 --mkdir /dev/nvme0n1p1 /mnt/boot
swapon /dev/nvme0n1p2
```

#### 4. Pacman mirrors
```bash
sudo pacman -Sy archlinux-keyring pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
```

#### 5. Update Image & Root
```bash
pacstrap -K /mnt base linux linux-firmware
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
arch-chroot /mnt
pacman -S --needed neovim sudo intel-ucode iucode-tool linux-headers dhcpcd networkmanager git base-devel xclip tilix firefox stow pacman-contrib
```

#### 6. Language, Location & Time
```bash
nvim /etc/locale.gen
```
/en_US
/en_GB
/pt_BR.UTF-8
x #

```bash
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

ln -s /usr/share/zoneinfo/America/Sao_Paulo > /etc/localtime
hwclock --systohc --utc
timedatectl set-timezone America/Sao_Paulo
timedatectl
```

#### 7. Hostname & User
hostname = machine name
```bash
echo arch-hostname > /etc/hostname

passwd
useradd -m -g users -G wheel,storage,power -s /bin/bash calvo
passwd calvo
EDITOR=nvim visudo

/%wheel
x
G
Defaults rootpw
```

```bash
# User privilege specification
root	ALL=(ALL:ALL) ALL
calvo	ALL=(ALL) ALL
```

#### 8. Pacman config
```bash
vim /etc/pacman.conf

color
parallel 15
/multilib

pacman -Syu
```

<!-- TODO bootctl -> grub -->
#### 9. Boot
```bash
ls /sys/firmware/efi/efivars
mount -t efivarfs efivarfs /sys/firmware/efi/efivars/
bootctl install
nvim /boot/loader/entries/arch.conf
```

```
title Arch
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
```

```bash
echo ¨options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3) rw nvidia-drm.modeset=1¨ >> /boot/loader/entries/arch.conf
cat /boot/loader/entries/arch.conf
```

#### 10. Nvidia & Image
```bash
pacman -S nvidia-dkms libglvnd nvidia-utils opencl-nvidia lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings
nvim /etc/mkinitcpio.conf

MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
HOOKS(= -kms)
```

```bash
mkdir /etc/pacman.d/hooks
nvim /etc/pacman.d/hooks/nvidia.hook

[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia

[Action]
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P
```

```bash
mkinitcpio -P
```

#### 11. Services
```bash
sudo systemctl enable fstrim.timer |
sudo systemctl enable NetworkManager.service |
sudo systemctl enable bluetooth |
sudo systemctl enable paccache.timer
```

#### 12. Reboot
```bash
exit (until red)
umount -R /mnt
reboot
```

#### 13. Internet
```bash
nmtui
ping archlinux.org

ip link
sudo systemctl enable dhcpcd@wlo1.service
```

#### 14. Display Manager
```bash
sudo pacman -S xorg gnome --needed

enter
? = backgrounds
4,6,8,14,15,16,18,20,23,25,26,28,48,58, ?

gdm
calculator
chracters
control-center
disk-utility
font-viwer
logs
menus
session
shell
shell-extensions
system-monitor
nautilus
user-dirs-gtk
```

```bash
sudo systemctl start gdm

sudo systemctl enable gdm
systemctl reboot
```

#### 15. Gnome Settings 
```
Displays
    Layout
    Frequencies
Multitasking
    General
        Hot Corner
            Off
    Workspaces
        1
Appearance
    Dark
Power
    Dim Screen
    Screen Blank
        5 Minutes
    Automatic Suspend
        When on Battery
    Power Button
        Suspend / Power Off
    Show Batter Percentage
        On
Mouse & Touchpad
    Mouse
        Mouse Acceleration
            Off
    Touchpad
        Secondary Click
            Corner Push
System
    Region & Language
        Language    - English (US)
        Formats     - United Kingdom
    Date & Time
        Automatic Date & Time
            On
        Time Zone
            Sao Paulo, Brazil
```

```bash
dconf write /org/gnome/desktop/background/picture-options "'spanned'" |
dconf write /org/gnome/desktop/wm/preferences/focus-new-windows "'smart'" |
dconf write /org/gnome/settings-daemon/plugins/media-keys/volume-step 2 |
dconf write /org/gnome/desktop/interface/clock-show-seconds true |
dconf write /org/gnome/desktop/interface/clock-show-weekday true |
dconf write /org/gnome/desktop/interface/clock-show-date true |
dconf write /org/gnome/desktop/interface/clock-format "'24h'" |
dconf write /org/gnome/desktop/calendar/show-weekdate true |
dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled true |
dconf write /org/gnome/settings-daemon/plugins/color/night-light-schedule-automatic false |
dconf write /org/gnome/settings-daemon/plugins/color/night-light-schedule-from 20 |
dconf write /org/gnome/settings-daemon/plugins/color/night-light-schedule-to 8 |
dconf write /org/gnome/settings-daemon/plugins/color/night-light-temperature 3165 |
dconf write /org/gnome/mutter/dynamic-workspaces false |
dconf write /org/gnome/desktop/interface/show-battery-percentage true |
dconf write /org/gnome/desktop/interface/color-scheme "'default'" |
dconf write /org/gnome/desktop/input-sources/mru-sources "[('xkb', 'us')]" |
dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'us'), ('xkb', 'us+intl')]" |
dconf write /system/locale/region "'en_GB.UTF-8'"
```

#### 16. Clone repos
```bash
ssh-keygen -t rsa
cd /home/calvo/.ssh
xclip -sel c id_rsa.pub
```

#### 17. Stow & Tilix
```bash
stow --target="/home/calvo" --dir="/home/calvo/code/linux/dotfiles" -v --simulate . 
stow --target="/home/calvo" --dir="/home/calvo/code/linux/dotfiles" -v --adopt . 

stow --dir="/home/calvo/.config/yazi" --target="/home/calvo/code/linux/dotfiles/.config/yazi" -v --simulate .
```

```bash
cd ~/code/linux
# dconf dump /com/gexperts/Terminix/ > terminix.dconf 
dconf load /com/gexperts/Tilix/ < tilix.dconf
```

#### 18. Yay
```bash
sudo pacman -Syu
# sudo pacman -S --needed base-devel git
cd 
mkdir apps
cd apps
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

#### 19. Installing
```bash
sudo pacman -S --needed noto-fonts-cjk noto-fonts-emoji noto-fonts gnu-free-fonts noto-fonts ttf-jetbrains-mono ttf-liberation noto-fonts-emoji vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools ttf-nerd-fonts-symbols-mono fuse2 fuse3 libxkbcommon-x11 unrar p7zip vulkan-intel lib32-vulkan-intel clutter clutter-gtk inkscape
```

```bash
sudo pacman -S --needed neofetch qbittorrent screen xdotool python-pip krita flameshot vlc nodejs npm calibre ffmpeg gnome-tweaks dconf-editor drawing trash-cli xarchiver-gtk2 fish jq fzf tldr bat stress glmark2 eza zoxide discord neovide fail2ban ufw steam imagemagick pavucontrol feh yazi pandoc python-weasyprint task taskwarrior-tui
```

```bash
yay -S polychromatic wezterm extension-manager qdirstat youtube-music vscodium ahk_x11 anki gdm-settings gwe
```

```bash
?
lm-sensors
pandoc
tetrio
```

#### 20. Websites
AppImages
```bash
https://www.onlyoffice.com/download-desktop.aspx
https://github.com/Nixola/VRRTest/releases/

```
Must Compile
[Btop](https://github.com/aristocratos/btop?tab=readme-ov-file#compilation-linux) 
```bash
cd ~/apps
git clone https://github.com/aristocratos/btop.git
cd btop
make GPU_SUPPORT=true VERBOSE=true
sudo make install
```

#### 21. System Config
```bash
git config --global user.email "igorcalvob@gmail.com" |
git config --global user.name "igorcalvo" |
export LC_CTYPE=en_US.UTF-8 |
export LC_ALL=en_US.UTF-8 |
xdg-settings set default-web-browser firefox.desktop |
sudo modprobe razerkbd
sudo gpasswd -a $USER plugdev
```
<!-- sudo sensors-detect -->

Default Apps
```
sudo nvim /usr/share/applications/mimeinfo.cache

/inode
d10w
/plain
d10w

inode/directory=org.gnome.Nautilus.desktop;
text/plain=neovide.desktop;nvim.desktop;org.gnome.gedit.desktop;

nvim ~/.local/share/applications/mimeinfo.cache
[MIME Cache]
inode/directory=org.gnome.Nautilus.desktop;
text/plain=neovide.desktop;nvim.desktop;org.gnome.gedit.desktop;

nvim ~/.config/mimeapps.list
[Default Applications]
application/x-ahk_x11=ahk_x11.desktop
text/html=firefox.desktop
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop
x-scheme-handler/about=firefox.desktop
x-scheme-handler/unknown=firefox.desktop
inode/directory=nautilus.desktop
```

#### 22. Directories
```bash
mkdir code |
mkdir Desktop |
mkdir documents |
mkdir videos |
mkdir downloads |
mkdir misc |
mkdir books |
mkdir images |
rm Pictures Music Videos Documents Downloads Templates Public |
mkdir apps |
cd apps |
mkdir appimages |
cd ..|
cd images |
mkdir icons |
mkdir wallpapers |
mkdir screenshots
```

```bash
cp ~/code/linux/files/icons/* ~/images/icons/
```

#### 23. Startup
- Gnome Tweaks
- Create app to run at startup

<!-- /usr/share/applications/ -->
```bash
~/.local/share/applications/
startup.desktop 

[Desktop Entry]
Name=Startup
Comment=Startup
Keywords=folder;manager;explore;disk;filesystem;
Exec=sh /home/calvo/code/scripts/startup.sh
# Exec=nautilus /home/calvo/book 
Icon=/home/calvo/images/icons/shuttle.png
Terminal=false
Type=Application
```

#### 24. Python
```bash
sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED
pip install pandas scipy mouse matplotlib Pillow tk selenium yt_dlp jupyter PyInstaller beautifulsoup4 openpyxl requests pyperclip opencv-python debugpy pipreqs pywal
pip install PySimpleGUI==4.60.5
sudo pacman -S python-virtualenv tk --needed
bash
PATH=$PATH:/home/calvo/.local/bin
XDG_DOWNLOAD_DIR=$HOME/downloads
sudo nvim /etc/xdg/user-dirs.defaults
nvim ~/.config/user-dirs.dirs
gsettings set org.gnome.shell app-picker-layout "[]"
```

#### 25. Keyboard Shortcuts
| Command   | Keys    |
|--------------- | --------------- |
| hide all windows      | sup + d           |
| 3x screenshot         | backspace         |
| hide window           | sup + down arrow  |
<!-- |    |    | -->

#### 26. Ricing
##### Cursors
Volantes Cursors
Light
https://github.com/varlesh/volantes-cursors
https://www.gnome-look.org/p/1356095

```bash
cd apps
git clone git@github.com:varlesh/volantes-cursors.git
cd volantes-cursors
sudo make build
sudo make install
```

##### Icons
Kora
Green or Yellow
https://www.gnome-look.org/s/Gnome/p/1256209
https://github.com/bikass/kora

```bash
cd apps
git clone git@github.com:bikass/kora.git
cd kora
cd apps/scalable
find . -name 'discord*' | xargs sudo rm {}
find . -name 'steam*' | xargs sudo rm {}
find . -name 'youtube*' | xargs sudo rm {}
cd ../..
rm icon-theme.cache
sh create-new-icon-theme.cache.sh
cd ..
sudo cp kora/ /usr/share/icons/
```

##### Theme
Marble Shell theme
https://www.gnome-look.org/p/1977647 <br><br>

```bash
git clone https://github.com/imarkoff/Marble-shell-theme.git
cd Marble-shell-theme
python install.py --blue --mode=dark --filled

cd ~/.themes/Marble-blue-dark/gnome-shell/
nvim gnome-shell.css

/ Panel
font-size: 15px;
/ Popovers
background: rgba(18, 20, 21, 1); 
```

Backups \
Cappuccin - https://github.com/catppuccin/gtk \
Flat Remix GNOME / GDM - https://www.gnome-look.org/p/1013030 \
Yaru-Colors - https://www.pling.com/p/1299514 \
Midnight-GnomeShell - https://www.gnome-look.org/p/1273210

##### Extensions
![extensions](./extensions.png)

 ```bash
dconf dump /org/gnome/shell/extensions/ > extensions.dconf
dconf load /org/gnome/shell/extensions/ < files/dumps/extensions.dconf
```

```
Impatience
    0.5
Dash to Dock
    Behavior
        Click action                Raise window
    Appearance
        Show overview on startup    false
        Use built-in theme          true
Just Perfection
    Behavior
        Startup Status              Desktop
Gt4 Desktop Icons
    Files
        Show hidden files               true
Quick Settings Audio Devices Hider
    Hide All But
        Analog Output 7.1 HyperX
        Line Out - Starship/Mantisse HD
Todo.txt
    Click to create file
```

##### Steam Theme
```bash
cd
cd apps
git clone https://github.com/tkashkin/Adwaita-for-Steam
cd Adwaita-for-Steam
python install.py
```

##### Colors
```bash
python code/rice/offset_colors.py ~/.themes/Marble-blue-dark/gnome-shell/gnome-shell.css -0.3
nvim /home/calvo/.local/share/gnome-shell/extensions/custom-accent-colors@demiskp/resources/purple/gtk.css
```
    
#### 27. Duplicate Icons
```bash
cd /usr/share/applications/
sudo nvim codium-wayland.desktop
sudo nvim codium-uri-handler.desktop
sudo nvim ahk_x11-compiler.desktop
sudo nvim ahk_x11-windowspy.desktop
sudo nvim avahi-discover.desktop
sudo nvim bssh.desktop
sudo nvim bvnc.desktop
sudo nvim qv4l2.desktop
sudo nvim qvidcap.desktop
sudo nvim lstopo.desktop
Hidden=true

gsettings set org.gnome.shell app-picker-layout "[]"
```

```bash
find . -type f -name 'krita*' | grep -i 'krita*' | xargs -i cp {} /home/calvo/.local/share/applications/
cd /home/calvo/local/share/.applications/
find . -name 'krita*' | xargs -i echo "Hidden=true" >> {}
```

Just in case &nbsp;&nbsp;&nbsp;&nbsp;
```bash
find . -name 'krita*' -exec neovide {} + 
```

#### 28. Security
```bash
sudo ufw limit 22/tcp |
sudo ufw allow 80/tcp |
sudo ufw allow 443/tcp |
sudo ufw default deny incoming |
sudo ufw default allow outgoing |
sudo ufw enable
```

sudo nvim /etc/fail2ban/jail.local
```bash
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true

sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

#### 29. Anki
Addons:
- 1771074083
- 3918629684
- 613684242
- 947935257
- 1152543397

Add Ons &#8594; "config" &#8594; interval coefficient is set to 0.0

30&nbsp;&nbsp;&nbsp;&nbsp;9999&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;off&nbsp;&nbsp;&nbsp;&nbsp;1m 5m 15m&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;&nbsp;4&nbsp;&nbsp;&nbsp;&nbsp;Sequential
2m 7m&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;&nbsp;6&nbsp;&nbsp;&nbsp;&nbsp; Tag Only&nbsp;&nbsp;&nbsp;&nbsp;Deck&nbsp;&nbsp;&nbsp;&nbsp;Card type&nbsp;&nbsp;&nbsp;&nbsp; Show after reviews&nbsp;&nbsp;&nbsp;&nbsp;Show after reviews&nbsp;&nbsp;&nbsp;&nbsp; Due date, then random

600&nbsp;&nbsp;&nbsp;&nbsp;off&nbsp;&nbsp;&nbsp;&nbsp;off&nbsp;&nbsp;&nbsp;&nbsp;off&nbsp;&nbsp;&nbsp;&nbsp;off&nbsp;&nbsp;&nbsp;&nbsp;off&nbsp;&nbsp;&nbsp;&nbsp;off&nbsp;&nbsp;&nbsp;&nbsp;

180&nbsp;&nbsp;&nbsp;&nbsp;2.5&nbsp;&nbsp;&nbsp;&nbsp;1.3&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;&nbsp;1.2&nbsp;&nbsp;&nbsp;&nbsp;0

#### 30. Applications
```bash
sudo cp ~/code/linux/files/dotdesktops/* /usr/share/applications
sudo cp files/krita-workspace.kws /usr/share/krita/workspaces/
```

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
Firefox
    Download directory
    Remove
        Import bookmarks
        Getting Started
        Spaces
    Icons and Logins
    Theme
Krita
    Load workspace
    Themes -> Krita Darker
Nvidia
    OpenGL Settings
        Gsync Indicator
Pulse Audio
    Configuration
        Disable what's necessary
    Input Devices
        150%
VS Codium
    Monokai Pro - Ristretto
    Keyboard Shortcuts
        Copy Line Down - Shift Alt Down
GDM
    Wallpaper
    Apply

    Settings - User Profile
```

#### 31. Backup Kernel
```bash
sudo pacman -S linux-lts-headers
sudo pacman -S linux-lts nvidia-lts

sudo su
cd /boot/loader/entries
cp arch.conf arch-lts.conf

append -lts to linuz and to fs
reboot and hold 't'
```

#### 32. Useful
```bash
sudo -i
sudo su
```
