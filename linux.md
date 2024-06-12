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
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
```

#### 5. Update Image & Root
```bash
pacstrap -K /mnt base linux linux-firmware
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt
pacman -S nvim sudo intel-ucode iucode-tool linux-headers dhcpcd networkmanager git base-devel xclip
```

#### 6. Language, Location & Time
```bash
nvim /etc/locale.gen
```
/en_US
/en_CA
/en_GB
/pt_BR.UTF-8
x

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
EDITOR=neovim visudo
```
/%wheel
G
Defaults rootpw

# User privilege specification
root	ALL=(ALL:ALL) ALL
calvo	ALL=(ALL) ALL

#### 8. Pacman mirrors
```bash
vim /etc/pacman.conf
```

color
parallel 15
/multilib

```bash
pacman -Sy
pacman -Syu
```

#### 9. Boot
```bash
ls /sys/firmware/efi/efivars
mount -t efivarfs efivarfs /sys/firmware/efi/efivars/
bootctl install
nvim /boot/loader/entries/arch.conf
```

title Arch
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img

```bash
echo ¨options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3) rw nvidia-drm.modeset=1¨ >> /boot/loader/entries/arch.conf
cat /boot/loader/entries/arch.conf
```

#### 10. Nvidia & Image
```bash
pacman -S nvidia-dkms libglvnd nvidia-utils opencl-nvidia lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings
nvim /etc/mkinitcpio.conf
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
HOOKS(= -kms)

```bash
mkdir /etc/pacman.d/hooks
nvim /etc/pacman.d/hooks/nvidia.hook
```

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

```bash
mkinitcpio -P
```

#### 11. Services
```bash
sudo systemctl enable fstrim.timer
sudo systemctl enable NetworkManager.service
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
sudo pacman -S xorg gnome
(select numbers) - gdm, gnome-shell, etc
sudo systemctl start gdm

sudo systemctl enable gdm
systemctl reboot
```

#### 15. Gnome Settings 
Sound
    Fixed after firefox install
Power
    Dim Screen
    Screen Blank
        5 Minutes
    Automatic Suspend
        When on Battery
    Power Button
        Suspend
    Show Batter Percentage
        On
Mouse & Touchpad
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
dconf write /org/gnome/desktop/input-sources/mru-sources [('xkb', 'us')] |
dconf write /org/gnome/desktop/input-sources/sources [('xkb', 'us'), ('xkb', 'us+intl')]" |
dconf write /system/locale/region "'en_GB.UTF-8'"
```

#### 16. Misc Settings
```bash
sudo systemctl enable --now bluetooth
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

xdg-settings set default-web-browser firefox.desktop
```
sudo nvim /usr/share/applications/mimeinfo.cache
inode/directory=org.gnome.Nautilus.desktop;
text/plain=neovide.desktop;nvim.desktop;org.gnome.gedit.desktop;

sudo nvim /usr/share/applications/avahi-discover.desktop
bssh
bvnc
Hidden=true

nvim ~/.local/share/applications/ahk_x11-compiler.desktop
ahk_x11-windowspy.desktop
Hidden=true

#### 10. Clone repos
```bash
ssh-keygen -t rsa
cd /home/calvo/.ssh
xclip -sel c id_rsa.pub
```

#### 11. Stow
```bash
stow --target="/home/calvo" --dir="/home/calvo/code/Linux/dotfiles" -v --simulate . 
stow --target="/home/calvo" --dir="/home/calvo/code/Linux/dotfiles" -v --adopt . 
```

#### 12. Startup
- Gnome Tweaks
- Create app to run at startup

```bash
# ~/.local/share/applications/
/usr/share/applications/
startup.desktop 

[Desktop Entry]
Name=Startup
Comment=Startup
Keywords=folder;manager;explore;disk;filesystem;
Exec=sh /home/calvo/code/Scripts/startup.sh
# Exec=nautilus /home/calvo/book 
Icon=/home/calvo/images/icons/shuttle.png
Terminal=false
Type=Application
```

