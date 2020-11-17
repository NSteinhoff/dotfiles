""" Buffers
    command! -bang BufOnly %bd<bang>|e#|bd#
    command! -nargs=? -complete=filetype Scratch new
        \ | setlocal buftype=nofile bufhidden=hide noswapfile
        \ | let &ft = <q-args>

""" Workspaces
command! -nargs=1 -complete=dir WorkOn
        \ tabnew | lcd <args>

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
    command! -range ToggleCommented <line1>,<line2> call commander#lib#toggle_commented()

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
    command! -nargs=+ GitGrep cexpr! system('git grep -n '.<q-args>)
        \| Quickfix
    command! -range -bang ButWhy
        \ echo system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " log -L <line1>,<line2>:" . expand('%:t')
        \ . (<q-bang> != '!' ? ' --no-patch --oneline' : '')
        \ )
    command! -range Blame
        \ echo system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " blame -L <line1>,<line2> " . expand('%:t')
        \ )
    command! -bar -nargs=+ Jump
        \ cexpr! system('git jump ' . expand(<q-args>))
        \| Quickfix
    command! Ctags if finddir('.git', ';') != ''
        \| call jobstart(['git', 'ctags']) | else
        \| echo "'".getcwd()."' is not a git repository. Can only run Ctags from within a git repository." | endif
    command! -range Modified
        \ let modified = system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " diff -- " . expand('%:t')
        \ ) | echo modified

    command! -range Before
        \ let content = system(
        \ "git -C " . shellescape(expand('%:p:h'))
        \ . " show HEAD:./" . expand('%:t')
        \ ) | echo content

    function LocalRevisions(arglead, cmdline, curpos)
        return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --format=%h\ %s\ \(%ar\)')
    endfunction

    function GlobalRevisions(arglead, cmdline, curpos)
        return systemlist('git -C ' . shellescape(getcwd()) . ' log --format=%h\ %s\ \(%ar\)')
    endfunction

    command! -nargs=? -complete=customlist,LocalRevisions ChangeSplit
        \ let ft = &ft
        \| let ref = (<q-args> != '' ? split(<q-args>)[0] : 'HEAD')
        \| let commit = (<q-args> != '' ? <q-args> : 'HEAD')
        \| let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' show '.ref.':./' . expand('%:t'))
        \| topleft vnew | call append(0, content) | $delete
        \| execute 'file '.commit | set buftype=nofile | set bufhidden=wipe | set nobuflisted | set noswapfile | let &ft=ft
        \| nnoremap <buffer> q :q<CR>
        \| diffthis | wincmd p | diffthis

    command! -nargs=? -complete=customlist,LocalRevisions ChangePatch
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

    if executable('rg')
        command! -nargs=+ RipGrep cexpr system('rg --vimgrep --smart-case '.<q-args>)
    endif

""" Run command in tmux split without stealing focus
    function s:makeprg(qargs) abort
        if &makeprg =~ '$\*'
            let makeprg = substitute(&makeprg, '$\*', a:qargs, '')
        else
            let makeprg = &makeprg.' '.a:qargs
        endif
        return substitute(makeprg, '%', expand('%'), '')
    endfunction

    function s:shell_cmd(qargs) abort
        let makeprg = s:makeprg(a:qargs)
        let tempfile = tempname()
        return 'echo '.shellescape(makeprg).' && '.makeprg.' '.&shellpipe.' '.tempfile.'; mv '.tempfile.' '.&errorfile.'; sleep 2'
    endfunction

    command! -bar Make TMake!

    command! -count=50 -nargs=+ -bang TSplit silent execute
        \ '!tmux '.(expand('<bang>') == '!' ? 'new-window -n <q-args> ' : 'split-window -f -l <count>\% '
        \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
        \.' -d -c '.getcwd().' '.shellescape(<q-args>)
        \| redraw
    command! -count=50 -nargs=* -bang TMake silent execute
        \ '!tmux '.(expand('<bang>') == '!' ? 'new-window -n '''.s:makeprg(<q-args>).''' ' : 'split-window -f -l <count>\% '
        \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
        \.' -d -c '.getcwd().' '.shellescape(s:shell_cmd(<q-args>))
        \| redraw
    command! -count=50 -bang TTailErr if findfile(&errorfile) != ''| silent execute
        \ '!tmux '.(expand('<bang>') == '!' ? 'new-window' : 'split-window -f -l <count>\% '
        \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
        \.' -d -c '.getcwd().' '.shellescape('tail -F '.&errorfile)
        \| redraw | endif
