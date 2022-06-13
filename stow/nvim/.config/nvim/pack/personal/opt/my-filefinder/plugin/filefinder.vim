command! -nargs=? -complete=file FileFinder call filefinder#start(<q-args>)
cnoreabbrev <expr> ff  (getcmdtype() ==# ':' && getcmdline() ==# 'ff')  ? 'FileFinder'  : 'ff'

nnoremap <silent> <plug>(filefinder) <cmd>FileFinder<cr>
