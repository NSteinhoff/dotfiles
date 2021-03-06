""" Workspaces
    command! -nargs=1 -complete=dir WorkOn tabnew | tcd <args>

""" Open with default application
    function! s:uri(s)
        return a:s == '' ? (expand('%') == '' ? getcwd() : expand('%'))
            \ : a:s == '.' ? getcwd()
            \ : a:s =~ '^https\?://[a-zA-Z0-9\-./#?=&_]\+$' ? escape(a:s, '#%')
            \ : expandcmd(a:s)
    endfunction
    command! -nargs=? Open silent execute '!'..(system('uname') =~? 'darwin' ? 'open' : 'xdg-open')..' '..s:uri(<q-args>)

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

""" Insert dummy text
    command! -count=10 -bang Lorem call commander#lorem#insert(<count>, <bang>0)

""" Browse old files
    command -nargs=* Broldfiles execute 'browse '..(<q-args> != '' ? 'filter :'..<q-args>..': ' : '')..'oldfiles'

""" Show global marks
    command -nargs=* Marks execute 'try | '(<q-args> != '' ? 'filter :'..<q-args>..':' : '')..' marks ABCDEFGHIJKLMNOPQRSTUVWXYZ | catch | endtry'
    command -nargs=* -bang Delmarks execute 'delmarks '..(<bang>0 ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : <q-args>)

""" Format the current buffer
    function s:format()
        if empty(&formatprg)
            echomsg "Abort: 'formatprg' unset"
            return
        endif
        let formatprg = expandcmd(&formatprg)
        let lines = getline(0, '$')
        let formatted = systemlist(formatprg, lines)
        if v:shell_error > 0
            echomsg "Error: formatprg '".formatprg."' exited with status ".v:shell_error
        elseif formatted == lines
            echo "Already formatted"
        else
            " Setting lines and then deleting dangling lines at the end avoids
            " jumping to the beginning of the buffer when undoing as would
            " happen with %delete -> append()
            call setline(1, formatted)
            undojoin
            call deletebufline('%', len(formatted) + 1, '$')
            echo "Formatted buffer"
        endif
    endfunction
    command! -bar Format call s:format()

""" Align text
    " Using 'sed' and 'column' external tools
    command! -nargs=? -range Align execute
        \ '<line1>,<line2>!sed -E '
        \ ."'s/".(expand('<args>') == '' ? '[[:blank:]]+' : '\s*<args>\s*').'/ ~<args> '."/g' "
        \ .'| '."column -s'~' -t"

""" Headers
    command! -nargs=? Section call commander#lib#section(<q-args>)
    command! -nargs=? Header call commander#lib#header(<q-args>)

""" Compiler
    command! Compiler call compiler#describe()
    command! -nargs=1 -bang -complete=compiler CompileWith call compiler#with(<bang>0, <f-args>)

""" Edit my filetype/syntax plugin files for current filetype.
    function s:edit_settings(type, selected, mods)
        let defaults = {
        \   'compiler': compiler#which(),
        \   'colors': g:colors_name,
        \}
        let selected = empty(a:selected) ? get(defaults, a:type, &ft) : a:selected

        exe 'keepj '..a:mods..(a:mods =~ 'vert\|tab' ? ' split' : ' edit')..' $HOME/.config/nvim/after/'.a:type.'/'.selected.'.vim'
    endfunction

    command! -nargs=? -complete=compiler EditCompiler call s:edit_settings('compiler', <q-args>, <q-mods>)
    command! -nargs=? -complete=filetype EditFtplugin call s:edit_settings('ftplugin', <q-args>, <q-mods>)
    command! -nargs=? -complete=filetype EditFtdetect call s:edit_settings('ftdetect', <q-args>, <q-mods>)
    command! -nargs=? -complete=filetype EditSyntax call s:edit_settings('syntax', <q-args>, <q-mods>)
    command! -nargs=? -complete=filetype EditIndent call s:edit_settings('indent', <q-args>, <q-mods>)
    command! -nargs=? -complete=color EditColorscheme call s:edit_settings('colors', <q-args>, <q-mods>)

""" Run lines with interpreter
    command! -range=% Run execute '<line1>,<line2>w !'.get(b:, 'interpreter', 'cat')

""" Clear error lists
    command! -bar ClearQf call setqflist([], 'f')
    command! -bar ClearLoc call setloclist(0, [], 'f')
    command! -bar ClearErr ClearQf | ClearLoc

""" Matches
    command! -nargs=? Match execute 'match Error /'..(empty(<q-args>) ? '\<'..expand('<cword>')..'\>' : escape(<q-args>, '/')).'/'
    command! -nargs=? Match2 execute '2match Todo /'..(empty(<q-args>) ? '\<'..expand('<cword>')..'\>' : escape(<q-args>, '/')).'/'
    command! MatchOff match | 2match

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
