-- Helpers for rings of keys. Making keytables shine.

local wezterm = require("wezterm")
local action = wezterm.action

-- { key, mods, action, desc }
local Ring = { keys = {} }

local m = {}

function Ring:new(keys)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.keys = keys or {}

  return o
end

function Ring:add(key)
  table.insert(self.keys, key)
end

--- Gets the unique identifier for the given ring item.
local function get_id(item)
  return item.mods .. "+" .. item.key
end

--- Formats the key shortcut for display.
local function format_key(key, mods)
  if mods == "NONE" or mods == nil then
    return key
  else
    return mods .. "+" .. key
  end
end

--- Gets a formatted label for the Ring help.
local function get_label(item)
  local tokens = {
    { Background = { Color = "NONE" } },
    { Foreground = { AnsiColor = "Blue" } },
    { Text = wezterm.pad_right(format_key(item.key, item.mods), 8) },
    { Foreground = { AnsiColor = "White" } },
    { Text = item.desc },
  }

  return wezterm.format(tokens)
end


--- Selects the ring item for the given id.
function Ring:get_item(id)
  for _, item in ipairs(self.keys) do
    if id == get_id(item) then
      return item
    end
  end
end

--- Shows the ring help as an overlay.
function Ring:show_help()
  local choices = {}

  for _, item in ipairs(self.keys) do
    table.insert(choices, { id = get_id(item), label = get_label(item) })
  end

  return action.InputSelector({
    title = "Pane Keytable help",
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      if not label then return end

      local item = Ring:get_item(id)

      child_window:perform_action(item.action, child_pane)
    end),
  })
end

m.get_id = get_id
m.Ring = Ring

return m