#### 17. Yay
```bash
sudo pacman -Syu
sudo pacman -S --needed base-devel git
cd 
mkdir apps
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

#### 18. Installing
```bash
sudo pacman -S --needed noto-fonts-cjk noto-fonts-emoji noto-fonts gnu-free-fonts noto-fonts ttf-jetbrains-mono noto-fonts-emoji vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools ttf-nerd-fonts-symbols-mono fuse2 fuse3 libxkbcommon-x11 unrar p7zip vulkan-intel lib32-vulkan-intel clutter clutter-gtk
sudo pacman -S --needed neofetch firefox xclip qbittorrent screen tilix xdotool python-pip krita flameshot vlc nodejs npm calibre ffmpeg gnome-tweaks dconf-editor drawing trash-cli xarchiver-gtk2 fish stow jq fzf tldr bat stress glmark2 eza zoxide discord neovide fail2ban ufw
yay -S polychromatic wezterm extension-manager qdirstat youtube-music-bin vscodium-bin ahk_x11-bin anki

?
lm-sensors
pandoc
tetrio
```

#### 5. Websites
AppImages
```bash
https://www.onlyoffice.com/download-desktop.aspx
https://github.com/phil294/AHK_X11/releases
https://github.com/Nixola/VRRTest/releases/
```
create onlyoffice desktop entry 

Must Compile
[Btop](https://github.com/aristocratos/btop?tab=readme-ov-file#compilation-linux) 
```bash
cd ~/apps
git clone https://github.com/aristocratos/btop.git
cd btop
make GPU_SUPPORT=true VERBOSE=true
sudo make install
```

#### 19. Config
```bash
git config --global user.email "igorcalvob@gmail.com"
git config --global user.name "igorcalvo"
sudo modprobe razerkbd
# sudo sensors-detect

<!-- dconf dump /com/gexperts/Terminix/ > terminix.dconf -->
dconf load /com/gexperts/Tilix/ < tilix.dconf
```

#### 14. Ricing
```bash
```

#### 14. Ricing
```bash
fullscreen 
flameshot full -p ~/screenshots

or select a part of screen 
flameshot gui -p ~/screenshots 

