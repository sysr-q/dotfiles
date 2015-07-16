local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local assault = require("assault")
local pulse = require("pulse")
local capi = { timer = timer }

home = (os.getenv("HOME") .. "/") or ""
theme_name = "smyck"
terminal = "termite"
locker = "dm-tool lock"
modkey = "Mod4"

-- {{{ Error handling
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = err,
    })

    in_error = false
  end)
end
-- }}}

-- {{{ Theming
beautiful.init(awful.util.getdir("config") .. "/themes/" .. theme_name .. "/theme.lua")

if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, false)
  end
end

-- }}}

-- {{{ Tags
local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.magnifier,
  awful.layout.suit.max,
  awful.layout.suit.floating,
}

tags = {}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Wiboxes
widgets = {
  spacer = wibox.widget.textbox(" "),
  all = {
    clock = awful.widget.textclock("%Y-%m-%d %H:%M", 1),
    taglist = {
      buttons = awful.util.table.join(
        awful.button({}, 1, awful.tag.viewonly),
        awful.button({modkey}, 1, awful.client.movetotag),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({modkey}, 3, awful.client.toggletag)
      ),
    },
    tasklist = {
      buttons = awful.util.table.join(
        awful.button({}, 1, function(c)
          if c == client.focus then
            c.minimized = true
          else
            c.minimized = false
            if not c:isvisible() then
              awful.tag.viewonly(c:tags()[1])
            end
            client.focus = c
            c:raise()
          end
        end)
      )
    },
    assault = assault({
      critical_level = 0.15,
      width = 28,
      height = 11,
      critical_color = beautiful.bg_urgent,
      charging_color = beautiful.highlight,
    }),
    volume = wibox.widget.textbox(),
  },
}

wiboxes = {}

for s = 1, screen.count() do
  widgets[s] = {}
  widgets[s].prompt = awful.widget.prompt()
  widgets[s].layoutbox = awful.widget.layoutbox(s)
  widgets[s].layoutbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)
  ))
  widgets[s].tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, widgets.all.tasklist.buttons)
  widgets[s].taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, widgets.all.taglist.buttons)

  wiboxes[s] = awful.wibox({ position = "top", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(widgets[s].taglist)
  left_layout:add(widgets[s].prompt)
  left_layout:add(widgets.spacer)

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(widgets.spacer)
  if s == 1 then right_layout:add(wibox.widget.systray()) end
  right_layout:add(widgets.spacer)
  right_layout:add(widgets.all.volume)
  right_layout:add(widgets.spacer)
  right_layout:add(widgets.all.clock)
  right_layout:add(widgets.spacer)
  right_layout:add(widgets.all.assault)
  right_layout:add(widgets[s].layoutbox)

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(widgets[s].tasklist)
  layout:set_right(right_layout)

  wiboxes[s]:set_widget(layout)
end
-- }}}

-- {{{ Timers
timer = capi.timer { timeout = 1 }
timer:connect_signal("timeout", function ()
  sym = "♪"
  if pulse.muteGet() then
    sym = "M"
  end
  widgets.all.volume:set_markup(string.format('<span color="' .. beautiful.highlight .. '">%s</span> %.1f%%', sym, pulse.volumeGet() * 100))
end)
timer:start()
timer:emit_signal("timeout")
-- }}}

-- {{{ Key bindings
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
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),

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
  awful.key({ modkey },            "r",     function () widgets[mouse.screen].prompt:run() end),

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
  awful.key({}, "#123", function()
    pulse.volumeUp()
  end),
  awful.key({}, "#122", function()
    pulse.volumeDown()
  end),
  awful.key({}, "#121", function()
    pulse.muteToggle()
  end)

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
-- }}}

-- {{{ Rules
awful.rules.rules = {
  { rule = { },
    properties = { border_width = beautiful.border_width,
           border_color = beautiful.border_normal,
           focus = awful.client.focus.filter,
           keys = clientkeys,
           buttons = clientbuttons } },
  { rule = { class = "MPlayer" },
    properties = { floating = true } },
  { rule = { class = "pinentry" },
    properties = { floating = true } },
  { rule = { class = "gimp" },
    properties = { floating = true } },
  { rule = { class = "Pidgin" },
    properties = { floating = true } },
  { rule = { class = "Steam" },
    properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
  -- Enable sloppy focus
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
