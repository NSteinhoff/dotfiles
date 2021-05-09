packadd numb.nvim

command! NumbEnable lua require('numb').setup()
command! NumbDisable lua require('numb').disable()

NumbEnable
