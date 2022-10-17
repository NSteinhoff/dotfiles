command! -nargs=? -bang LiveGrep execute
            \ (empty(getbufinfo('^livegrep://'..getcwd()..'$')) ? 'edit livegrep://'..getcwd() : 'buffer ^livegrep://'..getcwd()..'$')
            \| if !empty(<q-args>) || <bang>0 || empty(getline(1))
            \| call setline(1, <q-args>) | 1 | doau TextChanged
            \| endif

cnoreabbrev <expr> lg (getcmdtype() ==# ':' && getcmdline() ==# 'lg') ? 'LiveGrep' : 'lg'

" Start live grepping
nnoremap <silent> <plug>(livegrep-new)      <cmd>LiveGrep!<cr>A
nnoremap <silent> <plug>(livegrep-resume)   <cmd>LiveGrep<cr>
