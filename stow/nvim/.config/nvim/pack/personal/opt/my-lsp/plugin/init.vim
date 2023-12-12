lua require('my_lsp')

call abbrev#cmdline('lsp', 'LspStart')

" aug my-lsp-set-diagnostics
"     autocmd!
"     autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({ open = false })
" aug END
