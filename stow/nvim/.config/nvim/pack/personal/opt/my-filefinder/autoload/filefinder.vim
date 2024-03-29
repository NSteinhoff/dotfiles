let s:insert_help = '<cr> selects <- ; <c-n>/<c-p> moves <- ; <space> inserts wildcards ; <c-c> to exit'
let s:normal_help = '<cr> go to file under cursor'
let s:placeholder = '  <<< some.*file.*pattern'
let s:matcherprg = 'rg --smart-case --'

" -------------------------------------------------------------------------- "
"                              Public Functions                              "
" -------------------------------------------------------------------------- "
function filefinder#start(pattern, clean)
    let files = s:get_matching_files(a:pattern)

"     " Short circuit if there is only one match
"     if len(files) == 1
"         execute 'edit '..files[0]
"         return
"     endif

    let b = 'filefinder://'..getcwd()
    let winnr = bufwinnr(bufnr(b))

    if winnr == -1
        execute 'edit '..b
        augroup file-finder
            autocmd!
            autocmd TextChanged,TextChangedI <buffer> call filefinder#update(0)
            autocmd InsertEnter <buffer> call filefinder#insert_separator('i')
            autocmd InsertLeave <buffer> call filefinder#insert_separator('n')
            autocmd InsertEnter <buffer> call filefinder#mark_selection('i')
            autocmd InsertLeave <buffer> call filefinder#mark_selection('n')
        augroup END
        setf filefinder
    else
        execute winnr .. 'wincmd w'
    endif

    if !empty(a:pattern) || a:clean
        call setline(1, a:pattern)
        call filefinder#update(1)
    endif

    call feedkeys('A')
endfunction

function filefinder#insert_separator(mode)
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

function filefinder#mark_selection(mode)
    let line = b:selected + 2
    let ns = nvim_create_namespace('filefinder_selection')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_extmark(0, ns, line, 0, {'virt_text': [['<- ', 'Statement']]})
    endif
endfunction

function filefinder#move_selection(step)
    let n = b:num_results
    let old_i = b:selected
    let new_i = ((n + old_i + a:step) % n)
    let b:selected = new_i
    call filefinder#mark_selection(mode())
endfunction

function filefinder#update(force)
    call s:placeholder()
    if !s:editing() && !a:force
        return
    endif

    call s:wipe(mode())
    call s:search(s:query())
    call s:reset_selection()
    call filefinder#mark_selection(mode())
endfunction

function filefinder#open_selected()
    let idx = b:selected
    execute 'keepalt edit '.s:files()[idx]
endfunction

function filefinder#open() range
    if a:firstline < 3|return|endif
    let indices = range(a:firstline - 3, a:lastline - 3)
    let files = s:files()
    for i in indices
        execute 'badd '..files[i]
    endfor
    execute 'buffer '..files[indices[0]]
endfunction

" -------------------------------------------------------------------------- "
"                          Private Helper Functions                          "
" -------------------------------------------------------------------------- "
function s:listerprg()
    if finddir('.git', ';') != ''
        return 'git ls-files'
    endif

    return 'rg --files'
endfunction

function s:query()
    return getline(1)
endfunction

function s:editing()
    return line('.') == 1
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
    call filefinder#insert_separator(a:mode)
endfunction

function s:get_matching_files(pattern)
    if empty(a:pattern)
        return systemlist(s:listerprg())
    else
        return systemlist(s:listerprg()..' | '..s:matcherprg..' '.shellescape(a:pattern))
    endif
endfunction

function s:search(pattern)
    let files = s:get_matching_files(a:pattern)
    call append('$', files)
    let b:num_results = len(files)
endfunction

function s:reset_selection()
    let b:selected = 0
endfunction

function s:files()
    return getline(3, '$')
endfunction
