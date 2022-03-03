let s:next_update = 0
let s:debounce_seconds = 5
let s:shadowfile = tempname()
let s:errorformat = &errorformat
let s:timerid = 0

function s:check_for_updates()
    let l:last_modified = getftime(&errorfile)
    if findfile(s:shadowfile) == '' || l:last_modified > s:next_update
        let s:next_update = l:last_modified + s:debounce_seconds
        execute 'silent !touch '.s:shadowfile

        let errorlines = readfile(&errorfile)
        let shadowlines = readfile(s:shadowfile)

        let delta = []
        let lnum = len(shadowlines)
        while lnum < len(errorlines)
            call add(delta, errorlines[lnum])
            let lnum+=1
        endwhile
        call setqflist([], ' ', {'efm': s:errorformat, 'lines': delta, 'title': 'Watcherr'})
        call writefile(delta, s:shadowfile, 'a')
    endif
endfunction

function watcherr#enable(errorformat)
    let s:timerid = timer_start(s:debounce_seconds*1000, {id -> s:check_for_updates()}, {'repeat': -1})
    " let s:errorformat = a:errorformat
    " augroup watcherr
    "     autocmd!
    "     autocmd CursorHold,CursorMoved * call s:check_for_updates()
    " augroup END
endfunction

function watcherr#disable()
    if s:timerid
        call timer_stop(s:timerid)
        let s:timerid = 0
    endif
    " let s:errorformat = &errorformat
    " if exists('#my-showmarks#CursorHold,CursorMoved')
    "     autocmd! watcherr
    "     augroup! watcherr
    " endif
    call delete(s:shadowfile)
endfunction
