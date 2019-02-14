local filesystem = require('gears.filesystem')

return {
  terminal = 'alacritty',
  editor = 'code',
  rofi = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/conf/rofi.rasi',
  lock = 'i3lock-fancy-rapid 5 3 -k --timecolor=ffffffff --datecolor=ffffffff',
  quake = 'alacritty --title QuakeTerminal'
}
