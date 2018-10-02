local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
local beautiful = require('beautiful')
local naughty = require('naughty')
local lain = require('lain')
local freedesktop = require('freedesktop')
local hotkeys_popup = require('awful.hotkeys_popup').widget

local LeftPanel = require('widgets.left-panel')
local TopPanel = require('widgets.top-panel')

local conf = require('conf')

local setTags = require('conf.tags')

-- Error handling
if _G.awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = 'Oops, there were errors during startup!',
            text = _G.awesome.startup_errors
        }
    )
end

do
    local in_error = false
    _G.awesome.connect_signal(
        'debug::error',
        function(err)
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = 'Oops, an error happened!',
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

-- Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = 'Roboto 10'
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 32
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil

-- Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        local findme = cmd
        local firstspace = cmd:find(' ')
        if firstspace then
            findme = cmd:sub(0, firstspace - 1)
        end
        awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd))
    end
end

-- entries must be comma-separated
run_once({'wmname LG3D'}) -- Fix java problem
run_once({'nm-applet'}) -- Network manager tray icon
run_once({'pa-applet'}) -- Sound manager tray icon
run_once({'xfce4-power-manager'}) -- Sound manager tray icon
run_once({'compton'})
-- To allow gnome tools to ask authentication like pamac
run_once(
    {
        '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)'
    }
)
run_once({'pamac-tray'})
-- Variable definitions

local modkey = conf.keys.mod.modKey

-- Theme
beautiful.init(require('theme'))

-- Layouts
awful.util.terminal = conf.apps.terminal
awful.layout.layouts = {
    awful.layout.suit.tile,
    --awful.layout.suit.floating,
    awful.layout.suit.max
    --lain.layout.centerwork,
    --[[ awful.layout.suit.spiral,
    awful.layout.suit.magnifier,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    lain.layout.cascade,
    lain.layout.cascade.tile,
    lain.layout.centerwork.horizontal,
    lain.layout.termfair.center ]]
}

awful.util.taglist_buttons =
    awful.util.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if _G.client.focus then
                _G.client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if _G.client.focus then
                _G.client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

local function connect(s)
    s.quake = lain.util.quake({app = awful.util.terminal})

    -- If wallpaper is a function, call it with the screen

    gears.wallpaper.set(beautiful.wallpaper, 1, true)

    -- Tags
    setTags(s)

    -- Create the Top bar
    s.topPanel = TopPanel(s)
    if s.index == 1 then
        -- Create the leftPanel
        s.leftPanel = LeftPanel(s)
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
    function(s)
        connect(s)
    end
)

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

local clientbuttons =
    awful.util.table.join(
    awful.button(
        {},
        1,
        function(c)
            _G.client.focus = c
            c:raise()
        end
    ),
    awful.button({modkey}, 1, awful.mouse.client.move),
    awful.button({modkey}, 3, awful.mouse.client.resize),
    awful.button(
        {modkey},
        4,
        function()
            awful.layout.inc(1)
        end
    ),
    awful.button(
        {modkey},
        5,
        function()
            awful.layout.inc(-1)
        end
    )
)

_G.root.keys(conf.keys.global)

-- Rules

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = conf.keys.client,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },
    -- Titlebars
    {
        rule_any = {type = {'dialog', 'normal'}},
        properties = {titlebars_enabled = true}
    },
    {
        rule = {class = 'Gimp', role = 'gimp-image-window'},
        properties = {maximized = true}
    }
}
-- }}}

function renderClient(client)
    local t = client.first_tag
    local layout = awful.tag.getproperty(t, 'layout')
    local only_child = t:clients()[2] == nil
    print(only_child)
    print(layout)
    if layout == awful.layout.suit.max or only_child then
        print('a')
        client.border_width = 0
        client.shape = gears.shape.rect
    else
        print('b')
        client.border_width = beautiful.border_width
        client.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 6)
        end
    end
end

function refreshClientsOnTags()
    local tags = awful.screen.focused().selected_tags
    for i1, tag in pairs(tags) do
        for i2, client in pairs(tag:clients()) do
            renderClient(client)
        end
    end
end

tag.connect_signal(
    'property::layout',
    function(t)
        local currentLayout = awful.tag.getproperty(t, 'layout')
        if (currentLayout == awful.layout.suit.max) then
            t.gap = 0
        else
            t.gap = 8
        end
        refreshClientsOnTags()
    end
)

-- {{{ Signals
-- Signal function to execute when a new client appears.
_G.client.connect_signal(
    'manage',
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.

        refreshClientsOnTags()

        if not _G.awesome.startup then
            awful.client.setslave(c)
        end

        if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
        c.maximized = false
        -- c.floated = false
    end
)

_G.client.connect_signal(
    'unmanage',
    function(c)
        refreshClientsOnTags()
    end
)

-- Enable sloppy focus, so that focus follows mouse.
_G.client.connect_signal(
    'mouse::enter',
    function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
            _G.client.focus = c
        end
    end
)

-- Hide bars when app go fullscreen
_G.client.connect_signal(
    'property::fullscreen',
    function(c)
        local screen = awful.screen.focused()
        -- Order matter here for shadow
        awful.screen.focused().topPanel.visible = not c.fullscreen
        if screen.leftPanel then
            screen.leftPanel.visible = not c.fullscreen
        end
    end
)

-- No border for maximized clients
_G.client.connect_signal(
    'focus',
    function(c)
        c.border_color = beautiful.border_focus
    end
)
_G.client.connect_signal(
    'unfocus',
    function(c)
        c.border_color = beautiful.border_normal
    end
)
