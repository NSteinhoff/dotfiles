lua require('my_treesitter')

" augroup treesitter-folding
"     autocmd!
"     autocmd filetype javascript*,typescript*,rust,python,bash,scala,c,cpp,lua,html,json setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
" augroup END
