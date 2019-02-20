local wibox = require('wibox')
local mat_list_item = require('widget.mat-list-item')
local mat_slider = require('widget.mat-slider')
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
  [[bash -c "cat /proc/stat | grep '^cpu '"]],
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local user,
      nice,
      system,
      idle,
      iowait,
      irq,
      softirq,
      steal,
      guest,
      guest_nice = stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    slider:set_value(diff_usage)

    total_prev = total
    idle_prev = idle
    collectgarbage('collect')
  end
)

local cpu_meter =
  wibox.widget {
  wibox.widget {
    wibox.widget {
      image = icons.chart,
      widget = wibox.widget.imagebox
    },
    margins = dpi(12),
    widget = wibox.container.margin
  },
  slider,
  widget = mat_list_item
}

return cpu_meter
