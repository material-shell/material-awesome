local awful = require('awful')
local iconPath = os.getenv('HOME') .. '/.config/awesome/theme/icons/tag-list/tag/'
local gears = require('gears')
local tags = {
    {
        icon = 'google-chrome.png',
        type = 'chrome',
        defaultApp = 'google-chrome-beta',
        screen = 1
    },
    {
        icon = 'code-braces.png',
        type = 'code',
        defaultApp = 'code',
        screen = 1
    },
    {
        icon = 'forum.png',
        type = 'social',
        defaultApp = 'station',
        screen = 1
    },
    {
        icon = 'folder.png',
        type = 'files',
        defaultApp = 'nautilus',
        screen = 1
    },
    {
        icon = 'music.png',
        type = 'music',
        defaultApp = 'youtube-music',
        screen = 1
    },
    {
        icon = 'flask.png',
        type = 'any',
        defaultApp = '',
        screen = 1
    }
}

local setTags = function(s)
    for i, tag in pairs(tags) do
        awful.tag.add(
            i,
            {
                icon = iconPath .. tag.icon,
                icon_only = true,
                layout = awful.layout.suit.tile,
                gap_single_client = false,
                gap = 8,
                screen = s,
                defaultApp = tag.defaultApp,
                selected = i == 1
            }
        )
    end
end

return setTags
