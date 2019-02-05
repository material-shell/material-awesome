local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')
local keygrabber = require('awful.keygrabber')
local icons = require('theme.icons')
local clickable_container = require('widgets.clickable-container')

-- Appearance
local icon_size = beautiful.exit_screen_icon_size or 140

local buildButton =
  function(icon, tooltipText)
  local abutton =
    wibox.widget {
    wibox.widget {
      wibox.widget {
        wibox.widget {
          image = icon,
          widget = wibox.widget.imagebox
        },
        top = 16,
        bottom = 16,
        left = 16,
        right = 16,
        widget = wibox.container.margin
      },
      shape = gears.shape.circle,
      forced_width = icon_size,
      forced_height = icon_size,
      widget = clickable_container
    },
    left = 24,
    right = 24,
    widget = wibox.container.margin
  }

  return abutton
end

local poweroff = buildButton(icons.power, 'Shutdown')
poweroff:connect_signal(
  'button::release',
  function()
    awful.spawn.with_shell('poweroff')
    awful.keygrabber.stop(exit_screen_grabber)
  end
)

local reboot = buildButton(icons.restart, 'Restart')
reboot:connect_signal(
  'button::release',
  function()
    awful.spawn.with_shell('reboot')
    awful.keygrabber.stop(exit_screen_grabber)
  end
)

local suspend = buildButton(icons.sleep, 'Sleep')
suspend:connect_signal(
  'button::release',
  function()
    awful.spawn.with_shell('i3lock & systemctl suspend')
    exit_screen_hide()
  end
)

local exit = buildButton(icons.logout, 'Logout')
exit:connect_signal(
  'button::release',
  function()
    awesome.quit()
  end
)

local lock = buildButton(icons.lock, 'Lock')
lock:connect_signal(
  'button::release',
  function()
    awful.spawn.with_shell('i3lock-fancy-rapid 5 3 -k --timecolor=ffffffff --datecolor=ffffffff')
    exit_screen_hide()
  end
)

-- Get screen geometry
local screen_geometry = awful.screen.focused().geometry

-- Create the widget
exit_screen =
  wibox(
  {
    x = screen_geometry.x,
    y = screen_geometry.y,
    visible = false,
    ontop = true,
    type = 'splash',
    height = screen_geometry.height,
    width = screen_geometry.width
  }
)

exit_screen.bg = beautiful.background.hue_800 .. 'dd'
exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or '#FEFEFE'

local exit_screen_grabber

function exit_screen_hide()
  awful.keygrabber.stop(exit_screen_grabber)
  exit_screen.visible = false
end

function exit_screen_show()
  -- naughty.notify({text = "starting the keygrabber"})
  exit_screen_grabber =
    awful.keygrabber.run(
    function(_, key, event)
      if event == 'release' then
        return
      end

      if key == 's' then
        suspend_command()
      elseif key == 'e' then
        exit_command()
      elseif key == 'l' then
        lock_command()
      elseif key == 'p' then
        poweroff_command()
      elseif key == 'r' then
        reboot_command()
      elseif key == 'Escape' or key == 'q' or key == 'x' then
        -- naughty.notify({text = "Cancel"})
        exit_screen_hide()
      -- else awful.keygrabber.stop(exit_screen_grabber)
      end
    end
  )
  exit_screen.visible = true
end

exit_screen:buttons(
  gears.table.join(
    -- Middle click - Hide exit_screen
    awful.button(
      {},
      2,
      function()
        exit_screen_hide()
      end
    ),
    -- Right click - Hide exit_screen
    awful.button(
      {},
      3,
      function()
        exit_screen_hide()
      end
    )
  )
)

-- Item placement
exit_screen:setup {
  nil,
  {
    nil,
    {
      -- {
      poweroff,
      reboot,
      suspend,
      exit,
      lock,
      layout = wibox.layout.fixed.horizontal
      -- },
      -- widget = exit_screen_box
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.horizontal
  },
  nil,
  expand = 'none',
  layout = wibox.layout.align.vertical
}
