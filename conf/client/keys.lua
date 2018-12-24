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
    )
)

return clientKeys
