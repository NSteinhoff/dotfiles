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
        \ '<line1>,<line2>!sed '
        \ ."'s/".(<q-args> == '' ? '\s\+' : '\s*<args>\s*').'/ ~<args> '."/g' "
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
    command! -range Run execute '<line1>,<line2>w !'.get(b:, 'interpreter', 'bash')

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
    command! Ctags call jobstart(['git', 'ctags'])
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
        return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log -n 25 --format=%h\ %s\ \(%ar\)')
    endfunction

    function GlobalRevisions(arglead, cmdline, curpos)
        return systemlist('git -C ' . shellescape(getcwd()) . ' log -n 25 --format=%h\ %s\ \(%ar\)')
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
    command! -nargs=+ Vimgrep
        \ execute 'vimgrep /' . <q-args> . '/j ' . expand('%')
        \| Quickfix
    command! -nargs=+ Grep
            \ execute 'grep -r --include=*.'.expand('%:e').' '.<q-args>.' .'
            \| Quickfix
    if executable('rg')
        command! -nargs=+ RipGrep
            \ cexpr! system('rg --vimgrep --smart-case '.<q-args>)
            \| Quickfix
    endif
    if executable('ag')
        command! -nargs=+ Ag
            \ cexpr! system('ag --vimgrep --smart-case '.<q-args>)
            \| Quickfix
    endif

""" Greping the help files
    command! HelpGrep tabnew | lcd $VIMRUNTIME/doc | LiveGrep
