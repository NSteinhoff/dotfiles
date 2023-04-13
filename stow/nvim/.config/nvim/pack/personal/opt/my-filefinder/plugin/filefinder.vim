command! -nargs=? -complete=file -bang FileFinder call filefinder#start(<q-args>, <bang>0)
cnoreabbrev <expr> ff  (getcmdtype() ==# ':' && getcmdline() ==# 'ff')  ? 'FileFinder'  : 'ff'

nnoremap <silent> <plug>(filefinder) <cmd>FileFinder!<cr>
