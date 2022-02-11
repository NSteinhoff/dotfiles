setlocal buftype=nofile nobuflisted noswapfile
setlocal errorformat=%f

let s:fuzzy = executable('fzf') && 0
let s:insert_help = '<cr> selects <- ; <c-n>/<c-p> moves <-'..(s:fuzzy ? '' : ' ; <space> inserts wildcards')..' ; <c-c> to exit'
let s:normal_help = '<cr> go to file under cursor'
let s:placeholder = s:fuzzy ? '  <<< fuzzy filename' : '  <<< some.*file.*pattern'
let s:rip_files = 'rg --files'
let s:git_files = 'git ls-files'
let s:matcher = s:fuzzy ? 'fzf -f' : 'rg --smart-case'

let b:selected = 0
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
    let ns = nvim_create_namespace('filefinder_separator')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_extmark(0, ns, 1, 0, {'virt_text': [['--- ', 'Comment'], [s:insert_help, 'Comment']]})
    elseif a:mode == 'n'
        call nvim_buf_set_extmark(0, ns, 1, 0, {'virt_text': [['--- ', 'Comment'], [s:normal_help, 'Comment']]})
    endif
endfunction

function s:placeholder()
    let ns = nvim_create_namespace('filefinder_placeholder')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
    if getline(1) == ''
        call nvim_buf_set_extmark(0, ns, 0, 0, {'virt_text': [[s:placeholder, 'Special']]})
    endif
endfunction

function s:wipe(mode)
    call deletebufline('', 2, '$')
    call s:insert_separator(a:mode)
endfunction

function s:searchable()
    return len(s:query()) >= 1
endfunction

function s:search()
    let files = systemlist(s:finder().(s:searchable() ? ' | '..s:matcher..' '.shellescape(s:query()) : ''))
    call append('$', files)
    let b:num_results = len(files)
endfunction

function s:mark_selection(mode)
    let line = b:selected + 2
    let ns = nvim_create_namespace('filefinder_selection')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_extmark(0, ns, line, 0, {'virt_text': [['<- ', 'Statement']]})
    endif
endfunction

function s:reset_selection()
    let b:selected = 0
endfunction

function s:files()
    return getline(3, '$')
endfunction

function s:move_selection(step)
    let n = b:num_results
    let old_i = b:selected
    let new_i = ((n + old_i + a:step) % n)
    let b:selected = new_i
    call s:mark_selection(mode())
endfunction

function s:update()
    call s:placeholder()
    if s:editing()
        call s:wipe(mode())
        call s:search()
        call s:reset_selection()
        call s:mark_selection(mode())
    endif
endfunction

function s:open_selected()
    let idx = b:selected
    execute 'keepalt edit '.s:files()[idx]
endfunction

function s:open() range
    if a:firstline < 3|return|endif
    let indices = range(a:firstline - 3, a:lastline - 3)
    let files = s:files()
    for i in indices
        execute 'badd '..files[i]
    endfor
    execute 'buffer '..files[indices[0]]
endfunction

augroup file-finder
    autocmd!
    autocmd TextChanged,TextChangedI <buffer> call s:update()
    autocmd InsertEnter <buffer> call s:insert_separator('i')
    autocmd InsertLeave <buffer> call s:insert_separator('n')
    autocmd InsertEnter <buffer> call s:mark_selection('i')
    autocmd InsertLeave <buffer> call s:mark_selection('n')
augroup END

command -buffer Cancel keepalt b#

nnoremap <buffer> <cr> <cmd>call <sid>open()<cr>
vnoremap <buffer> <silent> <cr> :call <sid>open()<cr>
nnoremap <buffer> I 1GI
nnoremap <buffer> A 1GA
nnoremap <buffer> <bs> <cmd>Cancel<cr>
inoremap <buffer> <c-c> <esc><cmd>Cancel<cr>

execute 'inoremap <buffer> <space> '..(s:fuzzy ? ' ' : '.*')
inoremap <buffer> <cr> <esc><cmd>call <sid>open_selected()<cr>
inoremap <buffer> <plug>(filefinder-next) <cmd>call <sid>move_selection(1)<cr>
inoremap <buffer> <plug>(filefinder-prev) <cmd>call <sid>move_selection(-1)<cr>
imap <buffer> <c-n> <plug>(filefinder-next)
imap <buffer> <c-p> <plug>(filefinder-prev)
imap <buffer> <tab> <plug>(filefinder-next)
imap <buffer> <s-tab> <plug>(filefinder-prev)
