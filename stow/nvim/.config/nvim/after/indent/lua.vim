setlocal shiftwidth=4
if executable('stylua')
    setlocal formatexpr=
    execute 'setlocal formatprg=stylua\ --config-path='..$HOME..'/.config/stylua/config.toml\ -'
endif
