---@diagnostic disable:undefined-global

local HOME = os.getenv("HOME")
Log = hs.logger.new("my")

Log.i("Initialising…")

-- Luarocks init
local package_path = {
  package.path,
  HOME .. "/.luarocks/share/lua/5.4/?.lua",
  HOME .. "/.luarocks/share/lua/5.4/?/init.lua",
}
local package_cpath = {
  package.cpath,
  HOME .. "/.luarocks/lib/lua/5.4/?.so",
}
package.path = table.concat(package_path, ";")
package.cpath = table.concat(package_cpath, ";")

Fennel = require("fennel")
table.insert(package.searchers, Fennel.searcher)

require("core")
