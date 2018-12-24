local awful = require('awful')
local lain = require('lain')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TagList = require('widgets.tag-list')
local gears = require('gears')
local clockgf = beautiful.clockgf
local markup = lain.util.markup
-- Clock / Calendar
local textclock = wibox.widget.textclock(markup(clockgf, markup.font('Roboto Mono bold 11', '%H\n%M')))
local clock_widget = wibox.container.margin(textclock, 13, 13, 4, 0)
local systray = wibox.widget.systray()
systray:set_horizontal(false)

local system_button = require('widgets.power-menu')
--[[ local system_menu =
    radical.context {
    style = radical.style.classic,
    layout = radical.layout.horizontal,
    item_layout = radical.item.layout.icon,
    width = 144,
    auto_resize = false,
    icon_size = 24,
    item_height = 48,
    item_width = 48,
    default_item_margins = {
        left = 0,
        top = 12,
        right = 0,
        bottom = 12
    }
}

system_menu:add_item {
    icon = beautiful.icons .. 'snowflake.png',
    button1 = function()
        awful.spawn('systemctl suspend')
    end
}
system_menu:add_item {
    icon = beautiful.icons .. 'restart.png',
    button1 = function()
        awful.spawn('reboot')
    end
}
system_menu:add_item {
    icon = beautiful.icons .. 'power.png',
    button1 = function()
        awful.spawn('shutdown 0')
    end
} ]]
local LeftPanel = function(s)
    local panel =
        awful.wibar(
        {
            position = 'left',
            screen = s,
            width = 48,
            ontop = true,
            bg = beautiful.panel_bg,
            fg = beautiful.fg_normal
        }
    )

    panel:setup {
        layout = wibox.layout.align.vertical,
        {
            -- Left widgets
            layout = wibox.layout.fixed.vertical,
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
            clock_widget,
            system_button
        }
    }

    return panel
end

return LeftPanel
