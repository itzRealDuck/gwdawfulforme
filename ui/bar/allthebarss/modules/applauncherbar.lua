-- the applauncher configuration
-- Imports

local awful        = require('awful')
local wibox        = require('wibox')
local beautiful    = require('beautiful')
local dpi          = beautiful.xresources.apply_dpi

local helpers      = require('helpers')

local app          = require('ui.app_launcher')
local Side_padding = beautiful.is_bar_horizontal and beautiful.subt_font_size or beautiful.item_spacing
local Ends_padding = beautiful.is_bar_horizontal and beautiful.item_spacing or beautiful.subt_font_size

return function(s)
  local applauncher = wibox.widget {
    {
      {
        {
          image = beautiful.awesome_icon,
          clip_shape = helpers.mkroundedrect(),
        },
        margins = dpi(beautiful.item_spacing),
        widget = wibox.container.margin,
      },
      color = beautiful.nbg,
      shape = helpers.mkroundedrect(),
      forced_height = dpi(beautiful.bar_size),
      forced_width = dpi(beautiful.bar_size),
      widget = wibox.container.background,
      buttons = {

        awful.button({}, 1, function()
          app:toggle()
        end)

      }
    },



  }
  helpers.add_hover(applauncher, beautiful.lbg, beautiful.blk)

  local bar_length = beautiful.is_bar_horizontal and dpi(50)
      or dpi(50)


  s.mywibox = awful.wibar {
    visible = beautiful.bar_enabled,
    position = beautiful.bar_slide,
    screen = s,
    width = beautiful.is_bar_horizontal and dpi(bar_length) or dpi(beautiful.bar_size),
    height = beautiful.is_bar_horizontal and dpi(beautiful.bar_size) or dpi(bar_length),
    widget {
      {
        {
          applauncher,

        },
        layout = beautiful.align_direction,
      },
      left = dpi(Side_padding),
      right = dpi(Side_padding),
      bottom = dpi(Ends_padding),
      top = dpi(Ends_padding),
      widget = wibox.container.margin



    }

  }

  awesome.connect_signal("widget::bar", function()
    local s = awful.screen, focused()
    s.mywibox.visible = not s.mywibox.visible
  end
  )
end
