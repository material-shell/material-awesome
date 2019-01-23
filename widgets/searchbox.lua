--[[ local wibox = require('wibox')
local gtable = require('gears.table')
local keygrabber = require('awful.keygrabber')
local gstring = require('gears.string')
local gcolor = require('gears.color')

local setmetatable = setmetatable
local searchbox = {mt = {}}

local function prompt_text_with_cursor(args)
  local char, spacer, text_start, text_end, ret
  local text = args.text or ''
  local _prompt = args.prompt or ''
  local underline = args.cursor_ul or 'none'

  if args.selectall then
    if #text == 0 then
      char = ' '
    else
      char = gstring.xml_escape(text)
    end
    spacer = ' '
    text_start = ''
    text_end = ''
  elseif #text < args.cursor_pos then
    char = ' '
    spacer = ''
    text_start = gstring.xml_escape(text)
    text_end = ''
  else
    char = gstring.xml_escape(text:sub(args.cursor_pos, args.cursor_pos))
    spacer = ' '
    text_start = gstring.xml_escape(text:sub(1, args.cursor_pos - 1))
    text_end = gstring.xml_escape(text:sub(args.cursor_pos + 1))
  end

  local cursor_color = gcolor.ensure_pango_color(args.cursor_color)
  local text_color = gcolor.ensure_pango_color(args.text_color)

  if args.highlighter then
    text_start, text_end = args.highlighter(text_start, text_end)
  end

  ret =
    _prompt ..
    text_start ..
      '<span background="' ..
        cursor_color ..
          '" foreground="' ..
            text_color .. '" underline="' .. underline .. '">' .. char .. '</span>' .. text_end .. spacer
  return ret
end

local grabber
local cur_pos = 1
function searchbox:focus()
  self.searchText = ''
  grabber =
    keygrabber.run(
    function(mod, key, event)
      if (event == 'press') then
        if key == 'Escape' then
          searchbox:unfocus()
          return
        elseif key == 'Left' then
          cur_pos = cur_pos - 1
        elseif key == 'Right' then
          cur_pos = cur_pos + 1
        elseif key == 'BackSpace' then
          if cur_pos > 1 then
            self.searchText = self.searchText:sub(1, cur_pos - 2) .. self.searchText:sub(cur_pos)
            cur_pos = cur_pos - 1
          end
        elseif key:wlen() == 1 then
          self.searchText = self.searchText:sub(1, cur_pos - 1) .. key .. self.searchText:sub(cur_pos)
          cur_pos = cur_pos + #key
        end
        self.textbox.markup =
          prompt_text_with_cursor {
          text = self.searchText,
          cursor_pos = cur_pos,
          selectall = false
        }
        self:emit_signal('property::searchText')
      end
    end
  )
end

function searchbox:unfocus()
  keygrabber.stop(grabber)
end
--- Create a new searchbox.
-- @function searchbox
local function new(text, ignore_markup)
  local ret = wibox.container.background()
  gtable.crush(ret, searchbox, true)

  ret.textbox = wibox.widget.textbox()

  ret.widget = ret.textbox
  ret.searchText = ''
  return ret
end

function searchbox.mt.__call(_, ...)
  return new(...)
end

return setmetatable(searchbox, searchbox.mt)
 ]]
