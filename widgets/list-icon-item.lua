local wibox = require('wibox')
local naughty = require('naughty')
local debug = require('gears.debug')
local awful = require('awful')
local clickable_container = require('widgets.clickable-container')

function build(args)
  local args =
    args or
    {
      icon = nil,
      text = '',
      divider = false,
      callback = function()
      end
    }

  local divider
  if (args.divider) then
    divider =
      wibox.widget {
      orientation = 'horizontal',
      forced_height = 1,
      opacity = 0.12,
      widget = wibox.widget.separator
    }
  end

  local widget =
    wibox.widget {
    {
      {
        wibox.widget {
          image = args.icon,
          widget = wibox.widget.imagebox
        },
        left = 16,
        right = 32,
        top = 12,
        bottom = 12,
        layout = wibox.container.margin
      },
      wibox.widget {
        text = args.text,
        font = 'Roboto medium 13',
        widget = wibox.widget.textbox
      },
      layout = wibox.layout.align.horizontal
    },
    forced_height = args.divider and 47 or 48,
    widget = clickable_container
  }

  widget:connect_signal(
    'button::release',
    function()
      args.callback()
    end
  )

  return wibox.widget {
    layout = wibox.layout.fixed.vertical,
    divider,
    widget
  }
end

return build
