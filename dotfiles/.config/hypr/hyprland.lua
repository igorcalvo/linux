-- Hyprland configuration (Lua / config v2)
-- ================================================================
-- Migrated from hyprland.conf (hyprlang v1) on 2026-08-22.
--
-- Since Hyprland 0.55, hyprlang is deprecated in favor of Lua.
-- When both hyprland.lua and hyprland.conf exist, hyprland.lua wins.
-- The old hyprlang config is kept as hyprland.conf (backup in
-- ~/.config/hypr/backup-2026-08-22/).
--
-- Docs: https://wiki.hypr.land/Configuring/Start/
-- ================================================================

------------------
---- MONITORS ----
------------------
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@240",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@240",
    position = "1920x0",
    scale    = 1,
})

-- hl.monitor({ output = "DP-1", mode = "1920x1080@144", position = "1920x0", scale = 1 })
-- hl.monitor({ output = "DP-1", mode = "preferred", position = "1920x0", scale = 1 })

---------------------
---- WORKSPACES ----
---------------------
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1", persistent = true })

hl.workspace_rule({ workspace = "2", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "DP-1", persistent = true })

------------------
---- AUTOSTART ----
------------------
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- hyprland.start fires once per session (equivalent of exec-once)

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("polychromatic-tray-applet")

    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("screen -d -m python ~/code/scripts/hourly.py")
    hl.exec_cmd("hyprctl hyprsunset identity")

    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")

    hl.exec_cmd("screen -d -m sh ~/code/scripts/startup.sh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GL_GSYNC_ALLOWED", "1")
hl.env("__GL_VRR_ALLOWED", "1")

hl.env("XDG_CONFIG_HOME", "/home/calvo/.config/")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.env("HYPRCURSOR_THEME", "VolantesLightHypr")
hl.env("HYPRCURSOR_SIZE", "24")

----------------------
---- PERMISSIONS ----
----------------------
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Permission changes require a Hyprland restart (not applied on-the-fly).

-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

----------------------
---- LOOK AND FEEL ----
----------------------
-- https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 4,

        border_size = 2,

        col = {
            -- col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
            -- col.inactive_border = rgba(595959aa)
            active_border   = { colors = { "rgba(00e6ccff)", "rgba(00ff66ff)" }, angle = 45 },
            inactive_border = "rgba(226655aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing = true,

        layout = "dwindle",
        -- layout = "master"
    },
})

-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
        force_split    = 2,    -- 0: follows mouse, 1: always left/top, 2: always right/bottom
    },
})

-- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
    master = {
        new_status  = "slave",
        orientation = "right",
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
hl.config({
    misc = {
        force_default_wallpaper = 2, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false,
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
    decoration = {
        rounding       = 8,
        rounding_power = 4,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1a00)",
        },

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,

            vibrancy = 0.1696,
        },
    },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only" (uncomment all to enable)
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
-- hl.window_rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]" },   border_size = 0, rounding = 0 })

-------------
---- INPUT ----
-------------
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        kb_layout  = "us,us",
        kb_variant = ",intl",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        numlock_by_default = true,
        follow_mouse       = 0,

        sensitivity   = -0.25, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Example per-device config
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

----------------------
---- KEYBINDINGS ----
----------------------
-- https://wiki.hypr.land/Configuring/Basics/Binds/

-- Launcher / terminals
hl.bind("SUPER + Return",  hl.dsp.exec_cmd("wezterm start --always-new-process"))
hl.bind("SUPER + KP_Enter", hl.dsp.exec_cmd("wezterm start --always-new-process"))
hl.bind("SUPER + Q",       hl.dsp.exec_cmd("kitty"))

-- Power
hl.bind("CTRL + Scroll_Lock", hl.dsp.exec_cmd("reboot"))
hl.bind("CTRL + Pause",       hl.dsp.exec_cmd("systemctl poweroff"))

