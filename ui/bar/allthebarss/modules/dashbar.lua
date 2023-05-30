-- Imports and Variables

local awful        = require('awful')
local wibox        = require('wibox')
local beautiful    = require('beautiful')
local dpi          = beautiful.xresources.apply_dpi

local helpers      = require('helpers')
local Tray_icon    = beautiful.bar_size / 2
local Batt_length  = beautiful.bar_size * 1.25
local Side_padding = beautiful.is_bar_horizontal and beautiful.subt_font_size or beautiful.item_spacing
local Ends_padding = beautiful.is_bar_horizontal and beautiful.item_spacing or beautiful.subt_font_size

-- The Dashboard
local dashboard    = wibox.widget {
  {
    {
      text = "",
      font = beautiful.ic_font .. dpi(beautiful.title_font_size),
      align = "center",
      widget = wibox.widget.textbox
    },
    margins = dpi(beautiful.item_spacing),
    widget = wibox.container.margin
  },
  bg = beautiful.lbg,
  shape = helpers.mkroundedrect(),
  forced_height = dpi(beautiful.bar_size),
  forced_width = dpi(beautiful.bar_size),
  widget = wibox.container.background,
  buttons {

    awful.button({}, 1, function()
      awesome.emit_signal('widget::dashboard')
    end)

  }



}
helpers.add_hover(dashboard, beautiful.lbg, beautiful.blk)



-- The Bar adition

local bar_length = beautiful.is_bar_horizontal and dpi(50)
    or dpi(50)

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
          dashboard,


        },
        layout = beautiful.align_direction
      },
      left = dpi(Side_padding),
      right = dpi(Side_padding),
      top = dpi(Ends_padding),
      bottom = dpi(Ends_padding)


    }







  }
end)
