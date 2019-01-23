local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widgets.clickable-container')

function build(imagebox, args)

    -- return wibox.container.margin(container, 6, 6, 6, 6)
    return wibox.widget {
        wibox.widget {
            wibox.widget {
              imagebox,
              top = 6,
              left = 6,
              right = 6,
              bottom = 6,
              widget = wibox.container.margin
            },
            shape = gears.shape.circle,
            widget = clickable_container
        },
        top = 6,
        left = 6,
        right = 6,
        bottom = 6,
        widget = wibox.container.margin
    }
end

return build
