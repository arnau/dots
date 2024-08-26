local wezterm = require("wezterm")
local action = wezterm.action
local mux = wezterm.mux
local helpers = require("helpers")
local roast_theme = require("roast_theme")
local workspace_keytable = require("workspace_keytable")
local pane_keytable = require("pane_keytable")
local tab_keytable = require("tab_keytable")
local statusline = require("statusline")
local layouts = require("layouts")

local config = wezterm.config_builder()

local paths = {
  "/opt/homebrew/bin",
  os.getenv("HOME") .. "/.rye",
  os.getenv("HOME") .. "/.local/bin",
  os.getenv("HOME") .. "/.cargo/bin",
  os.getenv("PATH"),
}

config.set_environment_variables = {
  PATH = table.concat(paths, ":"),
  XDG_CONFIG_HOME = os.getenv("HOME") .. "/.config",
}

-- config.skip_close_confirmation_for_processes_named = {}

config.font = wezterm.font("JetBrains Mono")
config.warn_about_missing_glyphs = false
config.font_size = 13.0
config.default_cursor_style = "SteadyBar"
config.cursor_thickness = "2px"

-- config.color_scheme = "AdventureTime"
config.colors = roast_theme

-- statusline
config.window_decorations = "RESIZE"
config.window_frame = {
  font = wezterm.font("JetBrains Mono", { weight = "Regular" }),
  font_size = 11.0,
  active_titlebar_bg = "#111111",
}
config.use_fancy_tab_bar = true
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- if false, you can't move between panes.
config.unzoom_on_switch_pane = true

-- config.debug_key_events = true
config.disable_default_key_bindings = true

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.key_tables = {
  workspaces = workspace_keytable,
  panes = pane_keytable,
}

config.keys = {
  -- Leader keymaps
  { key = "a", mods = "LEADER|CTRL", action = action.SendKey { key = "a", mods = "CTRL" } },
  { key = "q", mods = "CMD",         action = action.QuitApplication },
  { key = "r", mods = "LEADER|CTRL", action = action.ReloadConfiguration },
  { key = "d", mods = "LEADER|CTRL", action = action.ShowDebugOverlay },
  { key = "f", mods = "LEADER|CTRL", action = action.ToggleFullScreen },

  { key = "p", mods = "LEADER",      action = action.ActivateCommandPalette },
  { key = "s", mods = "LEADER",      action = action.ActivateCopyMode },
  { key = "c", mods = "LEADER",      action = action.QuickSelect },
  { key = "/", mods = "LEADER",      action = action.Search("CurrentSelectionOrEmptyString") },
  { key = "z", mods = "LEADER",      action = action.TogglePaneZoomState },

  { key = "c", mods = "CMD",         action = action.CopyTo("Clipboard") },
  { key = "v", mods = "CMD",         action = action.PasteFrom("Clipboard") },

  -- windows
  { key = "n", mods = "CMD",         action = action.SpawnWindow },

  -- panes
  { key = "v", mods = "LEADER",      action = action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "x", mods = "LEADER",      action = action.SplitVertical { domain = "CurrentPaneDomain" } },

  { key = "h", mods = "LEADER",      action = action.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER",      action = action.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER",      action = action.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER",      action = action.ActivatePaneDirection("Down") },
  { key = "g", mods = "LEADER",      action = action.PaneSelect },


  -- Keytables
  -----------------------------------------------------------------------------
  {
    key = "Space",
    mods = "LEADER",
    action = action.ActivateKeyTable({
      name = "workspaces",
      timeout_milliseconds = 1000
    }),
  },
  {
    key = "w",
    mods = "LEADER",
    action = action.ActivateKeyTable({
      name = "panes",
      one_shot = false,
      replace_current = true,
      prevent_fallback = true,
    }),
  }
}

-- tabs
helpers.append(config.keys, tab_keytable)

local startup_config = function()
  layouts.spawn_layout2("config", wezterm.home_dir .. "/.config/wezterm")
  layouts.spawn_layout("kitchen", wezterm.home_dir .. "/kitchen")

  mux.set_active_workspace("kitchen")
end


-- Events

wezterm.on("gui-startup", startup_config)

wezterm.on("update-status", function(window, pane)
  window:set_right_status(statusline.mode_status(window, pane))
  window:set_left_status(statusline.context_status(window, pane))
end)


return config
