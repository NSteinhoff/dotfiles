let s:dir = getenv("NOTES_DIR")
if s:dir == v:null
    echoerr "Unable to create note-taking commands: '$NOTES_DIR' unset!"
    finish
endif

function s:open_note(in_same_window, mods, fpath)
    let path = fnamemodify(s:dir."/".a:fpath, ":p")
    let winnr = bufwinnr(bufnr(a:fpath))
    if winnr == -1
        execute a:mods..' '..(a:in_same_window ? 'edit' : 'split')..' +set\ nobuflisted '..path
    else
        execute winnr .. 'wincmd w'
    endif
endfunction

function s:complete(arglead, cmdline, cursorpos)
    return globpath(s:dir, a:arglead.'*', 1, 1)->map({_, v -> substitute(v, s:dir."/", "", "")})
endfunction

command! -bang -bar -nargs=1 -complete=customlist,s:complete Note call s:open_note(<bang>0, '<mods>', <q-args>)
command! -bang -bar Journal call s:open_note(<bang>0, '<mods>', 'journal.md')
command! -bang -bar Todo call s:open_note(<bang>0, '<mods>', 'todo.taskpaper')
command! -bang -bar Dev call s:open_note(<bang>0, '<mods>', 'dev.md')
