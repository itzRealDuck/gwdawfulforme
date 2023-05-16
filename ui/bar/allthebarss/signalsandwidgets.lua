-- Imports
----------
local awful        = require('awful')
local wibox        = require('wibox')
local beautiful    = require('beautiful')
local dpi          = beautiful.xresources.apply_dpi

local helpers      = require('helpers')

-- Variables
------------
local Tray_icon    = beautiful.bar_size / 2
local Batt_length  = beautiful.bar_size * 1.25
local Side_padding = beautiful.is_bar_horizontal and beautiful.subt_font_size or beautiful.item_spacing
local Ends_padding = beautiful.is_bar_horizontal and beautiful.item_spacing or beautiful.subt_font_size


-- The Bar
---------

-- Status widgets For like the bluetooth and that

local function status_widget(button)
  local status = wibox.widget {
    {
      {
        id     = "text_role",
        font   = beautiful.ic_font .. dpi(beautiful.title_font_size),
        align  = "center",
        widget = wibox.widget.textbox,
      },
      margins = dpi(beautiful.item_spacing),
      widget  = wibox.container.margin
    },
    bg       = beautiful.nbg,
    shape    = helpers.mkroundedrect(),
    widget   = wibox.container.background,
    buttons  = {
      awful.button({}, 1, button)
    },
    set_text = function(self, content)
      self:get_children_by_id('text_role')[1].text = content
    end
  }
  helpers.add_hover(status, beautiful.nbg, beautiful.lbg)
  return status
end

local bar_btn_sound    = status_widget(function() awesome.emit_signal("volume::mute") end)
local bar_btn_net      = status_widget()
local bar_btn_blue     = status_widget(function() awesome.emit_signal("bluetooth::toggle") end)

-- Battery

local battery_prog     = wibox.widget {
  max_value = 100,
  forced_width = dpi(Batt_length),
  clip = true,
  shape = helpers.mkroundedrect(),
  bar_shape = helpers.mkroundedrect(),
  background_color = beautiful.bg_focus,
  border_color = beautiful.bg_focus,
  border_width = dpi(beautiful.item_spacing),
  color = {
    type = "linear",
    from = { dpi(beautiful.bar_size), 0 },
    to = { 0, 0 },
    stops = { { 0, beautiful.grn }, { 1, beautiful.grn_d } },
  },
  widget = wibox.widget.progressbar

}
local flipped_battery  = wibox.widget {
  battery_prog,
  direction = "east",
  widget = wibox.container.rotate,




}
local bar_battery_text = wibox.widget {
  {
    id = "text_role",
    font = beautiful.ic_font .. dpi(beautiful.title_font_size),
    align = "center",
    widget = wibox.widget.textbox,
  },
  margins = dpi(beautiful.item_spacing),


}

-- Systray

local systray          = wibox.widget {
  {
    base_size = 50,
    horizontal = beautiful.is_bar_horizontal,
    reverse = false,
    widget = wibox.widget.systray,
  },
  align = "center",
  visible = false,
  layout = wibox.container.place,


}
