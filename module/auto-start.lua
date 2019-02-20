local awful = require('awful')
local filesystem = require('gears.filesystem')

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

run_once({'blueberry-tray'}) -- Bluetooth tray icon
run_once({'xfce4-power-manager'}) -- Power manager
run_once({'compton --config ' .. filesystem.get_configuration_dir() .. '/conf/compton.conf'})
-- To allow gnome tools to ask authentication like pamac
run_once(
  {
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)'
  }
)
-- run_once({'pamac-tray'})
