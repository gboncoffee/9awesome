local naughty = require "naughty"

-- Handle startup errors.
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title  = "Oops, there were errors during startup!",
        text   = awesome.startup_errors
    }
end

-- Signal connection to handle runtime errors.
do
    local in_err = false
    awesome.connect_signal("debug::error", function(err)
        if in_err then
            return
        end
        in_err = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title  = "Oops, an error happened!",
            text   = tostring(err)
        }

        in_err = false
    end)
end
