local wezterm = require("wezterm")
local action = wezterm.action

-- Generates key mappings for the first 9 tabs.
local function activate_tabs(keytable)
  for i = 0, 9 do
    table.insert(keytable, {
      key = tostring(i),
      mods = "CMD",
      action = action.ActivateTab(i - 1),
    })
  end
end


local keytable = {
  { key = "n", mods = "LEADER|CTRL",    action = action.SpawnCommandInNewTab({
    label = "Start a nu shell",
    args = { "nu" },
  }) },
  -- { key = "t", mods = "CMD",    action = action.SpawnTab("CurrentPaneDomain") },
  { key = "t", mods = "CMD",    action = action.SpawnCommandInNewTab({
    label = "Start a fish shell",
    args = { "fish", "--interactive", "--login" },
  }) },
  { key = "w", mods = "CMD",    action = action.CloseCurrentTab({ confirm = true }) },
  { key = "t", mods = "LEADER", action = action.ShowTabNavigator },

  { key = "h", mods = "CMD",    action = action.ActivateTabRelative(-1) },
  { key = "l", mods = "CMD",    action = action.ActivateTabRelative(1) },

  { key = "[", mods = "CMD",    action = action.MoveTabRelative(-1) },
  { key = "]", mods = "CMD",    action = action.MoveTabRelative(1) },
}

activate_tabs(keytable)

return keytable
