local awful = require('awful')
local filesystem = require('gears.filesystem')
local gtable = require('gears.table')
local gtimer = require("gears.timer")
local GLib = require('lgi').GLib

local single_instance_manager = {
  by_snid = {},
  by_pid  = {},
  by_uid  = {},
}

local function hash_command(cmd, rules)
    rules = rules or {}
    cmd = type(cmd) == "string" and cmd or table.concat(cmd, ';')

    -- Do its best at adding some entropy
    local concat_rules = nil
    concat_rules = function (r, depth)
        if depth > 2 then return end

        local keys = gtable.keys(rules)

        for _, k in ipairs(keys) do
            local v = r[k]
            local t = type(v)

            if t == "string" or t == "number" then
                cmd = cmd..k..v
            elseif t == "tag" then
                cmd = cmd..k..v.name
            elseif t == "table" and not t.connect_signal then
                cmd = cmd .. k
                concat_rules(v, depth + 1)
            end
        end
    end

    concat_rules(rules, 1)

    local glibstr = GLib.String(cmd)

    return string.format('%x', math.ceil(GLib.String.hash(glibstr)))
end

local function register_common(hash, rules, matcher, callback)
    local status = single_instance_manager.by_uid[hash]
    if status then return status end

    status = {
        rules     = rules,
        callback  = callback,
        instances = setmetatable({}, {__mode = "v"}),
        hash      = hash,
        exec      = false,
        matcher   = matcher,
    }

    single_instance_manager.by_uid[hash] = status

    return status
end

local function run_after_startup(f)
    -- The clients are not yet managed during the first execution, so it will
    -- miss existing instances.
    if awesome.startup then
        gtimer.delayed_call(f)
    else
        f()
    end
end

local function is_running(hash, matcher)
    local status = single_instance_manager.by_uid[hash]
    if not status then return false end

    if #status.instances == 0 then return false end

    for _, c in ipairs(status.instances) do
        if c.valid then return true end
    end

    if matcher then
        for _, c in ipairs(client.get()) do
            if matcher(c) then return true end
        end
    end

    return false
end

local function run_once_common(hash, cmd, keep_pid)
    local pid, snid = awful.spawn.spawn(cmd)

    if type(pid) == "string" or not snid then return pid, snid end

    assert(single_instance_manager.by_uid[hash])

    local status = single_instance_manager.by_uid[hash]
    status.exec = true

    single_instance_manager.by_snid[snid] = status

    if keep_pid then
        single_instance_manager.by_pid[pid] = status
    end

    -- Prevent issues related to PID being re-used and a memory leak
    gtimer {
        single_shot = true,
        autostart   = true,
        timeout     = 30,
        callback    = function()
            single_instance_manager.by_pid [pid ] = nil
            single_instance_manager.by_snid[snid] = nil
        end
    }

    return pid, snid
end

function single_instance(cmd, rules, matcher, unique_id, callback)
  local hash = unique_id or hash_command(cmd, rules)
  register_common(hash, rules, matcher, callback)
  run_after_startup(function()
      if not is_running(hash, matcher) then
          return run_once_common(hash, cmd, matcher ~= nil)
      end
  end)
end



single_instance({'blueberry-tray'}) -- Bluetooth tray icon
single_instance({'xfce4-power-manager'}) -- Power manager
single_instance({'compton -b --config ' .. filesystem.get_configuration_dir() .. '/conf/compton.conf'})
-- To allow gnome tools to ask authentication like pamac
single_instance(
  {
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)'
  }
)
-- run_once({'pamac-tray'})
