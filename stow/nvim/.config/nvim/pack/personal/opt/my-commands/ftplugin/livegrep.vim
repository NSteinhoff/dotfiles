set buftype=nofile bufhidden=wipe nobuflisted noswapfile

let s:rip_grep = 'rg --vimgrep --smart-case'
let s:git_grep = 'git grep -n -i -I'

function s:grepprg()
    return (finddir('.git', ';') != '' ? s:git_grep : s:rip_grep)
endfunction

function s:query()
    return getline(1)
endfunction

function s:editing()
    return line('.') == 1
endfunction

function s:wipe()
    call deletebufline('', 2, '$')
    call append('$', ['---'])
endfunction

function s:searchable(live)
    return len(s:query()) >= (a:live ? 3 : 1)
endfunction

function s:search(live)
    if s:searchable(a:live)
        call append('$', systemlist(s:grepprg().' '.shellescape(s:query())))
    endif
endfunction

function s:setname(live)
    execute 'keepalt file '.s:grepprg().' '.(s:searchable(a:live) ? s:query() : '...')
endfunction

function s:update(live)
    if s:editing()
        call s:wipe()
        call s:setname(a:live)
        call s:search(a:live)
    endif
endfunction

function s:export()
    cgetexpr getline(3, '$')
endfunction

augroup live-grep
    autocmd!
    autocmd TextChangedI <buffer> call s:update(1)
    autocmd TextChanged <buffer> call s:update(0) | call s:export()
    autocmd InsertLeave <buffer> call s:update(0) | call s:export()
augroup END

nnoremap <SPACE> <C-W>gF
nnoremap <CR> gF
