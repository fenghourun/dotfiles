-- Pull in the wezterm API
local wezterm = require("wezterm")

-- TODO: cannot find file
-- local quietLight = wezterm.color.load_scheme("colors/quiet_light.toml")

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
local function get_appearance()
  -- if wezterm.gui then
  -- 	return wezterm.gui.get_appearance()
  -- end

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
  -- Palette mirrors the nvim "chalk" theme (lua/theme/themes/chalk.lua) so the
  -- tab bar matches the editor instead of falling back to Gruvbox defaults.
  local bg_dark = "#182b26" -- background_dark (the green-tinted base)
  local bg_light = "#1e362f" -- background_light
  local fg = "#c7c7c7" -- foreground
  local accent = "#c3f884" -- green
  local accent_soft = "#8ec07c" -- func / barbar_current
  local dim = "#6b7a72" -- muted grey-green for inactive tabs

  return {
    background = "rgba(24, 43, 38, 0.75)",
    tab_bar = {
      background = "rgba(24, 43, 38, 0.75)",
      active_tab = {
        bg_color = bg_light,
        fg_color = accent,
        intensity = "Bold",
      },
      inactive_tab = {
        bg_color = bg_dark,
        fg_color = dim,
      },
      inactive_tab_hover = {
        bg_color = bg_light,
        fg_color = fg,
        italic = true,
      },
      new_tab = {
        bg_color = bg_dark,
        fg_color = dim,
      },
      new_tab_hover = {
        bg_color = bg_light,
        fg_color = accent_soft,
        italic = true,
      },
    },
  }
end

local appearance = get_appearance()
config.max_fps = 240
config.animation_fps = 240
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
  {
    key = '|',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  -- Add more keybindings for other directions (j, k, l) as needed
  {
    key = 'j',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },
  {
    key = 'k',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },
  {
    key = 'l',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Right'),
  }
}

config.font_size = 15
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.line_height = 1.2
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

-- Clean, predictable tab titles so they don't get truncated mid-word.
-- Returning a plain string lets the active_tab/inactive_tab colors above apply.
local function basename(s)
  return (string.gsub(s, "(.*[/\\])(.*)", "%2"))
end

wezterm.on("format-tab-title", function(tab, tabs, panes, conf, hover, max_width)
  local pane = tab.active_pane

  -- Prefer the pane title set by the running program (carries the hostname
  -- over ssh, etc.). Fall back to the cwd basename, then the process name.
  local title = pane.title
  if not title or title == "" then
    local cwd = pane.current_working_dir
    if cwd then
      title = basename(cwd.file_path or tostring(cwd))
    end
  end
  if not title or title == "" then
    title = basename(pane.foreground_process_name or "shell")
  end

  local index = tostring(tab.tab_index + 1)
  local zoom = pane.is_zoomed and " 🔍" or ""
  local label = " " .. index .. ": " .. title .. zoom .. " "

  -- Truncate gracefully with "..." instead of a hard cut.
  if #label > max_width then
    label = wezterm.truncate_right(label, max_width - 3) .. "... "
  end

  return label
end)

-- and finally, return the configuration to wezterm
return config
