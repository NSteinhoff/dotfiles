function s:start()
    lua require('my_lsp')
    LspStart
endfunction

command! Lsp call s:start()

call abbrev#cmdline('lsp', 'Lsp')
call abbrev#cmdline('lspstart', 'LspStart')
call abbrev#cmdline('lspstop', 'LspStop')

call timer_start(200, {-> execute("lua require('my_lsp')")})