-- Desktop
hl.bind("CTRL + P",      hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("CTRL + grave",  hl.dsp.exec_cmd("~/code/scripts/3rd-party/cliphist-fuzzel-img.sh"))
hl.bind("SUPER + space",    hl.dsp.exec_cmd("fuzzel"))
hl.bind("CTRL + period", hl.dsp.exec_cmd("sh ~/code/scripts/emoji.sh"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("CTRL + Print",  hl.dsp.exec_cmd('grim ~/images/screenshots/$(date +"%Y-%m-%dT%H%M%S").png'))

-- Launch
-- hl.bind("SUPER + 1", hl.dsp.exec_cmd("hyprctl dispatch workspace 1; librewolf --new-tab --url about:newtab"))
-- bookmark momentums new tab
hl.bind("SUPER + 1", hl.dsp.exec_cmd("hyprctl dispatch workspace 1; librewolf --new-tab --url moz-extension://75a0cd2e-e8e3-4f74-8a2e-186cec1622ac/index.html"))
-- hl.bind("SUPER + 2", hl.dsp.exec_cmd("librewolf"))
hl.bind("SUPER + 3", hl.dsp.exec_cmd("youtube-music"))
hl.bind("SUPER + 4", hl.dsp.exec_cmd("krita"))
-- hl.bind("SUPER + 5", hl.dsp.exec_cmd("librewolf"))
-- hl.bind("SUPER + 6", hl.dsp.exec_cmd("librewolf"))
-- hl.bind("SUPER + 7", hl.dsp.exec_cmd("librewolf"))
-- hl.bind("SUPER + 7", hl.dsp.exec_cmd("fish ~/apps/odysseus/run.sh"))
hl.bind("SUPER + 8", hl.dsp.exec_cmd("kitty btop"))
hl.bind("SUPER + 9", hl.dsp.exec_cmd("qbittorrent"))
hl.bind("SUPER + 0", hl.dsp.exec_cmd("nautilus ~/downloads/"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))

-- Control layout
hl.bind("CTRL + ALT + W",  hl.dsp.window.close()) -- was killactive (Control Alt_L, W) in v1
hl.bind("SUPER + R",            hl.dsp.layout("togglesplit"))
hl.bind("SUPER + D",            hl.dsp.window.float({ action = "toggle" }))
hl.bind("ALT + mouse:272",      hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + B",            hl.dsp.exit())
hl.bind("SUPER + F",            hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + Tab",          hl.dsp.focus({ workspace = "previous" }))

-- Move focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces
hl.bind("SUPER + KP_End",   hl.dsp.focus({ workspace = "1" }))
hl.bind("SUPER + KP_Left",  hl.dsp.focus({ workspace = "4" }))
hl.bind("SUPER + KP_Home",  hl.dsp.focus({ workspace = "7" }))

hl.bind("SUPER + KP_Down",  hl.dsp.focus({ workspace = "2" }))
hl.bind("SUPER + KP_Begin", hl.dsp.focus({ workspace = "5" }))
hl.bind("SUPER + KP_Up",    hl.dsp.focus({ workspace = "8" }))

-- hl.bind("SUPER + KP_Next",  hl.dsp.focus({ workspace = "3" }))
-- hl.bind("SUPER + KP_Right", hl.dsp.focus({ workspace = "6" }))
-- hl.bind("SUPER + KP_Prior", hl.dsp.focus({ workspace = "9" }))

-- Move active window
hl.bind("SUPER + SHIFT + KP_End",   hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + SHIFT + KP_Left",  hl.dsp.window.move({ workspace = "4" }))
hl.bind("SUPER + SHIFT + KP_Home",  hl.dsp.window.move({ workspace = "7" }))

hl.bind("SUPER + SHIFT + KP_Down",  hl.dsp.window.move({ workspace = "2" }))
hl.bind("SUPER + SHIFT + KP_Begin", hl.dsp.window.move({ workspace = "5" }))
hl.bind("SUPER + SHIFT + KP_Up",    hl.dsp.window.move({ workspace = "8" }))

-- hl.bind("SUPER + SHIFT + KP_Next",  hl.dsp.window.move({ workspace = "3" }))
-- hl.bind("SUPER + SHIFT + KP_Right", hl.dsp.window.move({ workspace = "6" }))
-- hl.bind("SUPER + SHIFT + KP_Prior", hl.dsp.window.move({ workspace = "9" }))

-- Example special workspace (scratchpad)
hl.bind("SUPER + grave",         hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magic" }))

-- Resizing
-- Enter resize mode
hl.bind("SUPER + S", hl.dsp.submap("resize"))

-- Define the resize submap
hl.define_submap("resize", function()
    hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }),  { repeating = true })
    hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }),  { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Audio keys
-- bindel -> { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+; sh ~/code/scripts/volume-notification.sh"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; sh ~/code/scripts/volume-notification.sh"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),                                            { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                                          { locked = true, repeating = true })

-- bindl -> { locked = true }
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

---------------------------------
---- WINDOWS AND WORKSPACES ----
---------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "cs2-tearing",
    match = { class = "^(cs2)$" },
    immediate = true,
})
