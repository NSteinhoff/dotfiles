setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
setlocal errorformat=%f

let s:rip_files = 'rg --files'
let s:git_files = 'git ls-files'

function s:finder()
    return (finddir('.git', ';') != '' ? s:git_files : s:rip_files)
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
        call append('$', systemlist(s:finder().' | grep '.shellescape(s:query())))
    endif
endfunction

function s:setname(live)
    execute 'keepalt file '.s:finder().' \| grep  '.(s:searchable(a:live) ? s:query() : '...')
endfunction

function s:update(live)
    if s:editing()
        call s:wipe()
        call s:setname(a:live)
        call s:search(a:live)
    endif
endfunction

augroup live-grep
    autocmd!
    autocmd TextChangedI <buffer> call s:update(1)
    autocmd TextChanged <buffer> call s:update(0)
    autocmd InsertLeave <buffer> call s:update(0)
augroup END

nnoremap <SPACE> <C-W>gf
nnoremap <expr> <CR> <SID>editing() ? '3Ggf' : 'gf'
inoremap <expr> <CR> <SID>editing() ? '<esc>3Ggf' : 'gf'
