-- Possibly load LuaRocks modules.
pcall(require, "luarocks.loader")

local beautiful = require "beautiful"

require "awful.autofocus"
require "handle_errors"
local awful = require "awful"

-- Init theme.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/9theme/theme.lua")

--
-- Main configuration.
--

modkey = "Mod4"
terminal = "st"
browser = "firefox"
acme = "acme.rc"
music = "strawberry"
tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- Must be a function. It's called for each screen
wallpaper = function(screen)
    awful.spawn("xsetroot -solid '#757373'")
end

require "binds"
require "setup"
