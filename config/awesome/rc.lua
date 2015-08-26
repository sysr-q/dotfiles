--  Part of the "sysrq dotfiles experience". Available at:
--     sysrq <chris@gibsonsec.org> https://gitlab.com/sysrq/dotfiles
--
--  This is free and unencumbered software released into the public domain.
--
--  Anyone is free to copy, modify, publish, use, compile, sell, or
--  distribute this software, either in source code form or as a compiled
--  binary, for any purpose, commercial or non-commercial, and by any
--  means.
--
--  In jurisdictions that recognize copyright laws, the author or authors
--  of this software dedicate any and all copyright interest in the
--  software to the public domain. We make this dedication for the benefit
--  of the public at large and to the detriment of our heirs and
--  successors. We intend this dedication to be an overt act of
--  relinquishment in perpetuity of all present and future rights to this
--  software under copyright law.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
--  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
--  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
--  OTHER DEALINGS IN THE SOFTWARE.
--
--  For more information, please refer to <http://unlicense.org>

awful       = require("awful")
awful.rules = require("awful.rules")
              require("awful.autofocus")
beautiful   = require("beautiful")
naughty     = require("naughty")
wibox       = require("wibox")
--
vicious = require("vicious")
          require("eminent")

-- Config options
home = (os.getenv("HOME") .. "/") or ""
theme_name = "holo"
date_format = "%Y-%m-%d %H:%M"

terminal = "termite"
locker = "lockmyi3"

modkey = "Mod4"

-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/themes/" .. theme_name .. "/theme.lua")

-- Tags
local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  --awful.layout.suit.magnifier,
  --awful.layout.suit.max,
  awful.layout.suit.fair,
  awful.layout.suit.floating,
}

tags = {}
for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end

-- Widgets
separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)

spacer = wibox.widget.textbox(" ")

systray = wibox.widget.systray()

-- APW/pulse (must be after beautiful.init)
local APW = require("apw/widget")

-- Battery -- TODO
batwidget = awful.widget.progressbar()
batwidget:set_width(40)
batwidget:set_height(8)
batwidget:set_vertical(false)
batwidget:set_background_color("#676767")
batwidget:set_border_color(nil)
batwidget:set_color("#D9D9D9")
--batwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 10 },
--    stops = { { 0, "#AECF96" }, { 0.5, "#88A175" }, { 1, "#FF5656" }}})
vicious.register(batwidget, vicious.widgets.bat, "$2", 3, "BAT0")

-- Clock
datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, "%Y-%m-%d %H:%M")

-- Wiboxes
mywibox     = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist   = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({}, 1, awful.tag.viewonly),
	awful.button({modkey}, 1, awful.client.movetotag),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({modkey}, 3, awful.client.toggletag))
mytasklist  = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
						  if c == client.focus then
							  c.minimized = true
						  else
							  -- Without this, the following
							  -- :isvisible() makes no sense
							  c.minimized = false
							  if not c:isvisible() then
								  awful.tag.viewonly(c:tags()[1])
							  end
							  -- This will also un-minimize
							  -- the client, if needed
							  client.focus = c
							  c:raise()
						  end
					  end))

for s = 1, screen.count() do
	mypromptbox[s] = awful.widget.prompt()
	--
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
		awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
		awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)
	))
	--
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
	--
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
	--
	mywibox[s] = awful.wibox({ position = "top", screen = s, height = 16 })

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(mytaglist[s])
	left_layout:add(mypromptbox[s])
	left_layout:add(spacer)

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
	right_layout:add(spacer)
	if s == 1 then
		right_layout:add(systray)
		right_layout:add(spacer)
	end
	right_layout:add(APW); right_layout:add(spacer)
	right_layout:add(datewidget); right_layout:add(spacer)
	right_layout:add(batwidget); right_layout:add(spacer)
	right_layout:add(mylayoutbox[s])

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	mywibox[s]:set_widget(layout)
end

-- Timers
local APWTimer = timer({ timeout = 0.5 }) -- set update interval in s
APWTimer:connect_signal("timeout", APW.Update)
APWTimer:start()

-- Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

  awful.key({ modkey,           }, "j",
      function ()
          awful.client.focus.byidx( 1)
          if client.focus then client.focus:raise() end
      end),
  awful.key({ modkey,           }, "k",
      function ()
          awful.client.focus.byidx(-1)
          if client.focus then client.focus:raise() end
      end),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey,           }, "Tab",
      function ()
          awful.client.focus.history.previous()
          if client.focus then
              client.focus:raise()
          end
      end),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift", "Control" }, "q", awesome.quit),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
  awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, "Control" }, "n", awful.client.restore),

  -- Prompt
  awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey }, "x",
            function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                widgets[mouse.screen].prompt.widget,
                awful.util.eval, nil,
                awful.util.getdir("cache") .. "/history_eval")
            end),
  -- Menubar
  awful.key({ modkey }, "p", function() awful.util.spawn(locker) end),

  -- Volume keys
  awful.key({}, "XF86AudioRaiseVolume",  APW.Up),
  awful.key({}, "XF86AudioLowerVolume",  APW.Down),
  awful.key({}, "XF86AudioMute",         APW.ToggleMute)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
  awful.key({ modkey,           }, "n",
      function (c)
          -- The client currently has the input focus, so it cannot be
          -- minimized, since minimized clients can't have the focus.
          c.minimized = true
      end),
  awful.key({ modkey,           }, "m",
      function (c)
          c.maximized_horizontal = not c.maximized_horizontal
          c.maximized_vertical   = not c.maximized_vertical
      end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
          function ()
            local screen = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
            if tag then
               awful.tag.viewonly(tag)
            end
          end),
    awful.key({ modkey, "Control" }, "#" .. i + 9,
          function ()
            local screen = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
            if tag then
             awful.tag.viewtoggle(tag)
            end
          end),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
          function ()
            if client.focus then
              local tag = awful.tag.gettags(client.focus.screen)[i]
              if tag then
                awful.client.movetotag(tag)
              end
           end
          end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
          function ()
            if client.focus then
              local tag = awful.tag.gettags(client.focus.screen)[i]
              if tag then
                awful.client.toggletag(tag)
              end
            end
          end))
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- Rules
awful.rules.rules = {
  { rule = { },
    properties = { border_width = beautiful.border_width,
           border_color = beautiful.border_normal,
           focus = awful.client.focus.filter,
           keys = clientkeys,
           buttons = clientbuttons } },
  { rule = { class = "pinentry" },
    properties = { floating = true } },
  { rule = { class = "gimp" },
    properties = { floating = true } },
--  { rule = { class = "Steam" },
--    properties = { floating = true } },
}
