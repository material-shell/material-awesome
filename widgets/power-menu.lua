local mat_icon_button = require('widgets.mat-icon-button')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')

local system_button = mat_icon_button(wibox.widget.imagebox(beautiful.icons .. 'settings.png'))

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
local shutdown_menu =
  wibox(
  {
    screen = 'primary', -- Only display on primary screen
    width = 182,
    height = 114,
    ontop = true,
    bg = beautiful.panel_bg,
    visible = false,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(16))
    end
  }
)

shutdown_menu:setup {
  {
    {
      {
        markup = 'Power menu',
        align = 'left',
        valign = 'center',
        font = beautiful.title_font,
        widget = wibox.widget.textbox
      },
      bottom = 8,
      widget = wibox.container.margin
    },
    {
      layout = wibox.layout.fixed.horizontal,
      suspend_button,
      restart_button,
      shutdown_button
    },
    layout = wibox.layout.fixed.vertical
  },
  top = dpi(16),
  left = dpi(16),
  right = dpi(16),
  bottom = dpi(16),
  widget = wibox.container.margin
}
local backdrop = wibox {ontop = true, bg = '#00000000', type = 'splash'}

backdrop:buttons(
  awful.util.table.join(
    awful.button(
      {},
      1,
      function()
        shutdown_menu.visible = false
        backdrop.visible = false
      end
    )
  )
)
system_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.placement.bottom_left(
          shutdown_menu,
          {
            honor_workarea = true,
            margins = {
              left = 8,
              bottom = 8
            }
          }
        )
        awful.placement.maximize(
          backdrop,
          {
            parent = shutdown_menu.screen
          }
        )
        backdrop.visible = true
        shutdown_menu.visible = true
      end
    )
  )
)

return system_button
