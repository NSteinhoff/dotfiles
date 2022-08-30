packadd nvim-treesitter
packadd nvim-treesitter-textobjects
packadd nvim-treesitter-refactor
packadd nvim-treesitter-commentstring
packadd nvim-treesitter-rainbow

lua require('my_treesitter')

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
