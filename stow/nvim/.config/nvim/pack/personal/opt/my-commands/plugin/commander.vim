""" Workspaces
    command! -nargs=? -complete=dir -bang WorkOn if <bang>1 | tab split | endif
            \ | if expand('<args>') == ''
            \ |     execute 'tcd '..getcwd(-1, -1)
            \ | else
            \ |     tcd <args> | e .
            \ | endif

""" Open with default application
    function! s:uri(s)
        return a:s == '' ? (expand('%') == '' ? getcwd() : expand('%'))
            \ : a:s == '.' ? getcwd()
            \ : a:s =~ '^https\?://[a-zA-Z0-9\-./#?=&_ ]\+$' ? escape(substitute(a:s, ' ', '%20', 'g'), '#%')
            \ : expandcmd(a:s)
    endfunction
    command -nargs=? Open silent execute '!'..(system('uname') =~? 'darwin' ? 'open' : 'xdg-open')..' '..s:uri(<q-args>)

""" Search with Duckduckgo
    command -nargs=1 DuckDuckGo Open https://duckduckgo.com/?q=<args>
    command -nargs=1 DuckDuckGoFt execute 'DuckDuckGo '..&ft..'+<args>'

""" Search DevDocs.io
    command -nargs=1 DevDocs Open https://devdocs.io/?q=<args>
    command -nargs=1 DevDocsFt execute 'DevDocs '..&ft..'+<args>'

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
    " using :pattern: instead of /pattern/ to make matching file paths easier
    command -nargs=* Broldfiles execute 'browse '..(<q-args> != '' ? 'filter :'..<q-args>..': ' : '')..'oldfiles'
    cnoreabbrev <expr> old (getcmdtype() ==# ':' && getcmdline() ==# 'old')  ? 'Broldfiles'  : 'oldfiles'

""" Format the current buffer
    function s:format()
        let formatprg = get(b:, 'formatprg', &formatprg)
        if empty(formatprg)
            echomsg "Abort: 'formatprg' unset"
            return
        endif

        let formatprg = expandcmd(escape(formatprg, '{}'))
        let lines = getline(0, '$')
        let formatted = systemlist(formatprg, lines)

        if v:shell_error > 0
            for line in formatted
                echomsg line
            endfor
            echomsg "Error: formatprg '".formatprg."' exited with status ".v:shell_error
            return
        endif

        if formatted != lines
            " Setting lines and then deleting dangling lines at the end avoids
            " jumping to the beginning of the buffer when undoing as would
            " happen with %delete -> append()
            call setline(1, formatted)
            undojoin
            call deletebufline('%', len(formatted) + 1, '$')
            silent update
        endif

        echo "Formatted buffer"
    endfunction
    command! -bar Format call s:format()

""" Fix the current buffer
    function s:fix()
        if empty(get(b:, 'fixprg', ''))
            echomsg "Abort: 'fixprg' unset"
            return
        endif

        let fixprg = expandcmd(escape(b:fixprg, '{}'))
        let lines = getline(0, '$')
        let result = systemlist(fixprg)

        if v:shell_error > 0
            echomsg "Error: fixprg '".fixprg."' exited with status ".v:shell_error
            return
        endif

        checktime
        echo "Fixed buffer"
    endfunction
    command! -bar Fix call s:fix()

""" Align text
    " Using 'sed' and 'column' external tools
    command! -nargs=? -range Align execute
        \ '<line1>,<line2>!sed -E '
        \ ."'s/".(expand('<args>') == '' ? '[[:blank:]]+' : '\s*<args>\s*').'/ ~<args> '."/g' "
        \ .'| '."column -s'~' -t"

""" Headers
    command! -nargs=? Section call commander#lib#section(<q-args>)
    command! -nargs=? Header call commander#lib#header(<q-args>)

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
    command! -range=% -bang Run if get(b:, 'interpreter', 'NONE') != 'NONE'| if <bang>0 | write | endif | execute '<line1>,<line2>w !'.get(b:, 'interpreter')|else|echo 'b:interpreter is unset'|endif

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

""" List tagfiles
    command! TagFiles echo join(tagfiles(), "\n")
