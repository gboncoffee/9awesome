local awful = require "awful"
local gears = require "gears"

local keybind = function(mods, key, f)
    return awful.key(mods, key, f, {})
end

local mousebind = awful.button

globalkeys = gears.table.join(
    keybind({ modkey }, "Return", function()
        awful.spawn(terminal)
    end),
    keybind({ modkey }, "Tab", function()
        awful.client.focus.byidx(1)
    end),

    keybind({ modkey }, "a", function()
        awful.screen.focused().prompt:run()
    end),
    keybind({ modkey, "Control" }, "r", awesome.restart),
    keybind({ modkey, "Control" }, "q", awesome.quit)
)
clientkeys = gears.table.join(
    keybind({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    keybind({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end),
    keybind({ modkey }, "w", function(c)
        c:kill()
    end)
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        keybind({ modkey }, "" .. i, function()
            local tag = awful.screen.focused().tags[i]
            if tag then
                tag:view_only()
            end
        end),
        keybind({ modkey, "Control" }, "" .. i, function()
            local tag = awful.screen.focused().tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end),
        keybind({ modkey, "Shift" }, "" .. i, function()
            if client.focus then
                local tag = awful.screen.focused().tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end)
    )
end
root.keys(globalkeys)

clientbuttons = gears.table.join(
    mousebind({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    mousebind({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    mousebind({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end),
    mousebind({ modkey }, 2, function(c)
        c:lower()
    end)
)
