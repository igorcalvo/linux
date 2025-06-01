# Gnome
```bash
sudo pacman -S xorg gnome --needed

enter
? = backgrounds
?? = terminal
4,6,8,14,15,16,18,20,23,25,26,28,48,58, ?, ??

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

## Apps
```bash
sudo pacman -S --needed dconf-editor gnome-tweaks
yay extension-manager gdm-settings
```

## Gnome Settings 
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

## Dconf
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

## Ricing
### Icons
Kora
Green or Yellow <br>
https://www.gnome-look.org/s/Gnome/p/1256209 <br>
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

### Theme
Marble Shell theme <br>
https://www.gnome-look.org/p/1977647

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

### Desktops
```bash
sudo cp ~/code/linux/files/dotdesktops/* /usr/share/applications
```

### Extensions
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

### Colors
```bash
python code/rice/offset_colors.py ~/.themes/Marble-blue-dark/gnome-shell/gnome-shell.css -0.3
nvim /home/calvo/.local/share/gnome-shell/extensions/custom-accent-colors@demiskp/resources/purple/gtk.css
```

