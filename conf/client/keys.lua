local awful = require('awful')
require('awful.autofocus')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local lain = require('lain')

local modkey = require('conf.keys.mod').modKey
local altkey = require('conf.keys.mod').altKey

local clientKeys =
    awful.util.table.join(
    awful.key({altkey, 'Shift'}, 'm', lain.util.magnify_client, {description = 'magnify client', group = 'client'}),
    awful.key(
        {modkey},
        'f',
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = 'toggle fullscreen', group = 'client'}
    ),
    awful.key(
        {modkey},
        'q',
        function(c)
            c:kill()
        end,
        {description = 'close', group = 'client'}
    ),
    awful.key({altkey}, 'space', awful.client.floating.toggle, {description = 'toggle floating', group = 'client'}),
    awful.key(
        {modkey, 'Control'},
        'Return',
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = 'move to master', group = 'client'}
    ),
    awful.key(
        {modkey},
        'o',
        function(c)
            c:move_to_screen()
        end,
        {description = 'move to screen', group = 'client'}
    ),
    awful.key(
        {modkey},
        'y',
        function(c)
            c.ontop = not c.ontop
        end,
        {description = 'toggle keep on top', group = 'client'}
    )
)

return clientKeys
