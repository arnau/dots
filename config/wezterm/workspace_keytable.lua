local wezterm = require("wezterm")
local action = wezterm.action
local Ring = require("ring").Ring

local ring = Ring:new({
  {
    key = "s",
    mods = "NONE",
    action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    desc = "Selects an existing workspace.",
  },
  {
    key = "n",
    mods = "NONE",
    action = action.PromptInputLine({
      description = wezterm.format({
        -- { Attribute = { Intensity = "Bold" } },
        { Foreground = { Color = "pink" } },
        { Text = "Enter name for new workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        -- `nil` when `<escape>`; empty string when `<enter>`.
        if line then
          window:perform_action(
            action.SwitchToWorkspace({ name = line }),
            pane
          )
        end
      end),
    }),
    desc = "Creates a new workspace. Prompts for a name.",
  },
})

local keytable = {
  { key = "?", mods = "NONE", action = action.Multiple {
    action.PopKeyTable,
    ring:show_help(),
  } },
}

for _, item in ipairs(ring.keys) do
  table.insert(keytable, { key = item.key, mods = item.mods, action = item.action })
end

return keytable
