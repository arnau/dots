local wezterm = require("wezterm")
local action = wezterm.action

local workspace_keytable = {
  {
    key = "w",
    action = action.ShowLauncherArgs({
      flags = "FUZZY|WORKSPACES",
    }),
  },
  {
    key = "n",
    action = action.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Enter name for new workspace" },
      }),
      action = wezterm.action_callback(function (window, pane, line)
        -- `nil` when `<escape>`; empty string when `<enter>`.
        if line then
          window:perform_action(
            action.SwitchToWorkspace({ name = line }),
            pane
          )
        end
      end),
    }),
  }
}

return workspace_keytable
