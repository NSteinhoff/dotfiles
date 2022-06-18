function editsettings#complete_plugins(arglead, cmdline, cursorpos)
    let plugins = glob('$HOME/.config/nvim/after/plugin/*', 0, 1)
    let plugins = map(plugins, { _, v -> fnamemodify(v, ':t:r') })
    let plugins = filter(plugins, { _, v -> v =~ a:arglead })
    return plugins
endfunction
