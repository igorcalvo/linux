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
pacman -S nvim sudo intel-ucode iucode-tool linux-headers dhcpcd networkmanager git base-devel
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
```

#### 15. Gnome Settings 

Displays
    Nightlight
        Manual
        20 to 08
        50%
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
Multitasking
    Fixed Number of Workspaces
        1
    Appearance
        Default
Mouse & Touchpad
    Touchpad
        Secondary Click
            Corner Push
Keyboard
    Input Sources
        English (US)
        English (US, intl., with dead keys)
System
    Region & Language
        Language    - English (US)
        Formats     - United Kingdom
    Date & Time
        Automatic Date & Time
            On
        Time Zone
            Sao Paulo, Brazil
        Time Format
            24 H
        Clock & Calendar
            All On
```bash
dconf write /org/gnome/desktop/background/picture-options "'spanned'" |
dconf write /org/gnome/desktop/wm/preferences/focus-new-windows "'smart'" |
dconf write /org/gnome/settings-daemon/plugins/media-keys/volume-step 2 |
dconf write /org/gnome/desktop/interface/clock-show-seconds true |
dconf write /org/gnome/desktop/interface/clock-show-weekday true |
dconf write /org/gnome/desktop/interface/clock-show-date true |
dconf write /org/gnome/desktop/calendar/show-weekdate true
```

#### 16. Misc Settings
```bash
sudo systemctl enable --now bluetooth
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

sudo nvim /usr/share/applications/avahi-discover.desktop
bssh
bvnc
Hidden=True

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
sudo pacman -S --needed noto-fonts-cjk noto-fonts-emoji noto-fonts gnu-free-fonts noto-fonts ttf-jetbrains-mono noto-fonts-emoji vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools ttf-nerd-fonts-symbols-mono fuse2 fuse3 libxkbcommon-x11 
sudo pacman -S -needed neofetch firefox xclip qbittorrent screen tilix xdotool python-pip krita flameshot vlc nodejs npm calibre ffmpeg gnome-tweaks dconf-editor drawing trash-cli xarchiver-gtk2 fish stow jq fzf tldr bat stress glmark2 eza zoxide discord neovide 
yay -S polychromatic wezterm extension-manager qdirstat youtube-music-bin vscodium-bin

?
lm-sensors
pandoc
tetrio
```

#### 19. Config
```bash
git config --global user.email "igorcalvob@gmail.com"
git config --global user.name "igorcalvo"
sudo update-alternatives --config x-terminal-emulator
sudo modprobe razerkbd
sudo sensors-detect

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

math cli
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

#### 5. Websites
```bash
AppImages
https://www.onlyoffice.com/download-desktop.aspx
https://github.com/phil294/AHK_X11/releases
https://github.com/Nixola/VRRTest/releases/

Must Compile
https://github.com/aristocratos/btop?tab=readme-ov-file#compilation-linux
```


#### 8. Python
```bash
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
sudo nala install python3.11-venv 
pip install pandas scipy pysimplegui mouse matplotlib Pillow tk selenium yt_dlp jupyter PyInstaller beautifulsoup4 openpyxl requests pyperclip opencv-python debugpy
```

#### 9. Duplicate Icons
```bash
cd /usr/share/applications/
find . -type f -name 'krita*' | grep -i 'krita*' | xargs -i cp {} /home/calvo/.local/share/applications/
find . -type f -name 'gnome-software-local-file*' | grep -i 'gnome-software-local-file*' | xargs -i cp {} /home/calvo/.local/share/applications/

cd /home/calvo/local/share/.applications/
find . -name 'krita*' | xargs echo "Hidden=true" >> {}
find . -name 'gnome-software-local-file*' | xargs echo "Hidden=true" >> {}
```

Just in case &nbsp;&nbsp;&nbsp;&nbsp;
`find . -name 'krita*' -exec gnome-text-editor {} +` 

#### 10. Clone repos
```bash
ssh-keygen -t rsa
cd /home/calvo/.ssh
xclip -sel c id_rsa.pub
```

#### 11. Stow
```bash
stow --target="/home/calvo" --dir="/home/calvo/Code/Linux/dotfiles" -v -simulate . 
stow --target="/home/calvo" --dir="/home/calvo/Code/Linux/dotfiles" -v --adopt . 
```

#### 12. Startup
- Gnome Tweaks
- Create app to run at startup

```bash
~/.local/share/applications/
startup.desktop 

[Desktop Entry]
Name=Startup
Comment=Startup
Keywords=folder;manager;explore;disk;filesystem;
Exec=sh /home/calvo/Code/Scripts/startup.sh
# Exec=nautilus /home/calvo/Book 
Icon=/home/calvo/Pictures/Icons/shuttle.png
Terminal=false
Type=Application
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
Images

#### 15. Anki
`nala install libxcb-xinerama0 libxcb-cursor0`
https://apps.ankiweb.net/

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

#### 16. Security

```bash
sudo nala install ufw fail2ban

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

```bash
/etc/fail2ban/jail.local


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

#### 17. Arch BTW
```bash
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts
sudo systemctl enable --now bluetooth

sudo pacman -S gnu-free-fonts noto-fonts ttf-jetbrains-mono noto-fonts-emoji
pacman -Sy archinstall archlinux-keyring

https://github.com/Jguer/yay
sudo pacman -S git base-devel neovim kitty
git clone https://aur.archlinux.org/yay.git
makepkg -si
yay --version

hyprland wiki
quickstart
nvidia
wrapper
libs install

su -
chmod 0440 /etc/sudoers
nano /etc/sudoers

apt install gnome-core
systemctl start gdm3
sudo reboot
```
