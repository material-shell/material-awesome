local wibox = require('wibox')
local mat_list_item = require('widgets.mat-list-item')
local mat_slider = require('widgets.mat-slider')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')

local slider =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

watch(
  [[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]],
  10,
  function(widget, stdout, stderr, exitreason, exitcode)
    local space_consumed = stdout:match('(%d+)')
    slider:set_value(tonumber(space_consumed))
    collectgarbage('collect')
  end
)

local harddrive_meter =
  wibox.widget {
  wibox.widget {
    wibox.widget {
      image = icons.harddisk,
      widget = wibox.widget.imagebox
    },
    margins = 12,
    widget = wibox.container.margin
  },
  slider,
  widget = mat_list_item
}

return harddrive_meter
