set buftype=nofile nobuflisted noswapfile

setlocal errorformat=%f:%l:%c:%m

let s:insert_help = '<SPACE> inserts wildcard ; <CR> go to first result ; <C-C> to exit'
let s:normal_help = '<CR>/<SPACE> jump to result ; e(X)port; (R)eload'
let s:placeholder = '  <<< some.*pattern.*in.*file.*contents'
let s:rip_grep = 'rg --vimgrep --smart-case --sort path'
let s:git_grep = 'git grep -n -i -I'

let b:query = get(b:, 'query', '')

function s:grepprg()
    return s:rip_grep
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
    let q = s:query()

    if empty(q) | return 0 | endif
    if q ==# b:query | return 0 | endif
    if len(q) < (a:live ? 3 : 1) | return 0 | endif
    if q =~ '|$' | return 0 | endif

    for a in split(q, '|')
        if len(a) < (a:live ? 3 : 1) | return 0 | endif
    endfor

    return 1
endfunction

function s:highlight()
    syntax clear livegrep_match

    let q = s:query()

    if !empty(q)
        execute 'syntax match livegrep_match /\c\v'.q.'/ contained'
    endif
endfunction

function s:search()
    let l:query = s:query()
    let b:query = l:query
    if !empty(l:query)
        let l:files = systemlist(s:grepprg().' '.shellescape(l:query))
        call append('$', l:files)
    endif
endfunction

function s:update(live, ...)
    call s:placeholder()
    if s:editing() && s:searchable(a:live) || a:0
        call s:wipe()
        call s:search()
        " call s:highlight()
    endif
    if !a:live
        call s:export('%')
    endif
endfunction

function s:export(buf, ...)
    if empty(b:query)
        return
    endif
    let lines = getbufline(a:buf, 3, '$')
    if a:0 && a:1
        call setqflist([], 'a', {'lines': lines})
    else
        let title = '[livegrep] '..shellescape(b:query)
        let curtitle = getqflist({'title': 1}).title
        call setqflist([], title == curtitle ? 'r' : ' ', {'lines': lines, 'title': title})
    endif
endfunction

function s:goto(line)
    if a:line <=2
        return
    endif
    call s:export('%')
    execute 'keepalt cc '.(a:line - 2)
endfunction

augroup live-grep
    autocmd!
    autocmd BufEnter <buffer> call s:update(0)
    autocmd CursorHoldI <buffer> call s:update(1)
    autocmd TextChanged <buffer> call s:update(0)
    autocmd InsertLeave <buffer> call s:update(0)
    autocmd InsertEnter <buffer> call s:insert_separator('i')
    autocmd InsertLeave <buffer> call s:insert_separator('n')
augroup END

command -buffer Cancel keepalt b#
command -buffer -bang Export call s:export('%', <bang>0)
command -buffer Reload call s:update(0, 1)

inoremap <buffer> <SPACE> .*
inoremap <buffer> <CR> <esc><CMD>call <SID>goto(3)<CR>
inoremap <buffer> <C-C> <esc><cmd>Cancel<CR>

nnoremap <buffer> <SPACE> <CMD>call <SID>goto(line('.'))<CR>
nnoremap <buffer> <CR> <CMD>call <SID>goto(line('.'))<CR>
nnoremap <buffer> <BS> <CMD>Cancel<CR>
nnoremap <buffer> <expr> i line('.') == 1 ? 'i' : '1GI'
nnoremap <buffer> <expr> I line('.') == 1 ? 'I' : '1GI'
nnoremap <buffer> <expr> a line('.') == 1 ? 'a' : '1GA'
nnoremap <buffer> <expr> A line('.') == 1 ? 'A' : '1GA'
nnoremap <buffer> X <CMD>Export<CR>
nnoremap <buffer> R <CMD>Reload<CR>
nnoremap <buffer> gs <CMD>call <SID>export('%')<CR>:cdo s/\v=getline(1)/
nnoremap <buffer> gS <CMD>call <SID>export('%')<CR>:cfdo %s/\v=getline(1)/

onoremap <buffer> i<bar> <CMD>normal! T<bar>vt<bar><CR>
onoremap <buffer> a<bar> <CMD>normal! F<bar>vf<bar><CR>
