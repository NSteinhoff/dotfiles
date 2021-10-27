" Global
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --glob=!.git/*
    set grepformat=%f:%l:%c:%m
else
    " 'grep' on Ubuntu and MacOS support the '-H' option for showing filenames
    " for single files. This makes the '/dev/null' hack unnecessary.
    set grepprg=grep\ -nH
endif

" Live results
command! -nargs=? -bang LiveGrep execute
            \ (empty(getbufinfo('^GREP$')) ? 'edit GREP' : 'buffer ^GREP$')
            \| if !empty(<q-args>) || <bang>0 || empty(getline(1))
            \| call setline(1, <q-args>) | 1 | doau TextChanged
            \| endif

function s:text_to_vim_pattern(text, matchword)
    let pattern = a:text

    let pattern = escape(pattern, '\')

    if a:matchword
        let pattern = '\<'..pattern..'\>'
    endif

    " Avoid having to escape all the special characters
    let pattern = '\V'..pattern

    return pattern
endfunction

function s:text_to_grep_pattern(text, matchword)
    let pattern = a:text

    " The pipe needs to be escaped first, so that the corresponding \ is
    " escaped as well
    let pattern = escape(pattern, '|')

    " Meta characters
    let pattern = escape(pattern, '.*+?^$()[]\')

    " Vim cmdline expansion
    let pattern = escape(pattern, '%#')

    if a:matchword
        let pattern = '\b'..pattern..'\b'
    endif

    let pattern = shellescape(pattern)

    return pattern
endfunction

function s:grep(text, matchword, silent, ...) abort
    let @/ = s:text_to_vim_pattern(a:text, a:matchword)
    let pattern = s:text_to_grep_pattern(a:text, a:matchword)
    let args = join([''] + a:000, ' ')
    let silent = a:silent ? 'silent ' : ''
    execute silent..'grep! '..pattern..args
endfunction

" Start live grepping
nnoremap <silent> <plug>(livegrep-new)      <cmd>LiveGrep!<cr>A
nnoremap <silent> <plug>(livegrep-resume)   <cmd>LiveGrep<cr>

" Extending '*' and '#' to visual selection
vnoremap <silent> <plug>(search-selection)          y:let @/ = <sid>text_to_vim_pattern(@", 0)<bar>call feedkeys('n')<cr>
vnoremap <silent> <plug>(search-selection-reverse)  y:let @/ = <sid>text_to_vim_pattern(@", 0)<bar>call feedkeys('N')<cr>

" Standard
nnoremap <silent> <plug>(grep-word)             <cmd>call <sid>grep(expand('<cword>'), 1, 0)<cr>
nnoremap <silent> <plug>(grep-word-g)           <cmd>call <sid>grep(expand('<cword>'), 0, 0)<cr>
vnoremap <silent> <plug>(grep-selection)           y:call <sid>grep(@",                0, 0)<cr>

" Silent
nnoremap <silent> <plug>(grep-word-silent)      <cmd>call <sid>grep(expand('<cword>'), 1, 1)<cr>
nnoremap <silent> <plug>(grep-word-g-silent)    <cmd>call <sid>grep(expand('<cword>'), 0, 1)<cr>
vnoremap <silent> <plug>(grep-selection-silent)    y:call <sid>grep(@",                0, 1)<cr>

" Local in current file
nnoremap <silent> <plug>(grep-word-in-file)     <cmd>call <sid>grep(expand('<cword>'), 1, 0, '%')<cr>
nnoremap <silent> <plug>(grep-word-g-in-file)   <cmd>call <sid>grep(expand('<cword>'), 0, 0, '%')<cr>
vnoremap <silent> <plug>(grep-selection-in-file)   y:call <sid>grep(@",                0, 0, '%')<cr>
