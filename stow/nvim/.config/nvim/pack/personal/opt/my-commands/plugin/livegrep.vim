command! -nargs=? -bang LiveGrep execute (empty(getbufinfo('^livegrep$')) ? 'edit livegrep' : 'buffer ^livegrep$') | if !empty(<q-args>) || <bang>0 | call setline(1, <q-args>) | 1 | doau TextChanged | endif

nnoremap <silent> <Plug>(livegrep-new) <CMD>LiveGrep!<CR>A
nnoremap <silent> <Plug>(livegrep-resume) <CMD>LiveGrep<CR>
vnoremap <silent> <Plug>(livegrep-selection) y:execute 'LiveGrep '.@"<CR>
