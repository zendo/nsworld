local wezterm = require 'wezterm';

return {
   default_prog = { 'zsh' },

   initial_cols = 85,
   initial_rows = 28,
   window_background_opacity = 0.95,
   -- window_padding = { top = 0, right = 0, bottom = 0, left = 0 },
   default_cursor_style = "SteadyBar",

   font_size = 11.0,
   font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "Hack",
  }),

   color_scheme = "Afterglow",
   -- color_scheme = "Batman",

   enable_wayland = true,

   check_for_updates = false,
   show_update_window = false,
   automatically_reload_config = false,

   keys = {
      {key = "c", mods = "CTRL|SHIFT", action = wezterm.action {CopyTo = "Clipboard"}}, -- default example
      {key = "v", mods = "CTRL|SHIFT", action = wezterm.action {PasteFrom = "Clipboard"}}, -- default example
      {key = "v", mods = "CTRL", action = wezterm.action {PasteFrom = "Clipboard"}},
      {key = "w", mods = "ALT", action = wezterm.action {CopyTo = "Clipboard"}},
      {key = "y", mods = "ALT", action = wezterm.action {PasteFrom = "Clipboard"}},
      {key = "y", mods = "CTRL", action = wezterm.action {PasteFrom = "Clipboard"}},
   }


}
