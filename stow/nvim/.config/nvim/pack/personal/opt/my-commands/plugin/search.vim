" Global
if executable('rg')
    set grepprg=rg\ --vimgrep
else
    " 'grep' on Ubuntu and MacOS support the '-H' option for showing filenames
    " for single files. This makes the '/dev/null' hack unnecessary.
    set grepprg=grep\ -nH
endif

command! -bang -nargs=+ -complete=file Grep execute (<bang>0 ? 'cgetexpr' : 'cexpr')..' system("grep -n -r '..expandcmd(<q-args>)..'")'
command! -bang -nargs=+ -complete=file GitGrep execute (<bang>0 ? 'cgetexpr' : 'cexpr')..' system("git grep -n '..expandcmd(<q-args>)..'")'
command! -bang -nargs=+ -complete=file RipGrep execute (<bang>0 ? 'cgetexpr' : 'cexpr')..' system("rg --vimgrep --smart-case '..expandcmd(<q-args>)..'")'

" Live results
command! -nargs=? -bang LiveGrep execute
            \ (empty(getbufinfo('^GREP$')) ? 'edit GREP' : 'buffer ^GREP$')
            \| if !empty(<q-args>) || <bang>0 || empty(getline(1))
            \| call setline(1, <q-args>) | 1 | doau TextChanged
            \| endif

nnoremap <silent> <Plug>(livegrep-new) <CMD>LiveGrep!<CR>A
nnoremap <silent> <Plug>(livegrep-resume) <CMD>LiveGrep<CR>
vnoremap <silent> <Plug>(livegrep-selection) y:execute 'LiveGrep '.@"<CR>

nnoremap <silent> <Plug>(search-word-in-file) :execute 'lvimgrep /\<'..expand('<cword>')..'\>/ %'<CR>
vnoremap <silent> <Plug>(search-selection-in-file) y:execute 'lvimgrep /'..escape(@", '\/')..'/ %'<CR>
