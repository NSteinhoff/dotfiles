lua require('my_lsp')

" LSP status updates in bottom right corner
packadd fidget.nvim
lua require"fidget".setup{}

aug my-lsp-set-diagnostics
    autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false })
aug END
