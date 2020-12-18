set buftype=nofile bufhidden=wipe nobuflisted noswapfile

let s:insert_help = '<SPACE> inserts wildcard'
let s:normal_help = '<CR> go to result ; <SPACE> go to result in tab ; Edit results and close buffer to load results into quickfix'
let s:placeholder = '  <<< some.*pattern.*in.*file.*contents'
let s:rip_grep = 'rg --vimgrep --smart-case'
let s:git_grep = 'git grep -n -i -I'

let b:num_results = 0

function s:grepprg()
    return (finddir('.git', ';') != '' ? s:git_grep : s:rip_grep)
endfunction

function s:insert_separator(mode)
    if line('$') < 2
        call append('$', [''])
    endif
    let l:ns = nvim_create_namespace('livegrep_separator')
    call nvim_buf_clear_namespace(0, l:ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_virtual_text(0, l:ns, 1, [['--- ', 'Comment'], [s:insert_help, 'Comment']], {})
    elseif a:mode == 'n'
        call nvim_buf_set_virtual_text(0, l:ns, 1, [['--- ', 'Comment'], [s:normal_help, 'Comment']], {})
    endif
endfunction

function s:placeholder()
    let l:ns = nvim_create_namespace('livegrep_placeholder')
    call nvim_buf_clear_namespace(0, l:ns, 0, -1)
    if getline(1) == ''
        call nvim_buf_set_virtual_text(0, l:ns, 0, [[s:placeholder, 'Special']], {})
    endif
endfunction

function s:query()
    return getline(1)
endfunction

function s:editing()
    return line('.') == 1
endfunction

function s:wipe()
    call deletebufline('', 2, '$')
    call s:insert_separator(mode())
endfunction

function s:searchable(live)
    return len(s:query()) >= (a:live ? 3 : 1)
endfunction

function s:search(live)
    if s:searchable(a:live)
        let l:files = systemlist(s:grepprg().' '.shellescape(s:query()))
        call append('$', l:files)
        let b:num_results = len(l:files)
    endif
endfunction

function s:setname(live)
    execute 'keepalt file '.s:grepprg().' '.(s:searchable(a:live) ? s:query() : '...')
endfunction

function s:update(live)
    call s:placeholder()
    if s:editing()
        call s:wipe()
        call s:setname(a:live)
        call s:search(a:live)
    endif
endfunction

function s:export(buf)
    cgetexpr getbufline(str2nr(a:buf), 3, '$')
endfunction

augroup live-grep
    autocmd!
    autocmd CursorHoldI <buffer> call s:update(1)
    autocmd TextChanged <buffer> call s:update(0)
    autocmd InsertLeave <buffer> call s:update(0)
    autocmd InsertEnter <buffer> call s:insert_separator('i')
    autocmd InsertLeave <buffer> call s:insert_separator('n')
    autocmd BufWipeout <buffer> call s:export(expand('<abuf>'))
augroup END

nnoremap <buffer> <SPACE> <C-W>gF
nnoremap <buffer> <CR> gF
inoremap <buffer> <SPACE> .*
