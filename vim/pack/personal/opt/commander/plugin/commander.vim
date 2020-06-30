"--- Special buffers{{{
command! -nargs=? -complete=filetype Scratch new
    \ | setlocal buftype=nofile bufhidden=hide noswapfile
    \ | let &ft = <q-args>
"}}}

"--- Format the current buffer{{{
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
"}}}

"--- Make{{{
function! Make(bang)
    execute 'silent make'.a:bang
    cwindow
endfunction
command! -bar -bang Make call Make("<bang>")
"}}}

"--- Align text{{{
" Using 'sed' and 'column' external tools
command! -nargs=? -range Align execute
    \ '<line1>,<line2>!sed '
    \ ."'s/".(<q-args> == '' ? '\s\+' : '\s*<args>\s*').'/ ~<args> '."/g' "
    \ .'| '."column -s'~' -t"
"}}}

"--- Headers{{{
command! -nargs=? Section call commander#lib#section(<q-args>)
command! -nargs=? Header call commander#lib#header(<q-args>)
"}}}

"--- Commenting lines{{{
command! -range ToggleCommented <line1>,<line2> call commander#lib#toggle_commented()
"}}}

"--- Compiler{{{
command! Compiler call compiler#describe()
command! -nargs=1 -complete=compiler CompileWith call compiler#with(<f-args>)
"}}}

"--- Edit my filetype/syntax plugin files for current filetype.{{{
command! -nargs=? -complete=compiler EditCompiler
    \ exe 'keepj edit $HOME/.config/nvim/after/compiler/'
    \ . (empty(<q-args>) ? compiler#which() : <q-args>)
    \ . '.vim'

command! -nargs=? -complete=filetype EditFiletype
    \ exe 'keepj edit $HOME/.config/nvim/after/ftplugin/'
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
"}}}

"--- Run lines with interpreter{{{
command! -range Run execute '<line1>,<line2>w !'.get(b:, 'interpreter', 'bash')
"}}}

"--- Git{{{
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
    \ cexpr system('git jump ' . expand(<q-args>))
command! Ctags call jobstart(['git', 'ctags'])
"}}}

"--- Searching{{{
if executable('rg')
    command! -nargs=+ Rg cexpr system('rg --vimgrep --smart-case '.<q-args>)
endif
if executable('ag')
    command! -nargs=+ Ag cexpr system('ag --vimgrep --smart-case '.<q-args>)
endif
"}}}

" vim:foldmethod=marker textwidth=0
