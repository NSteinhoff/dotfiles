" Local
command! -nargs=+ Vimgrep execute 'lvimgrep /' . <q-args> . '/ ' . expand('%')

" Global
command! -nargs=+ Grep cexpr system('grep -n -r '.<q-args>.' .')
command! -nargs=+ GitGrep cexpr system('git grep -n '.<q-args>)
command! -nargs=+ RipGrep cexpr system('rg --vimgrep --smart-case '.<q-args>)

" Live results
command! -nargs=? -bang LiveGrep execute
            \ (empty(getbufinfo('^livegrep$')) ? 'edit livegrep' : 'buffer ^livegrep$')
            \| if !empty(<q-args>) || <bang>0 || empty(getline(1))
            \| call setline(1, <q-args>) | 1 | doau TextChanged
            \| endif

nnoremap <silent> <Plug>(livegrep-new) <CMD>LiveGrep!<CR>A
nnoremap <silent> <Plug>(livegrep-resume) <CMD>LiveGrep<CR>
vnoremap <silent> <Plug>(livegrep-selection) y:execute 'LiveGrep '.@"<CR>

nnoremap <silent> <Plug>(search-word-in-file) :execute 'Vimgrep \<'.expand('<cword>').'\>'<CR>
vnoremap <silent> <Plug>(search-selection-in-file) y:execute 'Vimgrep '.escape(@", '\/')<CR>