gnome-themes-standard
```

create directories
```bash
cd 
mkdir apps
cd apps
mkdir appimages
cd ..
mkdir code 
mkdir Desktop
mkdir downloads
mkdir images
cd images
mkdir screenshots
```

#### 14. Ricing
```bash
cd
cd apps
git clone https://github.com/tkashkin/Adwaita-for-Steam
cd Adwaita-for-Steam
./install.py
```

#### 14. Ricing
```bash
```

#### 14. Ricing
```bash
```

#### 8. Python
```bash
sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED
pip install pandas scipy pysimplegui mouse matplotlib Pillow tk selenium yt_dlp jupyter PyInstaller beautifulsoup4 openpyxl requests pyperclip opencv-python debugpy
sudo pacman -S python-virtualenv
bash
PATH=$PATH:/home/calvo/.local/bin
XDG_DOWNLOAD_DIR=$HOME/downloads
```

#### 13. Keyboard Shortcuts
| Command   | Keys    |
|--------------- | --------------- |
| hide all windows   | sup + d   |
<!-- |    |    | -->

#### 14. Ricing
##### Cursors
`/usr/share/icons`  
https://www.gnome-look.org/p/1356095

##### Icons
`find ./ -name "kora*" | xargs -i sudo mv -i {} /usr/share/icons`  
https://www.gnome-look.org/p/135609

##### Theme
`mv -r /Marble-shell /usr/share/themes` \
https://www.gnome-look.org/p/1977647 <br><br>
Backups \
https://www.gnome-look.org/p/1013030 \
https://www.pling.com/p/1299514 \
https://www.gnome-look.org/p/1273210

##### Extensions
![extensions 1](./extensions-1.png)
![extensions 2](./extensions-2.png)

```bash
dconf write /org/gnome/shell/extensions/trayIconsReloaded/icon-padding-horizontal 4 |
dconf write /org/gnome/shell/extensions/vitals/hot-sensors ['_processor_usage_', '_memory_usage_', '_storage_free_', '_temperature_cpu_0 core 1_'] |
dconf write /org/gnome/shell/extensions/vitals/show-gpu true |
dconf write /org/gnome/shell/extensions/vitals/update-time 1 |
dconf write /org/gnome/shell/extensions/vitals/use-higher-precision true |
dconf write /org/gnome/shell/extensions/lockkeys/style 'show-hide-capslock' |
dconf write /org/gnome/shell/extensions/TodoTxt/click-action 1 |
dconf write /org/gnome/shell/extensions/TodoTxt/show-done false |
dconf write /org/gnome/shell/extensions/TodoTxt/show-edit-button true |
dconf write /org/gnome/shell/extensions/TodoTxt/done-format-string "'{undone}'" |
dconf write /org/gnome/shell/extensions/TodoTxt/hide-pattern "'{undone}'" |
dconf write /org/gnome/shell/extensions/openweatherrefined/days-forecast 5 |
dconf write /org/gnome/shell/extensions/openweatherrefined/decimal-places 1 |
dconf write /org/gnome/shell/extensions/openweatherrefined/delay-ext-init 3 |
dconf write /org/gnome/shell/extensions/openweatherrefined/expand-forecast true |
dconf write /org/gnome/shell/extensions/openweatherrefined/geolocation-provider "'openstreetmaps'" |
dconf write /org/gnome/shell/extensions/openweatherrefined/locs [(0, 'Vila Mariana', 0, '-23.5925361,-46.6357123')] |
dconf write /org/gnome/shell/extensions/openweatherrefined/menu-alognment 37.5 |
dconf write /org/gnome/shell/extensions/openweatherrefined/position-index 2 |
dconf write /org/gnome/shell/extensions/openweatherrefined/position-in-panel 'left' |
dconf write /org/gnome/shell/extensions/openweatherrefined/pressure-unit 'mmHg' |
dconf write /org/gnome/shell/extensions/openweatherrefined/refresh-interval-current 1800 |
dconf write /org/gnome/shell/extensions/openweatherrefined/refresh-interval-forecast 10800 |
dconf write /org/gnome/shell/extensions/openweatherrefined/show-comment-in-panel true |
dconf write /org/gnome/shell/extensions/openweatherrefined/weather-provider 'openweathermap' |
dconf write /org/gnome/shell/extensions/openweatherrefined/wind-direcation true |
dconf write /org/gnome/shell/extensions/clipboard-indicator/cache-size 50 |
dconf write /org/gnome/shell/extensions/clipboard-indicator/clear-history ['<Control>apostrophe'] |
dconf write /org/gnome/shell/extensions/clipboard-indicator/history-size 100 |
dconf write /org/gnome/shell/extensions/clipboard-indicator/move-item-first true |
dconf write /org/gnome/shell/extensions/clipboard-indicator/paste-button false |
dconf write /org/gnome/shell/extensions/clipboard-indicator/preview-size 60 |
dconf write /org/gnome/shell/extensions/clipboard-indicator/toggle-menu ['<Control>grave'] |
dconf write /org/gnome/shell/extensions/color-picker/color-picker-shortcut ['<Control><Alt>p'] |
dconf write /org/gnome/shell/extensions/color-picker/enable-shortcut true |
dconf write /org/gnome/shell/extensions/color-picker/format-menu true |
dconf write /org/gnome/shell/extensions/color-picker/menu-key 'm' |
dconf write /org/gnome/shell/extensions/color-picker/quit-key 'q' |
dconf write /org/gnome/shell/extensions/color-picker/persistent-mode true |
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 64 |
dconf write /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button false |
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash false |
dconf write /org/gnome/shell/extensions/dash-to-dock/apply-custom-theme true |
dconf write /org/gnome/shell/extensions/just-perfection/activities-button false |
dconf write /org/gnome/shell/extensions/gtk4-ding/icon-size 'large' |
dconf write /org/gnome/shell/extensions/gtk-ding/show-home false |
dconf write /org/gnome/shell/extensions/gtk-ding/show-network-volumes false |
dconf write /org/gnome/shell/extensions/gtk-ding/show-trash false |
dconf write /org/gnome/shell/extensions/gtk-ding/show-volumes true |
dconf write /org/gnome/shell/keybindings/screenshot-window [] |
dconf write /org/gnome/shell/keybindings/screenshot [] |
dconf write /org/gnome/shell/keybindings/show-screenshot-ui []

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
```
    
#### 9. Duplicate Icons
```bash
cd /usr/share/applications/
find . -type f -name 'krita*' | grep -i 'krita*' | xargs -i cp {} /home/calvo/.local/share/applications/
sudo rm codium-wayland.desktop
sudo rm codium-uri-handler.desktop

cd /home/calvo/local/share/.applications/
find . -name 'krita*' | xargs -i echo "Hidden=true" >> {}
```

Just in case &nbsp;&nbsp;&nbsp;&nbsp;
```bash
find . -name 'krita*' -exec gedit {} + 
```

#### 16. Security
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

#### 15. Anki
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

