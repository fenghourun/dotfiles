-- Pull in the wezterm API
local wezterm = require("wezterm")

-- TODO: cannot find file
-- local quietLight = wezterm.color.load_scheme("colors/quiet_light.toml")

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Dark"
end

local function get_window_decorations()
	if wezterm.target_triple:match("darwin") or wezterm.target_triple:match("linux") then
		return "RESIZE"
	else
		return "RESIZE | TITLE"
	end
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Gruvbox dark, hard (base16)"
	else
		return "Builtin Solarized Light"
	end
end

local function colors_for_appearance(appearance)
	if appearance:find("Dark") then
		return {
			background = "rgba(30, 32, 33, 0.7)",
			tab_bar = {
				background = "rgba(30, 32, 33, 0.7)",
			},
		}
	else
		return {
			background = "#f5f5f5",
			foreground = "#724197",
			cursor_fg = "#6b5792",
			cursor_bg = "#8b8198",
			cursor_border = "#8b8198",
			selection_bg = "#e3f6d4",
			selection_fg = "#724197",
			tab_bar = {
				background = "#c4b7d8",
				active_tab = {
					bg_color = "#724197",
					fg_color = "#f5f5f5",
				},
				inactive_tab = {
					bg_color = "#d6cfe2",
					fg_color = "#323232",
				},
				new_tab = {
					bg_color = "#c4b7d8",
					fg_color = "#323232",
				},
			},
			ansi = {
				"#323232",
				"#9d3f36",
				"#568a37",
				"#935f32",
				"#5168bf",
				"#6b5792",
				"#59839a",
				"#aaaaaa",
			},
			brights = {
				"#838f9e",
				"#bc3f38",
				"#e3f6d4",
				"#c49945",
				"#4578e9",
				"#906ad5",
				"#6ca8ce",
				"#fefefe",
			},
		}
	end
end

local appearance = get_appearance()
config.colors = colors_for_appearance(appearance)
config.color_scheme = scheme_for_appearance(appearance)

config.window_decorations = get_window_decorations()

config.keys = {
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
	{ key = "k", mods = "CMD", action = wezterm.action.ScrollByLine(-1) },
	{ key = "j", mods = "CMD", action = wezterm.action.ScrollByLine(1) },
}

config.font_size = 18
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.use_fancy_tab_bar = false
config.line_height = 1.1
config.tab_bar_at_bottom = true
config.window_padding = {
	top = 0,
	bottom = 0,
	right = 0,
	left = 0,
}

local function get_default_domain()
	if wezterm.target_triple:match("darwin") or wezterm.target_triple:match("linux") then
		return nil
	else
		return "WSL:Ubuntu"
	end
end
config.default_domain = get_default_domain()

-- and finally, return the configuration to wezterm
return config
