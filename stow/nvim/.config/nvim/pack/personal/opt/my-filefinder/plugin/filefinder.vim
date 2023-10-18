command! -nargs=? -complete=file -bang FileFinder call filefinder#start(<q-args>, <bang>0)
call abbrev#cmdline('ff', 'FileFinder')

nnoremap <silent> <plug>(filefinder) <cmd>FileFinder!<cr>
