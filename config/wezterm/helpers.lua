-- General helpers

local m = {}


-- Merges table t2 into table t1.
function m.merge(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
end

-- Appends an array a2 to an array a1.
function m.append(a1, a2)
  for _, v in ipairs(a2) do
    table.insert(a1, v)
  end
end


function m.active_pane(tab)
  for _, item in ipairs(tab:panes_with_info()) do
    if item.is_active then
      return item
    end
  end
end


function m.active_tab(window)
  local mwin = window:mux_window()

  for _, item in ipairs(mwin:tabs_with_info()) do
    if item.is_active then
      return item
    end
  end
end

function m.split_path(path)
  local sep = "/"
  local t = {}

  for str in string.gmatch(path, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end

  return t
end


return m
