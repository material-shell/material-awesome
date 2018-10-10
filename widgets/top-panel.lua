local awful = require('awful')
local beautiful = require('beautiful')
beautiful.init(require('theme'))
local wibox = require('wibox')
local TaskList = require('widgets.task-list')
local gears = require('gears')
local lain = require('lain')
local clickable_container = require('widgets.clickable-container')
local mat_icon_button = require('widgets.mat-icon-button')
local apps = require('conf.apps')

-- home_button
local searchIcon = wibox.widget.imagebox()
searchIcon.image = beautiful.home
local home_button =
    wibox.container.background(
    clickable_container(wibox.container.margin(searchIcon, 12, 12, 12, 12)),
    beautiful.primary
)
home_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            nil,
            function()
                awful.spawn(apps.rofi)
            end
        )
    )
)

-- home_button

local add_button = mat_icon_button(wibox.widget.imagebox(beautiful.add))
add_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            nil,
            function()
                awful.spawn(
                    awful.screen.focused().selected_tag.defaultApp,
                    {
                        tag = _G.mouse.screen.selected_tag,
                        placement = awful.placement.bottom_right
                    }
                )
            end
        )
    )
)
-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
    local layoutBox = clickable_container(awful.widget.layoutbox(s))
    layoutBox:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.layout.inc(-1)
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.layout.inc(-1)
                end
            )
        )
    )
    return layoutBox
end
local volume = beautiful.volume

local TopPanel = function(s)
    local panel =
        awful.wibar(
        {
            position = 'top',
            ontop = true,
            screen = s,
            height = 48,
            bg = beautiful.background,
            fg = beautiful.fg_normal
        }
    )

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            home_button,
            -- Create a taglist widget
            TaskList(s),
            add_button
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            volume.widget,
            -- Layout box
            LayoutBox(s)
        }
    }

    return panel
end

return TopPanel
