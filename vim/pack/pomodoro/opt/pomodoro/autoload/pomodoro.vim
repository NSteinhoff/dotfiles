let s:session_minutes = 25
let s:break_minutes = 5

function! s:duration_minutes(duration)
    return a:duration / 60
endfunction

function! s:duration_seconds(duration)
    return a:duration % 60
endfunction

function! s:start_session(start_time)
    let session = {}
    let session.id = len(s:sessions) + 1
    let session.start = a:start_time
    let session.last = a:start_time
    let session.duration = 0
    let session.notified = 0
    let session.scheduled = copy(s:session_minutes)
    let session.break = copy(s:break_minutes)

    call add(s:sessions, session)
    echomsg "Starting session number ".session.id." of ".session.scheduled." minutes."
    return session
endfunction

function! s:latest_session()
    if s:has_sessions()
        return s:sessions[-1]
    else
        " The first time around, create the sessions variable
        " and start the first session.
        let s:sessions = []
        return s:start_session(localtime())
endfunction

function! s:has_sessions()
    if exists('s:sessions')
        return len(s:sessions) > 0
    else
        return 0
    endif
endfunction

function! s:latest_or_new(now)
    let session = s:latest_session()
    let since_last = s:duration_minutes(a:now - session.last)
    if since_last >= session.break
        return s:start_session(a:now)
    else
        return session
    endif
endfunction

function! s:flash_statusline(msg)
    if !exists('s:statusline_set') || !s:statusline_set
        let s:statusline = &statusline
        let &statusline = '%#ErrorMsg#   '.a:msg.'%='.a:msg.'   '
        let s:statusline_set = 1
        call timer_start(1000, 'pomodoro#restore_statusline')
    endif
endfunction

function! pomodoro#restore_statusline(timer)
    let &statusline = s:statusline
    let s:statusline_set = 0
endfunction

function! s:notify(session)
    if !a:session.notified
        call s:flash_statusline("Session over, time to take a break!")
        let a:session.notified = 1
    else
        call s:warning_overtime(a:session)
    endif
endfunction

function! s:rjust(len, s, fill)
    let strlen = strdisplaywidth(a:s)
    if strlen > a:len
        return a:s
    else
        return repeat(a:fill, a:len - strlen).a:s
    endif
endfunction

function! s:ljust(len, s, fill)
    let strlen = strdisplaywidth(a:s)
    if strlen > a:len
        return a:s
    else
        return a:s.repeat(a:fill, a:len - strlen)
    endif
endfunction

function! s:total(session)
    return s:duration_minutes(a:session.duration)
endfunction

function! s:elapsed(session)
    let total = s:total(a:session)
    return min([total, a:session.scheduled])
endfunction

function! s:overtime(session)
    let total = s:total(a:session)
    return max([total - a:session.scheduled, 0])
endfunction

function! s:remaining(session)
    let total = s:total(a:session)
    return max([a:session.scheduled - total, 0])
endfunction

function! s:progress_bar(session)
    return repeat('=', s:elapsed(a:session)).repeat('.', s:remaining(a:session)).repeat('!', s:overtime(a:session))
endfunction

function! s:display_duration(session)
    let elapsed = s:elapsed(a:session)
    let overtime = s:overtime(a:session)
    let overtimestr = overtime ? "+".overtime : ""
    return elapsed.overtimestr." min"
endfunction

function! s:display_interval(session)
    let start = strftime("%T", a:session.start)
    let end = strftime("%T", a:session.last)
    return '['.start.' -> '.end.']'
endfunction

function! s:display_session(session)
    let id = s:rjust(5, a:session.id, " ")
    let duration =  s:ljust(12, s:display_duration(a:session), " ")
    let interval = s:display_interval(a:session)
    let bar = s:progress_bar(a:session)

    return id.":\t".duration."\t".interval."\t".bar
endfunction

function! s:display_sessions()
    if s:has_sessions()
        echo "\n---"
        let session = s:latest_session()
        let min = s:duration_minutes(session.duration)
        let sec = s:duration_seconds(session.duration)
        echo "You are ".min." minutes ".sec." seconds into session number ".session.id."."
        echo "---"
        echo "\nSessions:"
        for session in s:sessions
            echo s:display_session(session)
        endfor
    endif
endfunction

function! s:enabled()
    return exists('#pomodoro#CursorHold')
endfunction

function! pomodoro#sessions()
    return s:sessions
endfunction

function! s:warning_overtime(session)
    let overtime = s:overtime(a:session)
    if overtime >= 0
        let level = max([min([overtime, 1]), 10])
        let msg = repeat('!', level)
        call s:flash_statusline(msg)
    endif
endfunction

function! pomodoro#display_break_timer(timer)
    let session = s:latest_session()
    let since_last = localtime() - session.last
    let min = since_last / 60
    let sec = since_last % 60
    let current = printf("%02d:%02d", min, sec)
    let target = printf("%02d:00", session.break)
    echo 'On Break: '.current.' / '.target
endfunction

function! s:on_break()
    if exists('s:break_timer')
        return s:break_timer > 0
    else
        return 0
    endif
endfunction

function! s:start_break()
    let s:break_timer = timer_start(1000, 'pomodoro#display_break_timer', {'repeat': -1})
endfunction

function! s:stop_break()
    if s:on_break()
        let s:break_timer = timer_stop(s:break_timer)
    endif
endfunction

function! pomodoro#ping(time)
    try
        if s:on_break()
            call s:stop_break()
        endif
        let session = s:latest_or_new(a:time)

        let session.last = a:time
        let session.duration = session.last - session.start
        if s:total(session) >= session.scheduled
            call s:notify(session)
            call s:start_break()
        endif
    catch
        let msg = "Error during 'ping' (".v:exception."). Disabling pomodoro!"
        echo pomodoro#disable(msg)
    endtry
endfunction

function! pomodoro#settings()
    echo "Pomodoro Settings:"
    echo "\tSession:    ".s:session_minutes." min"
    echo "\tBreak:      ".s:break_minutes." min"
    if s:enabled()
        echo "\t[enabled]"
    else
        echo "\t[disabled]"
    endif
    call s:display_sessions()
endfunction

function! pomodoro#disable(...)
    aug pomodoro
        au!
    aug END
    return a:0 > 0 ? a:1 : "Pomodoro disabled"
endfunction

function! pomodoro#enable(...)
    aug pomodoro
        au!
        au CursorHold * call pomodoro#ping(localtime())
    aug END
    return a:0 > 0 ? a:1 : "Pomodoro enabled"
endfunction

function! pomodoro#toggle()
    if s:enabled()
        echo pomodoro#disable()
    else
        echo pomodoro#enable()
    endif
endfunction

" vim: foldmethod=indent
