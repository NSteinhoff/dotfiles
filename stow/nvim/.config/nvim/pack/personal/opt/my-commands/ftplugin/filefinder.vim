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

function s:searchable()
    return len(s:query()) >= 1
endfunction

function s:search()
    let l:files = systemlist(s:finder().(s:searchable() ? ' | grep -i '.shellescape(s:query()) : ''))
    call append('$', map(l:files, { i, v -> i.': '.v}))
endfunction

function s:setname()
    execute 'keepalt file '.s:finder().' \| grep  -i '.(s:searchable() ? s:query() : '...')
endfunction

function s:update()
    if s:editing()
        call s:wipe()
        call s:setname()
        call s:search()
    endif
endfunction

augroup file-finder
    autocmd!
    autocmd TextChangedI <buffer> call s:update()
    autocmd TextChanged <buffer> call s:update()
augroup END

inoremap <buffer> <SPACE> .*
nnoremap <buffer> <SPACE> <C-W>gf
nnoremap <buffer> <expr> <CR> <SID>editing() ? '3Ggf' : 'gf'
inoremap <buffer> <expr> <CR> <SID>editing() ? '<esc>3Ggf' : '<esc>gf'

function s:open_file(num)
    execute 'edit '.substitute(getline(a:num + 3), '^\d\+:', '', '')
endfunction

for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    execute 'nnoremap <buffer> '.i.' <cmd>silent call <SID>open_file('.i.')<cr>'
endfor
