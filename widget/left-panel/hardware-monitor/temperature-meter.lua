local wibox = require('wibox')
local mat_list_item = require('widget.mat-list-item')
local mat_slider = require('widget.mat-slider')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi

local slider =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

local max_temp = 80
watch(
  'bash -c "cat /sys/class/thermal/thermal_zone0/temp"',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local temp = stdout:match('(%d+)')
    slider:set_value((temp / 1000) / max_temp * 100)
    collectgarbage('collect')
  end
)

local temperature_meter =
  wibox.widget {
  wibox.widget {
    wibox.widget {
      image = icons.thermometer,
      widget = wibox.widget.imagebox
    },
    margins = dpi(12),
    widget = wibox.container.margin
  },
  slider,
  widget = mat_list_item
}

return temperature_meter
