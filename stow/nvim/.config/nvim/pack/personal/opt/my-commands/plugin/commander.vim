""" Workspaces
    command! -nargs=1 -complete=dir WorkOn tabnew | lcd <args>

""" Read errorfile
    command! Cfile if !bufexists("[Command Line]")
        \ && &filetype != ''
        \ && &filetype != 'qf'
        \ && findfile(&errorfile) != ''
        \|cgetfile|cwindow|endif
    command! Cgetfile if !bufexists("[Command Line]")
        \ && &filetype != ''
        \ && &filetype != 'qf'
        \ && findfile(&errorfile) != ''
        \|cgetfile|endif

""" Format the current buffer
    function! Format()
        if &formatprg == ""
            echomsg "Abort: 'formatprg' unset"
            return
        endif
        let l:view = winsaveview()
        normal! gggqG
        if v:shell_error > 0
            silent undo
            redraw
            echomsg 'formatprg "'.&formatprg.'" exited with status '.v:shell_error
        endif
        call winrestview(l:view)
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
    function s:edit_settings(type, selected)
        let defaults = {
        \   'compiler': compiler#which(),
        \   'colors': g:colors_name,
        \}
        let selected = empty(a:selected) ? get(defaults, a:type, &ft) : a:selected

        exe 'keepj edit $HOME/.config/nvim/after/'.a:type.'/'.selected.'.vim'
    endfunction

    command! -nargs=? -complete=compiler EditCompiler call s:edit_settings('compiler', <q-args>)
    command! -nargs=? -complete=filetype EditFtplugin call s:edit_settings('ftplugin', <q-args>)
    command! -nargs=? -complete=filetype EditFtdetect call s:edit_settings('ftdetect', <q-args>)
    command! -nargs=? -complete=filetype EditSyntax call s:edit_settings('syntax', <q-args>)
    command! -nargs=? -complete=filetype EditIndent call s:edit_settings('indent', <q-args>)
    command! -nargs=? -complete=color EditColorscheme call s:edit_settings('colors', <q-args>)

""" Run lines with interpreter
    command! -range=% Run execute '<line1>,<line2>w !'.get(b:, 'interpreter', 'cat')

""" Matches
    command! -nargs=? Match execute empty(<q-args>) ? 'match Error /'.expand('<cword>').'/' : 'match Error /<args>/'
