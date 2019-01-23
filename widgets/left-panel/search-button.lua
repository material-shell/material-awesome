local beautiful = require('beautiful')
local wibox = require('wibox')
local clickable_container = require('widgets.clickable-container')

local searchPlaceholder =
  wibox.widget {
  {
    {
      {
        text = 'Search Applications',
        font = ' Roboto medium 13',
        widget = wibox.widget.textbox
      },
      left = 12,
      right = 12,
      top = 12,
      bottom = 12,
      widget = wibox.container.margin
    },
    widget = clickable_container
  },
  bg = beautiful.background,
  fg = '#dddddddd',
  widget = wibox.container.background
}

return searchPlaceholder
