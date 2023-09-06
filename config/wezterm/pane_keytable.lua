local wezterm = require("wezterm")
local action = wezterm.action

local keytable = {
  -- Select
  { key = "h",      mods = "NONE", action = action.ActivatePaneDirection("Left") },
  { key = "l",      mods = "NONE", action = action.ActivatePaneDirection("Right") },
  { key = "k",      mods = "NONE", action = action.ActivatePaneDirection("Up") },
  { key = "j",      mods = "NONE", action = action.ActivatePaneDirection("Down") },
  { key = "g",      mods = "NONE", action = action.PaneSelect },

  -- Resize
  { key = "h",      mods = "CTRL", action = action.AdjustPaneSize({ "Left", 5 }) },
  { key = "l",      mods = "CTRL", action = action.AdjustPaneSize({ "Right", 5 }) },
  { key = "k",      mods = "CTRL", action = action.AdjustPaneSize({ "Up", 5 }) },
  { key = "j",      mods = "CTRL", action = action.AdjustPaneSize({ "Down", 5 }) },

  -- Other
  { key = "d",      mode = "NONE", action = action.CloseCurrentPane { confirm = true } },

  -- Exit keytable
  { key = "q",      mods = "NONE", action = action.PopKeyTable },
  { key = "Escape", mods = "NONE", action = action.PopKeyTable },
}

return keytable
