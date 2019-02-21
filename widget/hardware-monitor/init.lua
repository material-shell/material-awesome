local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')

return wibox.widget {
  wibox.widget {
    wibox.widget {
      text = 'Hardware monitor',
      font = 'Roboto medium 12',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widget.hardware-monitor.cpu-meter'),
  require('widget.hardware-monitor.ram-meter'),
  require('widget.hardware-monitor.temperature-meter'),
  require('widget.hardware-monitor.harddrive-meter'),
  layout = wibox.layout.fixed.vertical
}
