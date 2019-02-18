local mat_icon_button = require('widgets.mat-icon-button')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local dpi = require('beautiful').xresources.apply_dpi

local suspend_button = mat_icon_button(wibox.widget.imagebox(beautiful.icons .. 'snowflake.png'))
suspend_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('systemctl suspend')
      end
    )
  )
)
local restart_button = mat_icon_button(wibox.widget.imagebox(beautiful.icons .. 'restart.png'))
restart_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('systemctl reboot')
      end
    )
  )
)
local shutdown_button = mat_icon_button(wibox.widget.imagebox(beautiful.icons .. 'power.png'))
shutdown_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('systemctl poweroff')
      end
    )
  )
)
local shutdown_menu = {
  {
    layout = wibox.layout.fixed.vertical,
    {
      {
        markup = 'Exit options',
        align = 'left',
        valign = 'center',
        font = beautiful.title_font,
        widget = wibox.widget.textbox
      },
      bottom = dpi(8),
      widget = wibox.container.margin
    },
    {
      layout = wibox.layout.fixed.horizontal,
      forced_height = dpi(48),
      suspend_button,
      restart_button,
      shutdown_button
    }
  },
  top = dpi(16),
  left = dpi(16),
  right = dpi(16),
  bottom = dpi(16),
  widget = wibox.container.margin
}

return shutdown_menu
