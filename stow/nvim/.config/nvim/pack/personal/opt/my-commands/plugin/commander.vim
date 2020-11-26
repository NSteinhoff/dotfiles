""" Buffers
    command! -bang BufOnly %bd<bang>|e#|bd#
    command! -nargs=? -complete=filetype Scratch new
        \ | setlocal buftype=nofile bufhidden=hide noswapfile
        \ | let &ft = <q-args>

""" Workspaces
    command! -nargs=1 -complete=dir WorkOn
        \ tabnew | lcd <args>

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
    command! -nargs=? -complete=compiler EditCompiler
        \ exe 'keepj edit $HOME/.config/nvim/after/compiler/'
        \ . (empty(<q-args>) ? compiler#which() : <q-args>)
        \ . '.vim'

    command! -nargs=? -complete=filetype EditFtplugin
        \ exe 'keepj edit $HOME/.config/nvim/after/ftplugin/'
        \ . (empty(<q-args>) ? &filetype : <q-args>)
        \ . '.vim'

    command! -nargs=? -complete=filetype EditFtdetect
        \ exe 'keepj edit $HOME/.config/nvim/after/ftdetect/'
        \ . (empty(<q-args>) ? &filetype : <q-args>)
        \ . '.vim'

    command! -nargs=? -complete=filetype EditSyntax
        \ exe 'keepj edit $HOME/.config/nvim/after/syntax/'
        \ . (empty(<q-args>) ? &filetype : <q-args>)
        \ . '.vim'

    command! -nargs=? -complete=filetype EditIndent
        \ exe 'keepj edit $HOME/.config/nvim/after/indent/'
        \ . (empty(<q-args>) ? &filetype : <q-args>)
        \ . '.vim'

    command! -nargs=? -complete=color EditColorscheme
        \ execute 'keepj edit $HOME/.config/nvim/after/colors/'
        \ . (empty(<q-args>) ? g:colors_name : <q-args>)
        \ . '.vim'

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

    " Show a diff for the current file
    command! -range Modified
        \ let modified = system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " diff -- " . expand('%:t')
        \ ) | echo modified

    " Show the state of the current file on HEAD
    command! -range Before
        \ let content = system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " show HEAD:./" . expand('%:t')
        \ ) | echo content

    function s:local_revisions(arglead, cmdline, curpos)
        return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --format=%h\ %s\ \(%ar\)')
    endfunction

    function s:global_revisions(arglead, cmdline, curpos)
        return systemlist('git -C ' . shellescape(getcwd()) . ' log --format=%h\ %s\ \(%ar\)')
    endfunction

    command! -nargs=? -complete=customlist,<SID>local_revisions ChangeSplit
        \ let ft = &ft
        \| let ref = (<q-args> != '' ? split(<q-args>)[0] : 'HEAD')
        \| let commit = (<q-args> != '' ? <q-args> : 'HEAD')
        \| let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' show '.ref.':./' . expand('%:t'))
        \| mark Z
        \| topleft vnew | call append(0, content) | $delete
        \| execute 'file '.commit | set buftype=nofile | set bufhidden=wipe | set nobuflisted | set noswapfile | let &ft=ft
        \| nnoremap <buffer> q :q<CR>`Z
        \| diffthis | wincmd p | diffthis | wincmd p

    command! -nargs=? -complete=customlist,<SID>local_revisions ChangePatch
        \ let ref = (<q-args> != '' ? split(<q-args>)[0] : 'HEAD')
        \| let commit = (<q-args> != '' ? <q-args> : 'HEAD')
        \| let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' diff '.ref.' -- ' . expand('%:t'))
        \| enew | call append(0, content) | $delete
        \| execute 'file '.commit | set buftype=nofile | set bufhidden=wipe | set nobuflisted | set noswapfile | set ft=diff
        \| nnoremap <buffer> q :b#<CR> | wincmd p

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

    command ChangedFiles :call <SID>set_changed_args()

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
        \|silent redraw | endif

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
