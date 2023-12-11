local beautiful = require "beautiful"
local awful = require "awful"
local gears = require "gears"

awful.rules.rules = {
    { rule = {}, properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.prefered,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }},
}

awful.layout.layouts = { awful.layout.suit.floating }

awful.screen.connect_for_each_screen(function(s)
    awful.tag(tags, s, awful.layout.layouts[1])
    wallpaper(s)

    require("acmebar").setup(s)
end)

-- Reset wallpaper when screen changes.
screen.connect_signal("property::geometry", wallpaper)

-- Change border color.
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
