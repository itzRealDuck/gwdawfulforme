local appbar = require('ui.bar.allthebarss.modules.applauncherbar')

local awful = require('awful')

awful.screen.connect_for_each_screen(function(s)
  appbar(s)
end)
