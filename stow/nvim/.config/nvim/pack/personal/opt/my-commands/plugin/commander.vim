""" Buffers
    command! -bang BufOnly %bd<bang>|e#|bd#

    function s:scratch(ft, mods)
        let ft = a:ft != '' ? a:ft : &ft
        execute a:mods =~ 'vertical' ? 'vnew' : 'new'
        let &ft = ft
        setlocal buftype=nofile bufhidden=hide noswapfile
    endfunction
    command! -nargs=? -complete=filetype Scratch call s:scratch(<q-args>, '<mods>')

""" Workspaces
    command! -nargs=1 -complete=dir WorkOn tabnew | lcd <args>

""" Read errorfile
    command! Cfile if !bufexists("[Command Line]")
        \ && &filetype != ''
        \ && &filetype != 'qf'
        \ && findfile(&errorfile) != ''
        \|cgetfile|let g:cfile_updated=localtime()|cwindow|endif
    command! Cgetfile if !bufexists("[Command Line]")
        \ && &filetype != ''
        \ && &filetype != 'qf'
        \ && findfile(&errorfile) != ''
        \|cgetfile|let g:cfile_updated=localtime()|endif

""" Format the current buffer
    function! Format()
        if &formatprg == ""
            echo "Abort: 'formatprg' unset"
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

""" Commenting lines
    command! -range ToggleCommented call commander#lib#toggle_comment(<line1>, <line2>)

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
    command! -range Run execute '<line1>,<line2>w !'.get(b:, 'interpreter', 'cat')

""" Git
    " Show the commits that modified the selected lines
    command! -range -bang ButWhy
        \ echo system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " log -L <line1>,<line2>:" . expand('%:t')
        \ . (<q-bang> != '!' ? ' --no-patch --oneline' : '')
        \ )

    " Show the author who last changed the selected line
    command! -range Blame
        \ echo system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " blame -L <line1>,<line2> " . expand('%:t')
        \ )

    " Regenerate the git ctags kept under .git/tags
    command! Ctags if finddir('.git', ';') != ''
        \| call jobstart(['git', 'ctags']) | else
        \| echo "'".getcwd()."' is not a git repository. Can only run Ctags from within a git repository." | endif

    function s:local_revisions(...)
        return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --format=%h\ %s\ \(%ar\)')
    endfunction

    function s:global_revisions(...)
        return systemlist('git -C ' . shellescape(getcwd()) . ' log --format=%h\ %s\ \(%ar\)')
    endfunction

    function s:file_revisions(...)
        return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --no-patch --format=%h\ %s\ \(%ar\) -- ' . expand('%:t'))
    endfunction

    function s:load_diff_in_split(revision)
        let ft = &ft
        let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
        let commit = (a:revision != '' ? a:revision : 'HEAD')
        let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' show '.ref.':./' . expand('%:t'))
        mark Z
        topleft vnew | call append(0, content) | $delete
        execute 'file '.commit | set buftype=nofile | set bufhidden=wipe | set nobuflisted | set noswapfile | let &ft=ft
        nnoremap <buffer> q :q<CR>`Z
        diffthis | wincmd p | diffthis | wincmd p
    endfunction

    function s:load_patch(revision)
        let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
        let commit = (a:revision != '' ? a:revision : 'HEAD')
        let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' diff '.ref.' -- ' . expand('%:t'))
        enew | call append(0, content) | $delete
        execute 'file '.commit | set buftype=nofile | set bufhidden=wipe | set nobuflisted | set noswapfile | set ft=diff
        nnoremap <buffer> q :b#<CR> | wincmd p
    endfunction

    command! Timeline echo join(s:file_revisions(), "\n")
    command! -nargs=? -complete=customlist,s:file_revisions ChangeSplit call s:load_diff_in_split(<q-args>)
    command! -nargs=? -complete=customlist,s:file_revisions ChangePatch call s:load_patch(<q-args>)

    function s:set_changed_args()
        let cwd = getcwd()
        let gitdir = finddir('.git', ';')
        if gitdir == ''
            return
        endif
        let gitroot = fnamemodify(gitdir, ':h')
        let changed = systemlist('git diff --name-only -- .')
        let absolute = map(changed, { k, v -> gitroot.'/'.v })
        let relative = map(absolute, { k, v ->
                    \ match(v, cwd) ? strcharpart(v, matchend(v, cwd) + 1) : v
                    \ })
        let filepaths = filter(relative, { k, v -> findfile(v) != '' })
        %argd
        for path in filepaths
            execute 'argadd '.path
        endfor
    endfunction

    command ChangedFiles :call s:set_changed_args()

""" Searching
    " Search locally in the buffer and put results in the loclist.
    command! -nargs=+ Vimgrep execute 'lvimgrep /' . <q-args> . '/j ' . expand('%')
    command! -nargs=+ Grep cexpr system('grep -n -r '.<q-args>.' .')
    command! -nargs=+ GitGrep cexpr system('git grep -n '.<q-args>)
    if executable('rg')
        command! -nargs=+ RipGrep cexpr system('rg --vimgrep --smart-case '.<q-args>)
    endif

""" Run command in tmux split without stealing focus
    command! -bar Make silent TMake!

    command! -count=50 -nargs=+ -bang TSplit
        \ silent execute '!tmux '
        \.(expand('<bang>') == '!' ? 'new-window -n <q-args> ' : 'split-window -f -l <count>\% '
        \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
        \.' -d -c '.getcwd().' '.shellescape(<q-args>)
        \|silent redraw

    command! -count=50 -nargs=* -bang TMake
        \ silent call commander#tmake#kill_window(commander#tmake#makeprg(<q-args>))
        \|silent execute '!tmux '
        \.(expand('<bang>') == '!' ? 'new-window -n '''.commander#tmake#makeprg(<q-args>).''' ' : 'split-window -f -l <count>\% '
        \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
        \.' -d -c '.getcwd().' '.commander#tmake#shell_cmd(<q-args>)
        \|silent redraw

    command! -count=50 -bang TTailErr
        \ if findfile(&errorfile) != ''
        \|silent execute '!tmux '
        \.(expand('<bang>') == '!' ? 'new-window' : 'split-window -f -l <count>\% '
        \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
        \.' -d -c '.getcwd().' '.shellescape('tail -F '.&errorfile)
        \|silent redraw | endif
