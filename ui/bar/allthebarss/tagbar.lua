-- Imports

local awful        = require('awful')
local wibox        = require('wibox')
local beautiful    = require('beautiful')
local dpi          = beautiful.xresources.apply_dpi

local helpers      = require('helpers')
local gettags      = require('ui.bar.modules.tags')
-- Vars
local Tray_icon    = beautiful.bar_size / 2
local Batt_length  = beautiful.bar_size * 1.25
local Side_padding = beautiful.is_bar_horizontal and beautiful.subt_font_size or beautiful.item_spacing
local Ends_padding = beautiful.is_bar_horizontal and beautiful.item_spacing or beautiful.subt_font_size

-- No wibox.widget or like that this time straight to the bar
-- Tag bar

-- bar length
local bar_length   = beautiful.is_bar_horizontal and dpi(200)
    or dpi(200)

-- the bar

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7" }, s, awful.layout.layouts[1])

  local taglist_v = wibox.widget {
    {
      gettags(s),
      margins = dpi(beautiful.title_font_size),
      widget  = wibox.container.margin
    },
    shape  = helpers.mkroundedrect(),
    bg     = beautiful.lbg,
    widget = wibox.container.background
  }
  local taglist_h = wibox.widget {
    taglist_v,
    direction = "east",
    widget    = wibox.container.rotate
  }
  s.mywibox = awful.wibar {

    visible  = beautiful.bar_enabled,
    position = beautiful.bar_side,
    screen   = s,
    width    = beautiful.is_bar_horizontal and dpi(bar_length) or dpi(beautiful.bar_size),
    height   = beautiful.is_bar_horizontal and dpi(bar_length) or dpi(beautiful.bar_size),
    widget   = {
      {
        beautiful.is_bar_horizontal and taglist_h or taglist_v

      },
      layout = beautiful.align_direction,
    },
    left     = dpi(Side_padding),
    right    = dpi(Side_padding),
    top      = dpi(Side_padding),
    bottom   = dpi(Side_padding)


  }
end)
