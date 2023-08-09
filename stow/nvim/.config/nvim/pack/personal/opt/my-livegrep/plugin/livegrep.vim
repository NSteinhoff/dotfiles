command! -nargs=? -bang LiveGrep call livegrep#start(<q-args>, <bang>0)

cnoreabbrev <expr> lg (getcmdtype() ==# ':' && getcmdline() ==# 'lg') ? 'LiveGrep' : 'lg'

" Start live grepping
nnoremap <silent> <plug>(livegrep-new)       <cmd>LiveGrep!<cr>A
nnoremap <silent> <plug>(livegrep-resume)    <cmd>LiveGrep<cr>
vnoremap <silent> <plug>(livegrep-selection) y:let @/=escape(@", '\|')<bar>execute 'silent LiveGrep '..escape(@/, '\|')<cr>
