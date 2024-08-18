local wezterm = require("wezterm")
local action = wezterm.action
local Ring = require("ring").Ring

local ring = Ring:new({
  -- Select
  { key = "h", mods = "NONE", action = action.ActivatePaneDirection("Left"), desc = "Moves focus to the Left pane." },
  { key = "l", mods = "NONE", action = action.ActivatePaneDirection("Right"), desc = "Moves focus to the Right pane." },
  { key = "k", mods = "NONE", action = action.ActivatePaneDirection("Up"), desc = "Moves focus to the Top pane." },
  { key = "j", mods = "NONE", action = action.ActivatePaneDirection("Down"), desc = "Moves focus to the Bottom pane." },
  { key = "g", mods = "NONE", action = action.PaneSelect, desc = "Each pane shows a label. Typing it will move focus to that pane." },

  -- Resize
  { key = "h", mods = "CTRL", action = action.AdjustPaneSize({ "Left", 5 }), desc = "Resizes the pane towards the Left." },
  { key = "l", mods = "CTRL", action = action.AdjustPaneSize({ "Right", 5 }), desc = "Resizes the pane towards the Right." },
  { key = "k", mods = "CTRL", action = action.AdjustPaneSize({ "Up", 5 }), desc = "Resizes the pane towards the Top." },
  { key = "j", mods = "CTRL", action = action.AdjustPaneSize({ "Down", 5 }), desc = "Resizes the pane towards the Bottom." },

  -- Other
  { key = "d", mods = "NONE", action = action.CloseCurrentPane { confirm = true }, desc = "Closes the current pane." },

  -- Exit keytable
  { key = "q", mods = "NONE", action = action.PopKeyTable, desc = "Exits the key ring." },
})

local keytable = {
  { key = "?", mods = "NONE", action = action.Multiple {
    action.PopKeyTable,
    ring:show_help(),
  } },
  { key = "Escape", mods = "NONE", action = action.PopKeyTable },
}

for _, item in ipairs(ring.keys) do
  table.insert(keytable, { key = item.key, mods = item.mods, action = item.action })
end

return keytable
