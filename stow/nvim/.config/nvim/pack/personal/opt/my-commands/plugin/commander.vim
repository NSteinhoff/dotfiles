""" Workspaces
    command! -nargs=1 -complete=dir WorkOn tabnew | tcd <args>

""" Open with default application
    command! -nargs=? -complete=file Open execute '!'..(system('uname') =~? 'darwin' ? 'open' : 'xdg-open')..' '..(<q-args> == '' ? '%' : expandcmd(<q-args>))

""" Format the current buffer
    function Format()
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
    command! -bar Format call Format()

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
    command! -nargs=1 -complete=compiler CompileWith call compiler#with(<f-args>)

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

""" Matches
    command! -nargs=? Match execute 'match Error /\<'..(empty(<q-args>) ? expand('<cword>')..'\>' : '<args>').'/'
    command! -nargs=? Match2 execute '2match Constant /\<'..(empty(<q-args>) ? expand('<cword>')..'\>' : '<args>').'/'
    command! -nargs=? Match3 execute '3match Todo /\<'..(empty(<q-args>) ? expand('<cword>')..'\>' : '<args>').'/'
    command! MatchOff match | 2match | 3match
