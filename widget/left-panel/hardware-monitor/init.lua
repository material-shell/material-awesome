local wibox = require('wibox')
local mat_list_item = require('widget.mat-list-item')
local dpi = require('beautiful').xresources.apply_dpi

return wibox.widget {
  wibox.widget {
    wibox.widget {
      text = 'Hardware monitor',
      font = 'Roboto medium 12',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widget.left-panel.hardware-monitor.cpu-meter'),
  require('widget.left-panel.hardware-monitor.ram-meter'),
  require('widget.left-panel.hardware-monitor.temperature-meter'),
  require('widget.left-panel.hardware-monitor.harddrive-meter'),
  layout = wibox.layout.fixed.vertical
}
