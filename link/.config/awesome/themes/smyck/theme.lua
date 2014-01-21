local awful = require("awful")

local theme = {}

theme.name = "smyck"
theme.root = awful.util.getdir("config") .. "/themes/" .. theme.name .. "/"

theme.font          = "M+ 1p normal 9"

theme.bg_normal     = "#1b1b1b"
theme.bg_focus      = "#5d5d5d"
theme.bg_urgent     = "#c75646"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.highlight     = "#9cd9f0"

theme.fg_normal     = "#f7f7f7"
theme.fg_focus      = theme.fg_normal
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.bg_focus

theme.border_width  = 1
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_minimize

theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

theme.wallpaper = home .. "Pictures/WiP/cg-allison.png"

-- Layout icons
theme.layout_floating   = theme.root .. "layouts/floating.svg"
theme.layout_magnifier  = theme.root .. "layouts/magnify.svg"
theme.layout_max        = theme.root .. "layouts/max.svg"
theme.layout_tiletop    = theme.root .. "layouts/tiletop.svg"
theme.layout_tilebottom = theme.root .. "layouts/tilebottom.svg"
theme.layout_tileleft   = theme.root .. "layouts/tileleft.svg"
theme.layout_tile       = theme.root .. "layouts/tileright.svg"

-- Disable tasklist icons
theme.icon_theme = nil
theme.tasklist_disable_icon = true

return theme
