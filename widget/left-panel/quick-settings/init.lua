local wibox = require('wibox')
local mat_list_item = require('widget.mat-list-item')
local dpi = require('beautiful').xresources.apply_dpi

return wibox.widget {
  wibox.widget {
    wibox.widget {
      text = 'Quick settings',
      font = 'Roboto medium 12',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widget.left-panel.quick-settings.volume-setting'),
  require('widget.left-panel.quick-settings.brightness-setting'),
  layout = wibox.layout.fixed.vertical
}
