local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "Noto Color Emoji",
})
config.font_size = 14

-- Keep adding configuration here
config.enable_tab_bar = false
config.window_decorations = "TITLE | RESIZE"

config.color_scheme = "Chalk (dark) (terminal.sexy)"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
	-- Scroll up/down with Alt + j/k
	{ key = "j", mods = "ALT", action = wezterm.action({ ScrollByLine = 3 }) }, -- Scroll down
	{ key = "k", mods = "ALT", action = wezterm.action({ ScrollByLine = -3 }) }, -- Scroll up
	-- Zoom in/out with Alt + Shift + j/k
	{ key = "j", mods = "ALT|SHIFT", action = "DecreaseFontSize" }, -- Zoom out
	{ key = "k", mods = "ALT|SHIFT", action = "IncreaseFontSize" }, -- Zoom in
}

return config
