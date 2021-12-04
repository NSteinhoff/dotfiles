setlocal shiftwidth=4
if executable('stylua')
    let b:formatprg='stylua --config-path='..$HOME..'/.config/stylua/config.toml -'
endif
