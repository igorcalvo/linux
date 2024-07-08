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

TODO 
Grub
Python packages filter
Ricing - new
Mega.nz download
Games - soh, totk, mm...

### Arch Install
#### 0. Getting image ready
```bash
https://archlinux.org/download/
sha256sum -b yourfile.iso

https://etcher.balena.io/
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

/en_US.UTF-8
x #
```

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
nvim /etc/hosts

127.0.0.1 localhost
127.0.0.1 arch-pc
```


```bash
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

#### 9. Boot
##### systemd-boot
```bash
ls /sys/firmware/efi/efivars
mount -t efivarfs efivarfs /sys/firmware/efi/efivars/
bootctl install
nvim /boot/loader/entries/arch.conf
```

```bash
title Arch
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
```

```bash
echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3) rw nvidia-drm.modeset=1" >> /boot/loader/entries/arch.conf
cat /boot/loader/entries/arch.conf
```

##### grub
TODO 

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
##### BSPWM
```bash
sudo pacman -S bspwm sxhkd picom nitrongen unclutter xorg xorg-xinit polybar ly --needed

mkdir .config/sxhkd
nvim .config/sxhkd/sxhkdrc

super + Return
    tilix

systemctl enable ly.service
reboot
```

```bash
super + enter
picom &
```

#### 15. Directories
```bash
mkdir code |
mkdir Desktop |
mkdir documents |
mkdir videos |
mkdir downloads |
mkdir misc |
mkdir books |
mkdir images |
mkdir lists |
mkdir apps
```

```bash
cd apps |
mkdir appimages |
cd ..|
cd images |
mkdir icons |
mkdir wallpapers |
mkdir screenshots
```

#### 16. Clone repos
```bash
ssh-keygen -t rsa
cd /home/calvo/.ssh
xclip -sel c id_rsa.pub

firefox
clone linux
clone scripts
```

#### 17. Stow & Tilix
```bash
stow --target="/home/calvo" --dir="/home/calvo/code/linux/dotfiles" -v --simulate . 
stow --target="/home/calvo" --dir="/home/calvo/code/linux/dotfiles" -v --adopt . 

cd ~/code/linux/dotfiles/.config/
mkdir x 
mv ~/.config/x/* ~/code/linux/dotfiles/x
stow --dir="/home/calvo/.config/x" --target="/home/calvo/code/linux/dotfiles/.config/x" -v --simulate .
```

```bash
cd ~/code/linux
# dconf dump /com/gexperts/Terminix/ > terminix.dconf 
dconf load /com/gexperts/Tilix/ < tilix.dconf
```

#### 18. Yay
```bash
sudo pacman -Syu

cd apps
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

#### 19. Installing
```bash
sudo pacman -S --needed noto-fonts-cjk noto-fonts-emoji noto-fonts gnu-free-fonts noto-fonts \
ttf-jetbrains-mono ttf-liberation noto-fonts-emoji vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools \
ttf-nerd-fonts-symbols-mono fuse2 fuse3 libxkbcommon-x11 unrar p7zip vulkan-intel lib32-vulkan-intel \
clutter clutter-gtk inkscape ripgrep rofi playerctl numlockx lm_sensors xdg-user-dirs-gtk gnome-backgrounds
```

```bash
sudo pacman -S --needed fastfetch qbittorrent screen xdotool python-pip krita flameshot vlc nodejs npm\
calibre ffmpeg dconf-editor drawing trash-cli xarchiver-gtk2 fish jq fzf tldr bat eza zoxide\
stress glmark2 discord neovide fail2ban ufw steam imagemagick pavucontrol feh yazi pandoc python-weasyprint\
task taskwarrior-tui clipcat calcurse xcolor gnome-system-monitor nautilus gnome-terminal
```

```bash
yay -S polychromatic wezterm qdirstat youtube-music vscodium ahk_x11 anki ttf-juliamono ttf-weather-icons ttf-kanjistrokeorders
```

```bash
dconf write /system/locale/region "'en_GB.UTF-8'"
```

```
?
tetrio
```

#### 20. Websites
##### AppImages
```bash
https://www.onlyoffice.com/download-desktop.aspx
https://github.com/Nixola/VRRTest/releases/
https://etcher.balena.io/
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

#### 21. System Config
```bash
rm Pictures Music Videos Documents Downloads Templates Public |

cp ~/code/linux/files/icons/* ~/images/icons/
sudo nvim /etc/xdg/user-dirs.defaults
nvim ~/.config/user-dirs.dirs
```

```bash
git config --global user.email "igorcalvob@gmail.com" |
git config --global user.name "igorcalvo" |
xdg-settings set default-web-browser firefox.desktop |
sudo modprobe razerkbd
```

```bash
sudo gpasswd -a $USER plugdev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo sensors-detect
```

#### 22. Startup
```bash
sudoedit /usr/share/xsessions/bspwm.desktop
Exec=sh ~/code/scripts/wm-start.sh
# .xinitrc
```

#### 23. Python
```bash
fuck pysimplegui

sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED
pip install PySimpleGUI==4.60.5 mouse Pillow tk selenium pipreqs
sudo pacman -S python-pandas python-numpy python-scipy python-matplotlib python-beautifulsoup4 python-openpyxl python-requests python-pyperclip python-opencv python-debugpy python-pywal python-virtualenv jupyter-notebook yt_dlp --needed
```

#### 24. Files
```bash
cp ~/code/linux/files/krita-workspace.kws ~/.local/share/krita/workspaces/

TODO MEGA and more
```

#### 25. Ricing
##### Display Manager
```bash
sudo nvim /etc/ly/config.ini
fg = 7
```

##### Wallpaper
1. Get it
2. Krita

```bash
nitrogen ~/images/wallpapers/20xx-0x/pc/xxx.png --set-auto
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
sudo make build
sudo make install
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
Script to separate primary and secondary colors
Run rice.py to change hue on new script
```bash
```
    
#### 26. Security
```bash
sudo ufw limit 22/tcp |
sudo ufw allow 80/tcp |
sudo ufw allow 443/tcp |
sudo ufw default deny incoming |
sudo ufw enable
```

sudoedit /etc/fail2ban/jail.local
```bash
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

#### 27. Anki
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

#### 28. Applications
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
    Monokai, but not pro
    Keyboard Shortcuts
        Copy Line Down - Shift Alt Down
```

#### 29. Backup Kernel
```bash
sudo pacman -S linux-lts-headers
sudo pacman -S linux-lts nvidia-lts

sudo su
cd /boot/loader/entries
cp arch.conf arch-lts.conf

append -lts to linuz and to fs
reboot and hold 't'
```

#### 30. Useful
```bash
sudo -i
sudo su
xev # events, to find key names
fc-list | grep Mono # list font names
```
