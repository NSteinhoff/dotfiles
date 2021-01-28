command! -nargs=? FileFinder edit FILES | call setline(1, <q-args>) | doau TextChanged

nnoremap <silent> <Plug>(filefinder-new) <CMD>FileFinder<CR>i
