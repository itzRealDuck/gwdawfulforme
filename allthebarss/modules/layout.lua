-- Imports
----------
local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require('helpers')
local getlayout = require('ui.bar.modules.layout')


-- Variables
------------
local Tray_icon    = beautiful.bar_size / 2
local Batt_length  = beautiful.bar_size * 1.25
local Side_padding = beautiful.is_bar_horizontal and beautiful.subt_font_size or beautiful.item_spacing
local Ends_padding = beautiful.is_bar_horizontal and beautiful.item_spacing or beautiful.subt_font_size


-- Awesome Bar
--------------

-- The Length
-------------

local bar_length = beautiful.is_bar_horizontal and dpi(60) or dpi(60)

screen.connect_signal("request::desktop_decoration", function(s)
  s.mywibox = awful.wibar {

    visible = beautiful.bar_enabled,
    position = beautiful.bar_slide,
    screen = s,
    width = beautiful.is_bar_horizontal and dpi(bar_length) or dpi(beautiful.bar_size),
    height = beautiful.is_bar_horizontal and dpi(beautiful.bar_size) or dpi(bar_length),
    widget {

      {
        {
          {
            getlayout(s),
            margins = dpi(beautiful.item_padding),
            widget = wibox.container.margin
          },
          bg = beautiful.lbg,
          shape = helpers.mkroundedrect(),
          widget = wibox.container.background,
        },
        layout = beautiful.align_direction
      },
      left = dpi(Side_padding),
      right = dpi(Side_padding),
      top = dpi(Ends_padding),
      bottom = dpi(Ends_padding),
      widget = wibox.container.margin

    }
  }
end)
