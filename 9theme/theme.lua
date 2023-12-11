local awful = require "awful"

local theme = {}

theme.font          = "Roboto 16"

theme.bg_normal     = "#ffffeb"
theme.bg_focus      = "#eaffff"
theme.bg_urgent     = "#880000"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#000000"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#000000"

theme.useless_gap   = 0
theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#000000"
theme.border_marked = "#880000"

theme.wibar_bg = "#eaffff"
theme.wibar_fg = "#000000"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
theme.tasklist_fg_focus = "#ffffff"
theme.tasklist_bg_focus = "#448444"

theme.taglist_fg_focus = "#ffffff"
theme.taglist_bg_focus = "#448444"

theme.taglist_fg_empty = "#757373"

theme.prompt_bg = "#eaffff"

theme.bg_systray = "#eaffff"

return theme
