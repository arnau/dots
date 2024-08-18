-- Helpers for managing pane layouts.
local wezterm = require("wezterm")
local mux = wezterm.mux

local m = {}

function m.spawn_layout(name, dir)
  local main_tab, main_pane, main_window = mux.spawn_window({
    cwd = dir,
    workspace = name,
  })

  main_window:set_title("main")
  main_pane:send_text("nu\n")

  local left_pane = main_pane:split({
    direction = "Left",
    cwd = project_dir,
    size = 0.40,
  })

  left_pane:activate()
end

function m.spawn_layout2(name, dir)
  local main_tab, main_pane, main_window = mux.spawn_window({
    cwd = dir,
    workspace = name,
    width = 180,
    height = 100,
  })

  main_window:set_title("main")
  main_pane:send_text("nu\n")

  local main_top_pane = main_pane:split({
    direction = "Top",
    cwd = project_dir,
    size = 0.65,
  })

  main_top_pane:send_text("hx wezterm.lua\n")

  main_top_pane:activate()
end

return m
