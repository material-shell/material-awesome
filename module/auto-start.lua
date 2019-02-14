local awful = require('awful')
local filesystem = require('gears.filesystem')

awful.spawn.single_instance({'blueberry-tray'}) -- Bluetooth tray icon
awful.spawn.single_instance({'xfce4-power-manager'}) -- Power manager
awful.spawn.single_instance('compton --config ' .. filesystem.get_configuration_dir() .. '/conf/compton.conf')
-- To allow gnome tools to ask authentication like pamac
awful.spawn.single_instance(
  {
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)'
  }
)
-- run_once({'pamac-tray'})
