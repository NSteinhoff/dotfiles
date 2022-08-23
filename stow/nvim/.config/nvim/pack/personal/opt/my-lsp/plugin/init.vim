lua require('my_lsp')

aug my-lsp-set-diagnostics
    autocmd!
    autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false })
aug END
