
-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
-- config.color_scheme = 'Monokai Dark (Gogh)'
-- config.color_scheme = 'Monokai Soda'
-- config.color_scheme = 'tokyonight_night'
-- config.color_scheme = 'Thayer Bright'
config.color_scheme = 'Tinacious Design (Dark)'
-- config.color_scheme = 'Google Dark (Gogh)'
--
config.font = wezterm.font 'JetBrains Mono'
config.max_fps = 240
config.animation_fps = 120
config.webgpu_power_preference = "HighPerformance"
config.show_update_window = true
config.default_prog = { 'fish' }

config.keys = {
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
}

-- and finally, return the configuration to wezterm
return config
