local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widgets.clickable-container')

function build(icon, args)
    local icon = wibox.widget.imagebox(icon)
    local container = clickable_container()

    container:set_widget(wibox.container.margin(icon, 6, 6, 6, 6))

    local shape = function(cr, l, r)
        return gears.circle(cr, 48, 48)
    end
    container.shape = gears.shape.circle

    return wibox.container.margin(container, 6, 6, 6, 6)
end

return build
