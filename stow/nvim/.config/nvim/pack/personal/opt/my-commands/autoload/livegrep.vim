let s:insert_help = '<space> inserts wildcard ; <cr> go to first result ; <c-c> to exit'
let s:normal_help = '<cr>/<space> jump to result ; e(X)port; (R)eload'
let s:placeholder = '  <<< some.*pattern.*in.*file.*contents'
let s:grepprg = 'rg -n --smart-case --sort path --glob !.git/*'
let s:errorformat = '%f:%l:%m'
let s:ns_loading = nvim_create_namespace('livegrep_job_loading')
let s:ns_results = nvim_create_namespace('livegrep_job_results')

" Plugin State
let s:history = []
let s:histindex = -1
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
        let lines += systemlist(s:grepprg..' --help')
        call nvim_buf_set_extmark(self.buf, s:ns_results, 0, 0, {'virt_text': [['', 'Error']]} )
    else
        call nvim_buf_set_extmark(self.buf, s:ns_results, 0, 0, {'virt_text': [[printf('(%d)', len(self.data)), 'Special']]})
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
    let self.id = jobstart(split(a:cmd) , self)
    call self.loading()
endfunction

function s:job.loading()
    call nvim_buf_clear_namespace(self.buf, s:ns_results, 0, -1)
    call nvim_buf_clear_namespace(self.buf, s:ns_loading, 0, -1)
    call nvim_buf_set_extmark(self.buf, s:ns_loading, 0, 0, {'virt_text': [['', 'Special']]})
endfunction

function s:previous_query()
    return get(b:, 'query', '')
endfunction

function livegrep#insert_separator(buf, mode)
    if line('$') < 2
        call appendbufline(a:buf, '$', [''])
    endif
    let l:ns = nvim_create_namespace('livegrep_separator')
    call nvim_buf_clear_namespace(a:buf, l:ns, 0, -1)
    if a:mode == 'i'
        call nvim_buf_set_extmark(a:buf, l:ns, 1, 0, {'virt_text': [['--- ', 'Comment'], [s:insert_help, 'Comment']]})
    elseif a:mode == 'n'
        call nvim_buf_set_extmark(a:buf, l:ns, 1, 0, {'virt_text': [['--- ', 'Comment'], [s:normal_help, 'Comment']]})
    endif
endfunction

function s:placeholder(buf)
    let l:ns = nvim_create_namespace('livegrep_placeholder')
    call nvim_buf_clear_namespace(a:buf,  l:ns, 0, -1)
    if getbufline(a:buf, 1)[0] == ''
        call nvim_buf_set_extmark(a:buf, l:ns, 0, 0, {'virt_text': [[s:placeholder, 'Special']]})
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
        call s:job.start(a:buf, s:grepprg.' '.l:query.' .')
    endif
endfunction

function livegrep#update(live, buf, ...)
    call s:placeholder(a:buf)
    let force_update = a:0
    if s:editing(a:buf) && s:searchable(a:buf, a:live) || force_update
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

function livegrep#inspect()
    let info = "Livegrep\n"
    let info.= "========\n"
    let info.= "\nJob:\n{\n"
    let info.= "  "..join(map(copy(items(s:job)), {_, v -> join(v, ': ')}), "\n  ").."\n}\n"
    let info.= "\nHistory:\n"
    let info.= join(map(copy(s:history), {i, v -> (i == s:histindex ? ' *' : '  ')..v}), "\n").."\n"
    echo info
endfunction

function livegrep#histpush()
    let line = getline(1)
    if empty(line) || get(s:history, s:histindex, "") == line
        return
    endif
    call add(s:history, line)
    let s:histindex = len(s:history)
endfunction

function livegrep#history(delta)
    let idx = s:histindex + a:delta
    let idx = max([0, idx])
    let idx = min([idx, len(s:history)])
    let s:histindex = idx
    return get(s:history, s:histindex, "")
endfunction
