-- Status line helpers
local wezterm = require("wezterm")
local helpers = require("helpers")

local m = {}

--- Sigils marking types of statuses.
m.sigils = {
  main = "",
  overlay = "󱐋",
  mode = "🅼",
}

local digits = {
  utf8.char(0x278A),
  utf8.char(0x278B),
  utf8.char(0x278C),
  utf8.char(0x278D),
  utf8.char(0x278E),
  utf8.char(0x278F),
  utf8.char(0x2790),
  utf8.char(0x2791),
  utf8.char(0x2792),
}

--- Formats the overlay status.
--
-- @param title The overlay title.
-- @return A formatted text.
--
-- ```lua
-- overlay_status(pane:get_title())
-- ```
function m.overlay_status(title)
  local tokens = {
    { Background = { Color = "NONE" } },
    { Text = " " },
    { Foreground = { Color = "gold"} },
    { Text = m.sigils.overlay },
    { Text = " " },
    { Foreground = { Color = "lightgrey"} },
    { Text = title },
  }

  return wezterm.format(tokens)
end

local function short_home_dir(path)
  return path:gsub(wezterm.home_dir, "~")
end

--- Chooses the sigil colour given the state of the Window.
--
-- @param window A wezterm Window
local function sigil_colour(window)
  if window:leader_is_active() then
    return "Fuchsia"
  else
    return "Blue"
  end
end

local function digit(n)
  local digit = digits[n + 1]

  if digit then
    return digit
  else
    return utf8.char(0xF444)
  end
end

--- Formats the context status.
--
-- @param window A wezterm Window
-- @param window A wezterm Pane
function m.context_status(window, pane)
  local process_info = pane:get_foreground_process_info()
  local tab_info = helpers.active_tab(window)

  -- When there is no working directory we assume an overlay has been activated
  if process_info == nil then
    return m.overlay_status(pane:get_title())
  end
  local path = process_info.cwd

  local tokens = {
    { Background = { Color = "NONE" } },
    { Text = " " },
    { Foreground = { AnsiColor = sigil_colour(window) } },
    { Text = digit(tab_info.index) },
    { Text = " " },
    { Attribute = { Intensity = "Half" } },
    { Foreground = { AnsiColor = "Silver" } },
    { Text = short_home_dir(path) },
  }

  return wezterm.format(tokens)
end


local function keytables(window)
  local config = window:effective_config()

  local result = {}
  local keys = config.keys

    --   {
    --     "action": {
    --         "ActivateKeyTable": {
    --             "name": "workspaces",
    --             "one_shot": true,
    --             "prevent_fallback": false,
    --             "replace_current": false,
    --             "timeout_milliseconds": 1000,
    --             "until_unknown": false,
    --         },
    --     },
    --     "key": "Space",
    --     "mods": "LEADER",
    -- },
  for _, item in ipairs(keys) do
    if item.action["ActivateKeyTable"] then
      table.insert(result, item)
    end
  end

  return result
end

local function keytable_keys(name, config)
  local result = {}
  local key_table = config.key_tables[name]

  for _, item in ipairs(key_table) do
    if item.action ~= "PopKeyTable" then
      if item.mods == "NONE" then
        table.insert(result, item.key)
      else
        table.insert(result, table.concat({item.mods, item.key}, "+"))
      end
    end
  end

  return result
end


--- Format the mode status.
--
-- @param window A wezterm Window
-- @param window A wezterm Pane
function m.mode_status(window, pane)
  local tokens = {}
  local key_table = window:active_key_table()
  local workspace = window:active_workspace()

  local keytable_sigils = {
    m = "ⓜ",
    s = "s",
    w = "ⓦ",
  }

  if key_table then
    table.insert(tokens, { Background = { Color = "NONE" } })
    table.insert(tokens, { Foreground = { AnsiColor = "Blue" } })
    table.insert(tokens, { Text = key_table })
    table.insert(tokens, { Foreground = { AnsiColor = "Grey" } })
    table.insert(tokens, { Text = " · " })
  end

  if workspace then
    table.insert(tokens, { Background = { Color = "NONE" } })
    table.insert(tokens, { Foreground = { Color = "pink" } })
    table.insert(tokens, { Text = workspace })
    table.insert(tokens, { Background = { Color = "NONE" } })
    table.insert(tokens, { Text = "  " })
  end

  return wezterm.format(tokens)
end



return m
