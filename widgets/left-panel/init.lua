local awful = require('awful')
local lain = require('lain')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TagList = require('widgets.tag-list')
local gears = require('gears')
local apps = require('conf.apps')
local list_icon_item = require('widgets.list-icon-item')
local clockgf = beautiful.clockgf
local markup = lain.util.markup
-- Clock / Calendar
local textclock = wibox.widget.textclock(markup(clockgf, markup.font('Roboto Mono bold 11', '%H\n%M')))
local clock_widget = wibox.container.margin(textclock, 13, 13, 8, 8)
local systray = wibox.widget.systray()
systray:set_horizontal(false)
local clickable_container = require('widgets.clickable-container')
local mat_slider = require('widgets.mat-slider')
local icons = require('theme.icons')
local system_button = require('widgets.power-menu')

local menu_icon =
  wibox.widget {
  image = icons.menu,
  widget = wibox.widget.imagebox
}

home_button =
  wibox.widget {
  wibox.widget {
    wibox.widget {
      menu_icon,
      top = 12,
      left = 12,
      right = 12,
      bottom = 12,
      widget = wibox.container.margin
    },
    widget = clickable_container
  },
  bg = beautiful.primary,
  widget = wibox.container.background
}
local searchPlaceholder = require('widgets.left-panel.search-button')

searchPlaceholder:buttons(
  awful.util.table.join(
    awful.button(
      {},
      1,
      function()
        awful.spawn(apps.rofi)
      end
    )
  )
)
local mat_list_item = require('widgets.mat-list-item')

local LeftPanel = function(s)
  local panelOpened = false
  local panel =
    wibox {
    screen = s,
    width = 448,
    height = s.geometry.height,
    x = 48 - 448,
    y = 0,
    ontop = true,
    bg = beautiful.panel_bg,
    fg = beautiful.fg_normal
  }

  panel:struts(
    {
      left = 48
    }
  )

  local backdrop =
    wibox {
    ontop = true,
    screen = s,
    bg = '#00000000',
    type = 'dock',
    x = 0,
    y = 0,
    width = s.geometry.width,
    height = s.geometry.height
  }

  local openPanel = function()
    panel.x = 0
    menu_icon.image = icons.close
    backdrop.visible = true
    panel.visible = false
    panel.visible = true
  end

  local closePanel = function()
    menu_icon.image = icons.menu
    panel.x = 48 - 448
    backdrop.visible = false
  end

  local togglePanel = function()
    panelOpened = not panelOpened
    if (panelOpened) then
      openPanel()
    else
      closePanel()
    end
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          togglePanel()
        end
      )
    )
  )

  home_button:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          togglePanel()
          --awful.spawn(apps.rofi)
        end
      )
    )
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    {
      {
        layout = wibox.layout.align.vertical,
        {
          layout = wibox.layout.fixed.vertical,
          {
            list_icon_item(
              {
                icon = icons.search,
                text = 'Search Applications',
                callback = function()
                  awful.spawn(apps.rofi)
                end
              }
            ),
            bg = beautiful.background,
            widget = wibox.container.background
          },
          wibox.widget {
            orientation = 'horizontal',
            forced_height = 1,
            opacity = 0.08,
            widget = wibox.widget.separator
          },
          require('widgets.left-panel.quick-settings'),
          require('widgets.left-panel.hardware-monitor')
        },
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          {
            list_icon_item(
              {
                icon = icons.logout,
                text = 'End work session',
                divider = true,
                callback = function()
                  togglePanel()
                  exit_screen_show()
                end
              }
            ),
            bg = '#081b20',
            widget = wibox.container.background
          }
        }
      },
      bg = '#121e25',
      widget = wibox.container.background
    },
    {
      layout = wibox.layout.align.vertical,
      forced_width = 48,
      {
        -- Left widgets
        layout = wibox.layout.fixed.vertical,
        home_button,
        -- Create a taglist widget
        TagList(s)
      },
      --s.mytasklist, -- Middle widget
      nil,
      {
        -- Right widgets
        layout = wibox.layout.fixed.vertical,
        wibox.container.margin(systray, 10, 10),
        require('widgets.package-updater'),
        require('widgets.wifi'),
        require('widgets.battery'),
        -- Clock
        clock_widget
      }
    }
  }

  return panel
end

return LeftPanel
