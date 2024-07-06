nnoremap <plug>(preview) <cmd>call preview#preview_word('')<cr>
vnoremap <plug>(preview) "yy<cmd>call preview#preview_word(@y)<cr>
inoremap <plug>(preview) <cmd>call preview#preview_word(expand('<cword>'))<cr>
