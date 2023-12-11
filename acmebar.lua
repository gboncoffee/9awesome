local wibox = require "wibox"
local gears = require "gears"
local awful = require "awful"
local beautiful = require "beautiful"
local naughty = require "naughty"
local mg = mousegrabber

local M = {}

local sep = wibox.widget.textbox(" | ")

local nop = function()
    return
end

local text_runner = function(prompt)
    local txt = wibox.widget.textbox(" Run")

    txt:connect_signal("button::press", function()
        prompt:run()
    end)

    return txt
end

local acme_spawn = function(t, s)
    local spawn = wibox.widget.textbox(" " .. t)
    spawn:connect_signal("button::press", function()
	awful.spawn(s)
    end)

    return spawn
end

local resize_box = wibox {
    border_width = 1,
    border_color = beautiful.border_normal,
    ontop = true,
    visible = false,
}

local doreshape = function(c, x, y, width, height)
    if c.size_hints.min_width and width < c.size_hints.min_width then
        width = c.size_hints.min_width
    end
    if c.size_hints.min_height and height < c.size_hints.min_height then
        height = c.size_hints.min_height
    end

    if width < 50 or height < 50 then
        return
    end

    c.x = x
    c.y = y
    c.width = width
    c.height = height
end

local reshape = function()
    local c = client.focus
    if not c then
        return
    end
    local x = nil
    local y = nil
    local pressed1first = true
    local try_reshape = function(m)
        if m.buttons[1] and pressed1first then
            return true
        elseif pressed1first then
            pressed1first = false
            return true
        end
        if m.buttons[2] or m.buttons[3] then
            return false
        end
        if m.buttons[1] then
            if not (x and y) then
                x = m.x
                y = m.y
                resize_box.x = x
                resize_box.y = y
                resize_box.width = 1
                resize_box.height = 1
                resize_box.screen = c.screen
                resize_box.visible = true
            else
                if m.x < x then
                    resize_box.x = m.x
                    resize_box.width = (x - m.x) + 1
                else
                    resize_box.width = (m.x - x) + 1
                end

                if m.y < y then
                    resize_box.y = m.y
                    resize_box.height = (y - m.y) + 1
                else
                    resize_box.height = (m.y - y) + 1
                end
            end
            return true
        elseif x and y then
            resize_box.visible = false
            doreshape(
                c,
                resize_box.x,
                resize_box.y,
                resize_box.width,
                resize_box.height
            )
            return false
        end
        return true
    end

    mg.run(try_reshape, "crosshair")
end

local move = function()
    local c = client.focus
    if not c then
        return
    end

    local pressed1first = true
    local try_move = function(m)
        if m.buttons[1] and pressed1first then
            return true
        elseif pressed1first then
            pressed1first = false
            return true
        end

        resize_box.width = c.width
        resize_box.height = c.height
        resize_box.x = m.x
        resize_box.y = m.y
        resize_box.visible = true

        if m.buttons[1] then
            resize_box.visible = false
            c.x = resize_box.x
            c.y = resize_box.y
            return false
        end

        if m.buttons[2] or m.buttons[3] then
            resize_box.visible = false
            return false
        end

        return true
    end

    mg.run(try_move, "crosshair")
end

local maximize = function()
    local c = client.focus
    if not c then
        return
    end

    c.maximized = not c.maximized
    c:raise()
end

local kill = function()
    local c = client.focus
    if not c then
        return
    end

    local orig_text = c.screen.killer.text
    local pressed1first = true
    c.screen.killer.text = " <Button 1 to confirm kill>"
    local try_kill = function(m)
        if m.buttons[1] and pressed1first then
            return true
        elseif pressed1first then
            pressed1first = false
            return true
        end

        if m.buttons[2] or m.buttons[3] then
            c.screen.killer.text = orig_text
            return false
        end

        if m.buttons[1] then
            c.screen.killer.text = orig_text
            c:kill()
            return false
        end

        return true
    end

    mg.run(try_kill, "pirate")
end

local exit = function()
    local s = awful.screen.focused()
    local orig_text = s.exiter.text
    s.exiter.text = " <Button 1 to confirm exit> "
    local try_exit = function(m)
        if m.buttons[1] and pressed1first then
            return true
        elseif pressed1first then
            pressed1first = false
            return true
        end

        if m.buttons[2] or m.buttons[3] then
            s.exiter.text = orig_text
            return false
        end

        if m.buttons[1] then
            s.exiter.text = orig_text
            awesome.quit()
            return false
        end

        return true
    end

    mg.run(try_exit, "pirate")
end

local acme_action = function(text, f)
    local action = wibox.widget.textbox(" " .. text)

    action:connect_signal("button::press", function()
	f()
    end)

    return action
end

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c:raise()
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end)
)

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({}, 3, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 2, awful.tag.viewtoggle)
)

M.setup = function(s)
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
    s.tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    s.prompt = awful.widget.prompt { prompt = ": " }

    s.killer = acme_action("Kill", kill)
    s.exiter = acme_action("Exit ", exit)

    s.acmewibox = awful.wibar {
        position = "top",
        screen = s,
        border_width = 1,
        border_color = beautiful.border_normal
    }
    s.acmewibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.taglist,
            acme_action("Reshape", reshape),
            acme_action("Move", move),
            acme_action("Maximize", maximize),
            s.killer,
            wibox.widget.textbox(" "),
        },
        s.tasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            acme_spawn("Acme", acme),
            acme_spawn("Browser", browser),
            acme_spawn("Terminal", terminal),
            acme_spawn("Music", music),
            text_runner(s.prompt),
            s.prompt,
            sep,
            wibox.widget.textclock(),
            wibox.widget.systray(),
            s.exiter
        }
    }
end

return M
