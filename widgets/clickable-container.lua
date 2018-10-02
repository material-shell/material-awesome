local wibox = require('wibox')
local naughty = require('naughty')
local debug = require('gears.debug')
local awful = require('awful')

function build(widget)
    local container = wibox.container.background(widget)

    container:connect_signal(
        'mouse::enter',
        function()
            container.bg = '#ffffff11'
        end
    )

    container:connect_signal(
        'mouse::leave',
        function()
            container.bg = '#ffffff00'
        end
    )

    container:connect_signal(
        'button::press',
        function()
            container.bg = '#ffffff22'
        end
    )

    container:connect_signal(
        'button::release',
        function()
            container.bg = '#ffffff11'
        end
    )

    return container
end

return build
