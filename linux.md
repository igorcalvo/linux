```
       _,met$$$$$gg.       
    ,g$$$$$$$$$$$$$$$P.    
  ,g$$P"     """Y$$.".     
 ,$$P'              `$$$.  
',$$P       ,ggs.     `$$b:
`d$$'     ,$P"'   .    $$$ 
 $$P      d$'     ,    $$P 
 $$:      $$.   -    ,d$$' 
 $$;      Y$b._   _,d$P'   
 Y$$.    `.`"Y$$$$P"'      
 `$$b      "-.__           
  `Y$$                     
   `Y$$.                   
     `$$b.                 
       `Y$$b.              
          `"Y$b._          
              `"""         
```
#### 1. Getting sudo & desktop
```bash
su -
chmod 0440 /etc/sudoers
nano /etc/sudoers

# User privilege specification
root	ALL=(ALL:ALL) ALL
calvo	ALL=(ALL) ALL

apt install gnome-core
systemctl start gdm3
sudo reboot
```

#### 2. Adding Sources
```bash
sudo apt install nala curl

# Polychromatic
echo "deb [signed-by=/usr/share/keyrings/polychromatic.gpg] http://ppa.launchpad.net/polychromatic/stable/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/polychromatic.list
curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xc0d54c34d00160459588000e96b9cd7c22e2c8c5' | sudo gpg --dearmour -o /usr/share/keyrings/polychromatic.gpg

# Razer
echo 'deb http://download.opensuse.org/repositories/hardware:/razer/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/hardware:razer.list
curl -fsSL https://download.opensuse.org/repositories/hardware:razer/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/hardware_razer.gpg > /dev/null

# Floorp
curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'

# Nvidia proprietary drivers
sudo nano /etc/apt/sources.list

contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb http://deb.debian.org/debian bookworm-backports main contrib non-free
```

#### 3. Updating
```bash
sudo dpkg --add-architecture i386
sudo nala update
sudo nala upgrade
sudo apt-get dist-upgrade
```

#### 4. Installing
```bash
sudo nala install polychromatic openrazer-meta floorp nvidia-driver firmware-misc-nonfree
sudo nala install steam-installer mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
sudo nala install qbittorrent git screen xdotool python3-pip krita flameshot xclip vlc nodejs npm calibre ffmpeg libxcb-xinerama0 libxcb-cursor0 gir1.2-gtop-2.0 lm-sensors gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager gnome-shell-extension-desktop-icons-ng gnome-characters gnome-screensaver drawing aptitude qdirstat trash-cli grub-customizer unrar unzip gzip fish stow virt-manager

sudo nala install tetrio-desktop

sudo reboot
```

#### 5. Websites
```bash
https://discord.com/download
https://github.com/VSCodium/vscodium/releases
https://www.onlyoffice.com/download-desktop.aspx
https://github.com/th-ch/youtube-music/releases
https://github.com/phil294/AHK_X11/releases
https://github.com/Nixola/VRRTest/releases/
https://wezfurlong.org/wezterm/install/linux.html

cd /home/calvo/Desktop
find . -type f -name '*.deb' | grep -i '*.deb' | xargs -i sudo dpkg -i {}
```

#### 6. Neovim
```bash
https://github.com/neovim/neovim/
https://github.com/nvim-lua/kickstart.nvim - not needed

sudo nala install ninja-build gettext cmake unzip curl

cd /home/calvo/Apps/Neovim/
git clone https://github.com/neovim/neovim
cd neovim && git fetch && git checkout release-0.9
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb

https://neovide.dev/
```

#### 7. Config
- Grub Customizer &#8594; General Settings &#8594; 1s

```bash
git config --global user.email "igorcalvob@gmail.com"
dconf write /org/gnome/desktop/background/picture-options "'spanned'"
dconf write /org/gnome/desktop/wm/preferences/focus-new-windows "'smart'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/volume-step 2
dconf write /org/gnome/desktop/interface/clock-show-seconds true
dconf write /org/gnome/desktop/interface/clock-show-weekday true
dconf write /org/gnome/desktop/interface/clock-show-date true
dconf write /org/gnome/desktop/calendar/show-weekdate true

sudo update-grub
sudo update-alternatives --config x-terminal-emulator
sudo modprobe razerkbd
sudo sensors-detect
dconf load /com/gexperts/Tilix/ < tilix.dconf
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
