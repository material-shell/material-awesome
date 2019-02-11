local spawn = require('awful.spawn')
local terminal = require('conf.apps').terminal

local shell_id
local shell_client
local opened = false
function create_shell()
  shell_id =
    spawn(
    terminal,
    {
      skip_decoration = true,
      anal = 'oto'
    }
  )
end

function open_quake()
  shell_client.hidden = false
end

function close_quake()
  shell_client.hidden = true
end

toggle_quake = function()
  opened = not opened
  if not shell_client then
    create_shell()
  else
    if opened then
      open_quake()
    else
      close_quake()
    end
  end
end

_G.client.connect_signal(
  'manage',
  function(c)
    log_this(tostring(c.anal))
    if (c.pid == shell_id) then
      shell_client = c
      c.opacity = 0.9
      c.floating = true
      c.skip_taskbar = true
      c.ontop = true
      c.sticky = true
      c.hidden = not opened
      c.skip_decoration = true
    end
  end
)
_G.client.connect_signal(
  'unmanage',
  function(c)
    if (c.pid == shell_id) then
      opened = false
      shell_client = null
    end
  end
)
create_shell()
