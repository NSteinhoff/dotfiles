command! -nargs=? -complete=file FileFinder execute
            \ (empty(getbufinfo('^FILES$')) ? 'edit FILES' : 'buffer ^FILES$')
            \| call setline(1, <q-args>) | 1 | doau TextChanged | call feedkeys('A')
cnoreabbrev <expr> ff  (getcmdtype() ==# ':' && getcmdline() ==# 'ff')  ? 'FileFinder'  : 'ff'

nnoremap <silent> <plug>(filefinder) <cmd>FileFinder<cr>
