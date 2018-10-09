local awful = require('awful')
local beautiful = require('beautiful')
local conf = require('conf')
local freedesktop = require('freedesktop')

-- Layouts
awful.util.terminal = conf.apps.terminal
-- Menu
local myawesomemenu = {
    {
        'hotkeys',
        function()
            return false, hotkeys_popup.show_help
        end
    },
    {'manual', conf.apps.terminal .. ' -e man awesome'},
    {'edit config', string.format('%s -e %s %s', conf.apps.terminal, conf.apps.editor, _G.awesome.conffile)},
    {'restart', _G.awesome.restart},
    {
        'quit',
        function()
            _G.awesome.quit()
        end
    }
}
awful.util.mymainmenu =
    freedesktop.menu.build(
    {
        icon_size = beautiful.menu_height or 16,
        before = {
            {'Awesome', myawesomemenu, beautiful.awesome_icon}
            -- other triads can be put here
        },
        after = {
            {'Open terminal', conf.apps.terminal}
            -- other triads can be put here
        }
    }
)

-- Mouse bindings
_G.root.buttons(
    awful.util.table.join(
        awful.button(
            {},
            3,
            function()
                awful.util.mymainmenu:toggle()
            end
        )
    )
)
