local wezterm = require("wezterm")
local action = wezterm.action
local mux = wezterm.mux
local roast_theme = require("roast_theme")
local workspaces = require("workspaces")
local pane_keytable = require("pane_keytable")

local config = wezterm.config_builder()

-- config.color_scheme = "AdventureTime"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 13.0
config.default_cursor_style = "SteadyBar"
config.cursor_thickness = "2px"

config.colors = roast_theme


-- tab bar
-- config.tab_bar_at_bottom = true
-- config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS"

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- if false, you can't move between panes.
config.unzoom_on_switch_pane = true

config.key_tables = {
  workspaces = workspaces,
  panes = pane_keytable,
}
config.disable_default_key_bindings = true
config.keys = {
  -- Leader keymaps
  { key = "a", mods = "LEADER|CTRL", action = action.SendKey { key = "a", mods = "CTRL" } },
  { key = "p", mods = "LEADER",      action = action.ActivateCommandPalette },
  { key = "s", mods = "LEADER",      action = action.ActivateCopyMode },
  { key = "c", mods = "LEADER",      action = action.QuickSelect },
  { key = "d", mods = 'LEADER|CTRL', action = action.ShowDebugOverlay },
  { key = "f", mods = "LEADER",      action = action.Search("CurrentSelectionOrEmptyString") },
  { key = "c", mods = "CMD",         action = action.CopyTo("Clipboard") },
  { key = "v", mods = "CMD",         action = action.PasteFrom("Clipboard") },

  -- panes
  { key = "v", mods = "LEADER",      action = action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "x", mods = "LEADER",      action = action.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "h", mods = "LEADER",      action = action.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER",      action = action.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER",      action = action.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER",      action = action.ActivatePaneDirection("Down") },
  { key = "g", mods = "LEADER",      action = action.PaneSelect },

  -- tabs
  { key = "t", mods = "LEADER",      action = action.ShowTabNavigator },
  { key = "1", mods = "CMD",         action = action.ActivateTab(0) },
  { key = "2", mods = "CMD",         action = action.ActivateTab(1) },
  { key = "3", mods = "CMD",         action = action.ActivateTab(2) },
  { key = "4", mods = "CMD",         action = action.ActivateTab(3) },
  { key = "5", mods = "CMD",         action = action.ActivateTab(4) },
  { key = "6", mods = "CMD",         action = action.ActivateTab(5) },
  { key = "7", mods = "CMD",         action = action.ActivateTab(6) },
  { key = "8", mods = "CMD",         action = action.ActivateTab(7) },
  { key = "9", mods = "CMD",         action = action.ActivateTab(8) },
  { key = "0", mods = "CMD",         action = action.ActivateTab(9) },
  { key = "]", mods = "LEADER",      action = action.ActivateTabRelative(1) },
  { key = "[", mods = "LEADER",      action = action.ActivateTabRelative(-1) },

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
      -- timeout_milliseconds = 1000,
      one_shot = false,

      replace_current = true,
      prevent_fallback = true,
    }),
  }

  -- {
  --   key = 'E',
  --   mods = 'CTRL|SHIFT',
  --   action = action.InputSelector {
  --     action = wezterm.action_callback(function (window, pane, id, label)
  --       if not id and not label then
  --         wezterm.log_info 'cancelled'
  --       else
  --         wezterm.log_info('you selected ', id, label)
  --         pane:send_text(id)
  --       end
  --     end),
  --     title = 'I am title',
  --     choices = {
  --       -- This is the first entry
  --       {
  --         -- Here we're using wezterm.format to color the text.
  --         -- You can just use a string directly if you don't want
  --         -- to control the colors
  --         label = wezterm.format {
  --           { Foreground = { AnsiColor = 'Red' } },
  --           { Text = 'No' },
  --           { Foreground = { AnsiColor = 'Green' } },
  --           { Text = ' thanks' },
  --         },
  --         -- This is the text that we'll send to the terminal when
  --         -- this entry is selected
  --         id = 'Regretfully, I decline this offer.',
  --       },
  --       -- This is the second entry
  --       {
  --         label = 'WTF?',
  --         id = 'An interesting idea, but I have some questions about it.',
  --       },
  --       -- This is the third entry
  --       {
  --         label = 'LGTM',
  --         id = 'This sounds like the right choice',
  --       },
  --     },
  --   },
  -- },

}

local gui_startup = function()
  local project_dir = wezterm.home_dir .. "/kitchen/cellar"

  local tab, main_pane, window = mux.spawn_window({
    cwd = project_dir,
    -- workspace = { "cellar" }
  })

  window:set_title("cellar")

  local bulletin_log = main_pane:split({
    direction = "Bottom",
    cwd = project_dir,
  })
  bulletin_log:send_text("hx data/bulletins/2023.csv\n")

  main_pane:activate()
end

local gui_startup_config = function()
  local project_dir = wezterm.home_dir .. "/.config/wezterm"

  local main_tab, main_pane, main_window = mux.spawn_window({
    cwd = project_dir,
    workspace = "config",
    width = 80,
    height = 100,
  })

  main_window:set_title("wezconfig")

  local main_top_pane = main_pane:split({
    direction = "Top",
    cwd = project_dir,
    size = 0.65,
  })

  main_top_pane:send_text("hx wezterm.lua\n")

  local support_tab, support_pane, support_window = main_window:spawn_tab({
  })

  local main_tab, main_pane, main_window = mux.spawn_window({
    cwd = project_dir,
    workspace = "other"
  })


  mux.set_active_workspace("config")
  main_top_pane:activate()
end
-- config.debug_key_events = true

wezterm.on("gui-startup", gui_startup_config)
wezterm.on("update-right-status", function(window, pane)
  local status = ""
  local key_table = window:active_key_table()
  local workspace = window:active_workspace()


  local mode_indicator = wezterm.format({
    { Foreground = { Color = "darkgrey" } },
    { Attribute = { Intensity = "Half" } },
    { Text = "mode: " },
  })

  if key_table then
    status = mode_indicator .. key_table .. "(" .. "w, n" .. ")"
  else
    status = workspace
  end

  status = wezterm.format({
    { Foreground = { Color = "pink" } },
    { Attribute = { Intensity = "Half" } },
    { Text = status },
  })

  status = status .. "    "

  window:set_right_status(status)
end)


return config
