let s:status = -1
let s:watchers = {}
let s:jobs = {}

function s:setqflist(watcher)
    let action = getqflist({'title': 1}).title == a:watcher.name ? 'r' : ' '

    let list = {}
    let list.efm = a:watcher.errorformat
    let list.lines = a:watcher.lines
    let list.title = a:watcher.name

    call setqflist([], action, list)
endfunction

function s:on_exit(watcher, job_id, status, event)
    if !has_key(s:jobs, a:job_id)|return|endif
    try
        call remove(s:jobs, a:job_id)
        let s:status = a:status
        let a:watcher.status = a:status
        call s:setqflist(a:watcher)
        redrawstatus!
    endtry
endfunction

function s:on_data(watcher, job_id, data, event)
    if !empty(filter(a:data, {_, v -> !empty(v)}))
        call extend(a:watcher.lines, a:data)
    endif
endfunction

function s:name()
    return get(b:, 'current_compiler', get(g:, 'current_compiler', 'NONE'))
endfunction

function s:cmd(watcher)
    return expandcmd(substitute(a:watcher.cmd, '\$\*\|$', ' '..a:watcher.args, ''))
endfunction

function s:run(name)
    if !has_key(s:watchers, a:name)|return|endif
    try
        let watcher = s:watchers[a:name]

        call jobstop(watcher.job_id)
        let watcher.lines = []

        let job = {}
        let job.cmd = s:cmd(watcher)
        let job.on_exit = function('s:on_exit', [watcher])
        let job.on_stdout = function('s:on_data', [watcher])
        let job.on_stderr = function('s:on_data', [watcher])

        let job_id = jobstart(job.cmd, job)
        let watcher.job_id = job_id
        let s:jobs[job_id] = job
        redrawstatus!
    endtry
endfunction

function watcher#watch(...)
    let pattern = a:0 ? a:1 : '*'
    let args = join(a:000[1:])

    let watcher = {}
    let watcher.name = s:name()
    let watcher.pattern = pattern
    let watcher.args = args

    let watcher.cmd = &makeprg
    let watcher.errorformat = &errorformat

    let watcher.lines = []
    let watcher.status = -1
    let watcher.job_id = 0

    execute 'augroup watcher_'..watcher.name
    execute 'autocmd!'
    execute 'autocmd BufWritePost '..watcher.pattern..' call s:run("'..watcher.name..'")'
    execute 'augroup END'

    let s:watchers[watcher.name] = watcher
    call s:run(watcher.name)
endfunction

function watcher#unwatch(name)
    try
        let name = empty(a:name) ? s:name() : a:name
        if !has_key(s:watchers, name)|return|endif
        let watcher = s:watchers[name]

        execute 'autocmd! watcher_'..watcher.name
        execute 'augroup! watcher_'..watcher.name

        call jobstop(watcher.job_id)
        call remove(s:watchers, watcher.name)
        redrawstatus!
    endtry
endfunction

function watcher#status()
    if !empty(s:jobs)|return ''|endif
    if empty(s:watchers)|return ''|endif

    return s:status == 0 ? '' : s:status == -1 ? '' : ''
endfunction

function watcher#complete(arglead, cmdline, curpos)
    return filter(keys(s:watchers), {_, v -> v =~ '^'..a:arglead})
endfunction

function watcher#info()
    let info = ['Watchers:']
    for watcher in values(s:watchers)
        call add(info, watcher.name..' '..(watcher.status == 0 ? '' : watcher.status == -1 ? '' : '')..' '..watcher.pattern)
    endfor
    echo join(info, "\n - ")
endfunction

function watcher#inspect()
    return {'watchers': s:watchers, 'jobs': s:jobs}
endfunction
