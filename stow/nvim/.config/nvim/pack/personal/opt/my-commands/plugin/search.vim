" Global
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --glob=!.git/*
    set grepformat=%f:%l:%c:%m
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

function s:grep(pattern, word, ...) abort
    let cmd = 'grep! '
    let @/ = a:word ? '\<'..a:pattern..'\>' : a:pattern
    let pattern = a:word ? '''\b'..a:pattern..'\b''' : "'"..a:pattern.."'"
    let extra = a:0 ? ' '..join(a:000, ' ') : ''
    execute cmd..pattern..extra
endfunction

function s:selected() abort
    return substitute(escape(@", '()\|.*+[]^$'), "'", '''\\''''', 'g')
endfunction

nnoremap <silent> <plug>(livegrep-new) <cmd>LiveGrep!<cr>A
nnoremap <silent> <plug>(livegrep-resume) <cmd>LiveGrep<cr>
vnoremap <silent> <plug>(livegrep-selection) y:execute 'LiveGrep '..escape(@", '()\|.*+[]^$')<cr>

nnoremap <silent> <plug>(search-word) <cmd>call <sid>grep(expand('<cword>'), 1)<cr>
nnoremap <silent> <plug>(search-word-g) <cmd>call <sid>grep(expand('<cword>'), 0)<cr>
vnoremap <silent> <plug>(search-selection) y:call <sid>grep(<sid>selected(), 0)<cr>

nnoremap <silent> <plug>(search-word-in-file) <cmd>call <sid>grep(expand('<cword>'), 1, '%')<cr>
nnoremap <silent> <plug>(search-word-g-in-file) <cmd>call <sid>grep(expand('<cword>'), 0, '%')<cr>
vnoremap <silent> <plug>(search-selection-in-file) y:call <sid>grep(<sid>selected(), 0, '%')<cr>
