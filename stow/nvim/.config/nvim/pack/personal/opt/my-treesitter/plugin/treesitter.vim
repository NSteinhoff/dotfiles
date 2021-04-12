lua require('my_treesitter')

augroup treesitter-folding
    autocmd!
    autocmd filetype javascript*,typescript* setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype rust setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype python setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype bash setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype scala setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype c,cpp setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype lua setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype html setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd filetype json setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
augroup END
