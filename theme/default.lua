local filesystem = require('gears.filesystem')
local mat_colors = require('theme.mat-colors')
local theme_dir = filesystem.get_configuration_dir() .. '/theme'

local default = {}
default.icons = theme_dir .. '/icons/'
default.font = 'Roboto medium 10'
default.wallpaper = mat_colors.grey_300

default.primary = mat_colors.indigo_500

--Client
default.border_width = 2
default.border_focus = default.primary
default.border_normal = mat_colors.grey_800

--Panels
default.panel_bg = mat_colors.grey_800

return default
