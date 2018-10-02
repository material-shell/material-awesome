local awful = require('awful')
local lain = require('lain')
local beautiful = require('beautiful')
beautiful.init(require('theme'))
local wibox = require('wibox')
local TagList = require('widgets.tag-list')

local clockgf = beautiful.clockgf
local markup = lain.util.markup
-- Clock / Calendar
local textclock = wibox.widget.textclock(markup(clockgf, markup.font('Roboto bold 11', '%H:%M')))
local clock_widget = wibox.container.margin(textclock, 5, 5, 8, 8)
local systray = wibox.widget.systray()
systray:set_horizontal(false)
local LeftPanel = function(s)
    local panel =
        awful.wibar(
        {
            position = 'left',
            screen = s,
            width = 48,
            ontop = true,
            bg = beautiful.panel,
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
            -- Clock
            clock_widget
        }
    }

    return panel
end

return LeftPanel
