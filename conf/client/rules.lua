local awful = require('awful')
local beautiful = require('beautiful')

local client_keys = require('conf.client.keys')
local client_buttons = require('conf.client.buttons')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = 0,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      maximized = false,
      maximized_horizontal = false,
      maximized_vertical = false,
      sticky = false,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
      size_hints_honor = false,
      fullscreen = false
    }
  },
  -- Titlebars
  {
    rule_any = {type = {'dialog'}, class = {'Wicd-client.py', 'calendar.google.com'}},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true
    }
  },
  {
    rule = {class = 'Peek'},
    properties = {fullscreen = true, sticky = true, ontop = true, floating = true}
  }
}
