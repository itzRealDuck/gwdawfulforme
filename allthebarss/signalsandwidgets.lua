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

local systray_btn      = wibox.widget {

  {
    {
      text = "",
      font = beautiful.ic_font .. dpi(beautiful.title_font_size),
      align = "center",
      widget = wibox.widget.textbox
    },
    direction = beautiful.is_bar_horizontal and "south" or "east",
    widget = wibox.container.rotate
  },
  bg = beautiful.nbg,
  shape = helpers.mkroundedrect(),
  widget = wibox.container.background,
  buttons = {

    awful.button({}, 1, function()
      systray.visible = not systray.visible
    end)

  }

}

helpers.add_hover(systray_btn, beautiful.nbg, beautiful.lbg)

local v_clock = wibox.widget {
  {
    {
      {
        format = '<b>%H<b>',
        font = beautiful.mn_font .. dpi(beautiful.title_font_size),
        halign = "center",
        widget = wibox.widget.textclock
      },
      {
        {
          format = '<b>%M<b>',
          font = beautiful.mn_font .. dpi(beautiful.title_font_size),
          halign = "center",
          widget = wibox.widget.textclock
        },
        fg = beautiful.dfg,
        widget = wibox.container.background
      },
      layout = wibox.layout.fixed.vertical
    },
    margins = dpi(beautiful.item_spacing),
    widget = wibox.container.margin
  },
  bg = beautiful.lbg,
  shape = helpers.mkroundedrect(),
  widget = wibox.container.background
}

local h_clock = wibox.widget {
  {
    {
      format = '<b>%H:%M<b>',
      font = beautiful.mn_font .. dpi(beautiful.title_font_size),
      halign = "center",
      widget = wibox.widget.textclock
    },
    margins = dpi(beautiful.item_spacing),
    widget = wibox.container.margin
  },
  bg = beautiful.lbg,
  shape = helpers.mkroundedrect(),
  widget = wibox.container.background

}


-- The Awesome Bar
------------------

-- The Length
------------

local bar_length = beautiful.is_bar_horizontal and dpi(500) or dpi(500)

screen.connect_signal("request::desktop_decoration", function(s)
  s.mywibox = awful.wibar {

    visible = beautiful.bar_enabled,
    position = beautiful.bar_slide,
    screen = s,
    width = beautiful.is_bar_horizontal and dpi(bar_length) or dpi(beautiful.bar_size),
    height = beautiful.is_bar_horizontal and dpi(beautiful.bar_size) or dpi(bar_length),
    widget = {
      {
        systray,
        systray_btn,
        {
          beautiful.is_bar_horizontal and battery_prog or flipped_battery,
          {
            bar_battery_text,
            fg = beautiful.bg_normal,
            widget = wibox.container.background
          },
          visible = beautiful.battery_enabled,
          layout = wibox.layout.stack,
        },
        beautiful.is_bar_horizontal and h_clock or v_clock,
        {
          bar_btn_sound,
          {
            bar_btn_blue,
            visible = beautiful.bluetooth_enabled,
            widget = wibox.container.background,
          },
          bar_btn_net,
          layout = beautiful.fixed_direction,
        },
        layout = beautiful.align_direction,
      },
      left = dpi(Side_padding),
      right = dpi(Side_padding),
      top = dpi(Ends_padding),
      bottom = dpi(Ends_padding),
      widget = wibox.container.margin
    },


  }
end)


-- Signals (This is not complete since i am adding more signals and boxes for them)
----------

-- Battery Signal
-----------------

if beautiful.battery_enabled then
  awesome.connect_signal("signal::battery", function(level, state, _, _)
    battery_prog.value = level

    if state ~= 2 then
      bar_battery_text.text = ""
    else
      bar_battery_text = " "
    end
  end)
end

-- Volume Signal
----------------

awesome.connect_signal("signal::volume", function(volume, muted)
  if muted then
    bar_btn_sound.text    = ""
    bar_btn_sound.visible = true
  else
    bar_btn_sound.visible = false
  end
end)

-- Basic Network signals
------------------------

if beautiful.bluetooth_enabled then
  awesome.connect_signal("signal::bluetooth", function(is_enabled)
    if is_enabled then
      bar_btn_blue.text    = ""
      bar_btn_blue.visible = true
    else
      bar_btn_blue.visible = false
    end
  end)
end

awesome.connect_signal("signal::network", function(is_enabled)
  if is_enabled then
    bar_btn_net.text = "" or ""
  end
end)