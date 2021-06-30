let s:insert_help = '<SPACE> inserts wildcard ; <CR> go to first result ; <C-C> to exit'
let s:normal_help = '<CR>/<SPACE> jump to result ; e(X)port; (R)eload'
let s:placeholder = '  <<< some.*pattern.*in.*file.*contents'
let s:rip_grep = 'rg --vimgrep --smart-case --sort path'
let s:git_grep = 'git grep -n -i -I'
let s:errorformat = '%f:%l:%c:%m'
let s:ns_loading = nvim_create_namespace('livegrep_job_loading')
let s:ns_results = nvim_create_namespace('livegrep_job_results')

let s:job = {'id': 0}

function s:job.on_stdout(job_id, data, event)
    let self.data = extend(self.data, filter(a:data, {_, v -> !empty(v)}))
endfunction

function s:job.on_stderr(job_id, data, event)
    let self.err = extend(self.err, filter(a:data, {_, v -> !empty(v)}))
endfunction

function s:job.on_exit(job_id, data, event)
    if a:job_id != self.id
        return
    endif

    call nvim_buf_clear_namespace(self.buf, s:ns_results, 0, -1)
    call nvim_buf_clear_namespace(self.buf, s:ns_loading, 0, -1)

    let lines = self.data
    if !empty(self.err)
        let lines += ['', '=================================== ERROR ====================================']
        let lines += self.err
        let lines += ['', '=================================== HELP =====================================']
        let lines += systemlist(s:grepprg()..' --help')
        call nvim_buf_set_virtual_text(self.buf, s:ns_results, 0, [['', 'Error']], {})
    else
        call nvim_buf_set_virtual_text(self.buf, s:ns_results, 0, [[printf('(%d)', len(self.data)), 'Special']], {})
    endif

    call s:wipe(self.buf)
    call appendbufline(self.buf, '$', self.data + self.err)
endfunction

function s:job.stop()
    call jobstop(self.id)
endfunction

function s:job.start(buf, cmd)
    call self.stop()
    let self.data = []
    let self.err = []
    let self.buf = a:buf
    let self.id = jobstart(a:cmd , self)
    call self.loading()
endfunction

function s:job.loading()
    call nvim_buf_clear_namespace(self.buf, s:ns_results, 0, -1)
    call nvim_buf_clear_namespace(self.buf, s:ns_loading, 0, -1)
    call nvim_buf_set_virtual_text(self.buf, s:ns_loading, 0, [['', 'Special']], {})
endfunction

function s:previous_query()
    return get(b:, 'query', '')
endfunction

function s:grepprg()
    return s:rip_grep
endfunction

function livegrep#insert_separator(buf, mode)
    if line('$') < 2
        call appendbufline(a:buf, '$', [''])
    endif
    let l:ns = nvim_create_namespace('livegrep_separator')
    call nvim_buf_clear_namespace(a:buf, l:ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_virtual_text(a:buf, l:ns, 1, [['--- ', 'Comment'], [s:insert_help, 'Comment']], {})
    elseif a:mode == 'n'
        call nvim_buf_set_virtual_text(a:buf, l:ns, 1, [['--- ', 'Comment'], [s:normal_help, 'Comment']], {})
    endif
endfunction

function s:placeholder(buf)
    let l:ns = nvim_create_namespace('livegrep_placeholder')
    call nvim_buf_clear_namespace(a:buf,  l:ns, 0, -1)
    if getbufline(a:buf, 1)[0] == ''
        call nvim_buf_set_virtual_text(a:buf, l:ns, 0, [[s:placeholder, 'Special']], {})
    endif
endfunction

function s:query(buf)
    return getbufline(a:buf, 1)[0]
endfunction

function s:editing(buf)
    return bufnr() == a:buf && line('.') == 1
endfunction

function s:wipe(buf)
    call deletebufline(a:buf, 2, '$')
    call livegrep#insert_separator(a:buf, mode())
endfunction

function s:searchable(buf, live)
    let q = s:query(a:buf)

    if empty(q) | return 0 | endif
    if q ==# s:previous_query() | return 0 | endif
    if len(q) < (a:live ? 3 : 1) | return 0 | endif
    if q =~ '[|\\]$' | return 0 | endif
    if q =~ '([^)]*$' | return 0 | endif

    for a in split(q, '|')
        if len(a) < (a:live ? 3 : 1) | return 0 | endif
    endfor

    return 1
endfunction

function s:search(buf)
    let l:query = s:query(a:buf)
    let b:query = l:query
    if !empty(l:query)
        call s:job.start(a:buf, s:grepprg().' '.l:query)
    endif
endfunction

function livegrep#update(live, buf, ...)
    call s:placeholder(a:buf)
    if s:editing(a:buf) && s:searchable(a:buf, a:live) || a:0
        call s:search(a:buf)
    endif
endfunction

function livegrep#export(buf, ...)
    if empty(s:query(a:buf))
        return
    endif
    let lines = getbufline(a:buf, 3, '$')
    if a:0 && a:1
        call setqflist([], 'a', {'lines': lines, 'efm': s:errorformat, 'nr': '$'})
    else
        let title = '[livegrep] '..s:query(a:buf)
        let curtitle = getqflist({'title': 1}).title
        call setqflist([], title == curtitle ? 'r' : ' ', {'lines': lines, 'efm': s:errorformat, 'title': title, 'nr': '$'})
    endif
endfunction

function livegrep#goto(line)
    if a:line <=2
        return
    endif
    call livegrep#export('%')
    execute 'keepalt cc '.(a:line - 2)
endfunction
