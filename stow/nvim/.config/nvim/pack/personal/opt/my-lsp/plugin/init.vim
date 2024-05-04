lua require('my_lsp')

call abbrev#cmdline('lsp', 'LspStart')
call abbrev#cmdline('lspstart', 'LspStart')
call abbrev#cmdline('lspstop', 'LspStop')

" aug my-lsp-set-diagnostics
"     autocmd!
"     autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({ open = false })
" aug END
