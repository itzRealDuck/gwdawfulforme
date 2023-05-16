-- Imports
----------
local awful        = require('awful')
local wibox        = require('wibox')
local beautiful    = require('beautiful')
local dpi          = beautiful.xresources.apply_dpi

local helpers      = require('helpers')
local gettasks     = require('ui.bar.modules.tasks')
-- Variables
------------
local Tray_icon    = beautiful.bar_size / 2
local Batt_length  = beautiful.bar_size * 1.25
local Side_padding = beautiful.is_bar_horizontal and beautiful.subt_font_size or beautiful.item_spacing
local Ends_padding = beautiful.is_bar_horizontal and beautiful.item_spacing or beautiful.subt_font_size

-- same thing no wibox.widget thing just straight to the bar


-- Awesome Bar
--------------

-- Bar Length
-------------
local bar_length = beautiful.is_bar_horizontal and dpi(100)
    or dpi(100)

-- you can change it to whatever you like like you can make it long

--The Bar
---------

screen.connect_signal("request::desktop_decoration", function(s)
    s.mywibox = awful.wibar {
        visible = beautiful.bar_enabled,
        position = beautiful.bar_side,
        screen = s,
        width = beautiful.is_bar_horizontal and dpi(bar_length) or dpi(beautiful.bar_size),
        height = beautiful.is_bar_horizontal and dpi(beautiful.bar_size) or dpi(bar_length),
        widget = {
            {
                {
                    gettasks(s),

                },
                layout = beautiful.align.direction
            },
            left = dpi(Side_padding),
            right = dpi(Side_padding),
            top = dpi(Side_padding),
            bottom = dpi(Side_padding),
            widget = wibox.container.margin
        }


    }
end)
