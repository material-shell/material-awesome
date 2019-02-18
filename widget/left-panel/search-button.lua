local beautiful = require('beautiful')
local wibox = require('wibox')
local clickable_container = require('widgets.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local searchPlaceholder =
  wibox.widget {
  {
    {
      {
        text = 'Search Applications',
        font = ' Roboto medium 13',
        widget = wibox.widget.textbox
      },
      left = dpi(12),
      right = dpi(12),
      top = dpi(12),
      bottom = dpi(12),
      widget = wibox.container.margin
    },
    widget = clickable_container
  },
  bg = beautiful.background,
  fg = '#dddddddd',
  widget = wibox.container.background
}

return searchPlaceholder
