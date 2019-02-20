local wibox = require('wibox')
local mat_list_item = require('widget.mat-list-item')
local mat_slider = require('widget.mat-slider')
local mat_icon = require('widget.mat-icon')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi

local total_prev = 0
local idle_prev = 0

local slider =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

watch(
  'bash -c "free | grep -z Mem.*Swap.*"',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
      stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')
    slider:set_value(used / total * 100)
    collectgarbage('collect')
  end
)

local ram_meter =
  wibox.widget {
  wibox.widget {
    icon = icons.memory,
    size = dpi(24),
    widget = mat_icon
  },
  slider,
  widget = mat_list_item
}

return ram_meter
