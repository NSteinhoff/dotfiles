setlocal buftype=nofile nobuflisted noswapfile
setlocal errorformat=%f

let s:insert_help = '<CR> selects <- ; <C-N>/<C-P> moves <- ; <SPACE> inserts wildcards ; <C-C> to exit'
let s:normal_help = '[1-9] open file ; <CR> go to file under cursor'
let s:placeholder = '  <<< some.*file.*pattern'
let s:rip_files = 'rg --files'
let s:git_files = 'git ls-files'

let b:selected = 1
let b:num_results = 0

function s:finder()
    return (finddir('.git', ';') != '' ? s:git_files : s:rip_files)
endfunction

function s:query()
    return getline(1)
endfunction

function s:editing()
    return line('.') == 1
endfunction

function s:insert_separator(mode)
    if line('$') < 2
        call append('$', [''])
    endif
    let l:ns = nvim_create_namespace('filefinder_separator')
    call nvim_buf_clear_namespace(0, l:ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_virtual_text(0, l:ns, 1, [['--- ', 'Comment'], [s:insert_help, 'Comment']], {})
    elseif a:mode == 'n'
        call nvim_buf_set_virtual_text(0, l:ns, 1, [['--- ', 'Comment'], [s:normal_help, 'Comment']], {})
    endif
endfunction

function s:placeholder()
    let l:ns = nvim_create_namespace('filefinder_placeholder')
    call nvim_buf_clear_namespace(0, l:ns, 0, -1)
    if getline(1) == ''
        call nvim_buf_set_virtual_text(0, l:ns, 0, [[s:placeholder, 'Special']], {})
    endif
endfunction

function s:wipe(mode)
    call deletebufline('', 2, '$')
    call s:insert_separator(a:mode)
endfunction

function s:searchable()
    return len(s:query()) >= 1
endfunction

function s:digits(n)
    return float2nr(log10(a:n)) + 1
endfunction

function s:nr2str(n, digits)
    return repeat(' ', a:digits - s:digits(a:n)).a:n
endfunction

function s:search()
    let l:files = systemlist(s:finder().(s:searchable() ? ' | rg --smart-case '.shellescape(s:query()) : ''))
    let maxdigits = s:digits(len(l:files))
    call append('$', map(l:files, { i, v -> s:nr2str(i+1, maxdigits).': '.v}))
    let b:num_results = len(l:files)
endfunction

function s:mark_selection(mode)
    let l:line = b:selected + 1     " lines are 0-indexed for virtual text
    let l:ns = nvim_create_namespace('filefinder_selection')
    call nvim_buf_clear_namespace(0, l:ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_virtual_text(0, l:ns, l:line, [['<- ', 'Statement']], {})
    endif
endfunction

function s:reset_selection()
    let b:selected = 1
endfunction

function s:move_selection(step)
    let l:n = b:num_results
    let l:old_i = b:selected - 1
    let l:new_i = ((l:n + l:old_i + a:step) % l:n)
    let b:selected = l:new_i + 1
    call s:mark_selection(mode())
endfunction

function s:highlight()
    syntax clear filefinder_match

    let q = s:query()
    if !empty(q)
        execute 'syntax match filefinder_match /\c\v'.q.'/ contained'
    endif
endfunction

function s:update()
    call s:placeholder()
    if s:editing()
        call s:wipe(mode())
        call s:search()
        call s:reset_selection()
        call s:mark_selection(mode())
        " call s:highlight()
    endif
endfunction

function s:open_file(num)
    execute 'keepalt edit '.substitute(getline(a:num + 2), '^\s*\d\+:', '', '')
endfunction

function s:open_selected()
    call s:open_file(b:selected)
endfunction

augroup file-finder
    autocmd!
    autocmd TextChanged,TextChangedI <buffer> call s:update()
    autocmd InsertEnter <buffer> call s:insert_separator('i')
    autocmd InsertLeave <buffer> call s:insert_separator('n')
    autocmd InsertEnter <buffer> call s:mark_selection('i')
    autocmd InsertLeave <buffer> call s:mark_selection('n')
    autocmd BufEnter <buffer> let b:colors_name=g:colors_name | colorscheme delek
    autocmd BufLeave <buffer> execute 'colorscheme '..b:colors_name
augroup END

nnoremap <buffer> <CR> <cmd>if line('.') > 2 \| call <SID>open_file(line('.')-2) \| endif<CR>
nnoremap <buffer> I 1GI
nnoremap <buffer> A 1GA
nnoremap <buffer> <BS> <CMD>keepalt b#<CR>

inoremap <buffer> <SPACE> .*
inoremap <buffer> <CR> <esc><cmd>call <SID>open_selected()<CR>
inoremap <buffer> <C-N> <cmd>call <SID>move_selection(1)<CR>
inoremap <buffer> <C-P> <cmd>call <SID>move_selection(-1)<CR>
inoremap <buffer> <C-C> <esc><cmd>bdelete<CR>

for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    execute 'nnoremap <buffer> '.i.' <cmd>silent call <SID>open_file('.i.')<cr>'
endfor
