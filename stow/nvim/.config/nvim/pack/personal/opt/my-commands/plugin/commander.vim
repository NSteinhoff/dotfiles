""" Note-Taking and Journaling
    function! s:notes_dir()
        return expand(get(g:, 'notes_dir', get(environ(), 'NOTES_DIR', '~/notes')))
    endfunction
    function! s:complete_note(arglead, cmdline, cursorpos)
        let dir = s:notes_dir()
        let paths = filter(globpath(dir, '**/'..a:arglead..'*', 1, 1), { _, p -> filereadable(p) })
        let relpaths = map(paths, { _, p -> substitute(p, '^'..dir..'/\?', '', '') })
        return relpaths
    endfunction
    command! -nargs=? -complete=customlist,<sid>complete_note Note execute '<mods> edit '..s:notes_dir()..'/<args>'
    command! Journal Note journal.md

""" Headers
    command! -nargs=? Section call commander#lib#section(<q-args>)
    command! -nargs=? Header call commander#lib#header(<q-args>)

""" Run lines with interpreter
    command! -range=% -bang Run if get(b:, 'interpreter', 'NONE') != 'NONE'| if <bang>0 | write | endif | execute '<line1>,<line2>w !'.get(b:, 'interpreter')|else|echo 'b:interpreter is unset'|endif

""" Send paragraph under cursor to terminal
    function! s:send_to_term()
        if mode() == 'n'
            exec "normal mk\"vyip"
        elseif mode() =~ '[Vv]'
            exec "normal gv\"vy"
        endif

        if !exists("g:last_terminal_chan_id")
            vsplit
            terminal
            let g:last_terminal_chan_id = b:terminal_job_id
            au BufDelete <buffer> unlet g:last_terminal_chan_id
            wincmd p
        endif

        if getreg('"v') =~ "^\n"
            call chansend(g:last_terminal_chan_id, expand("%:p")."\n")
        else
          call chansend(g:last_terminal_chan_id, @v)
        endif

        exec "normal `k"
    endfunction

    command! SendToTerm call s:send_to_term()

""" List tagfiles
    command! TagFiles echo join(tagfiles(), "\n")
