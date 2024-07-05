-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This will hold actions
local act = wezterm.action

-- config.color_scheme = 'Monokai Dark (Gogh)'
-- config.color_scheme = 'Monokai Soda'
-- config.color_scheme = 'tokyonight_night'
-- config.color_scheme = 'Thayer Bright'
config.color_scheme = 'Tinacious Design (Dark)'
-- config.color_scheme = 'Google Dark (Gogh)'
config.window_background_opacity = 1.0
config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'JuliaMono',
  'Noto Sans Mono'
}
config.max_fps = 240
config.animation_fps = 120
config.prefer_egl = true
-- ctrl + shift + l
-- wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = {
  backend = "Vulkan",
  device = 7812,
  device_type = "DiscreteGpu",
  driver = "NVIDIA",
  driver_info = "555.58.02",
  name = "NVIDIA GeForce RTX 2070 SUPER",
  vendor = 4318,
}
config.front_end = "WebGpu"
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
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 'i',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateCopyMode
  }
}

-- and finally, return the configuration to wezterm
return config
