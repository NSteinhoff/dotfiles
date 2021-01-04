augroup my-settings
    autocmd!
    " Source this file on write
    if has('nvim')
        autocmd BufWritePost init.vim source <afile>
    else
        autocmd BufWritePost vimrc,.vimrc source <afile>
    endif
augroup END

augroup my-errorfiles
    autocmd!
    " Set the compiler to the root of an errorfile
    " sbt.err -> :compiler sbt
    " flake8.err -> :compiler flake8
    autocmd BufReadPost *.err
        \ if expand("<afile>:r") != 'errors'
        \|execute "compiler ".expand("<afile>:r")|cgetbuffer|endif
    " Update the quickfix list when it is read from an errorfile (title == :cfile | :cgetfile)
    " Only update if the file is newer than the quickfix list.
    autocmd CursorHold *
        \ if !bufexists("[Command Line]")
        \ && get(b:, 'current_compiler', get(g:, 'current_compiler', 'NONE')) != 'NONE'
        \ && (getqflist({'title': 1}).title =~ ':c\(get\)\?file' || getqflist({'title': 1}).title == '')
        \ && findfile(&errorfile) != ''
        \ && getftime(&errorfile) > get(g:, 'cfile_updated', 0)
        \|cgetfile|let g:cfile_updated=localtime()
        \|if len(getqflist()) == 0|cclose|else|copen|wincmd p|endif
        \|echo "Quickfix list updated"
        \|endif
    autocmd!
augroup END

augroup my-automake
    let g:automake = 1
    autocmd!
    if exists(":Format")
        autocmd BufWritePre  * if get(g:, 'automake', 0) && get(b:, 'format_on_write', 0) | silent Format | endif
    endif
    if exists(":Make")
        autocmd BufWritePost * if get(g:, 'automake', 0) && get(b:, 'make_on_write', 0)   | silent Make | endif
    endif
augroup END

augroup my-autoread
    autocmd!
    " check for file modification and trigger realoading
    autocmd CursorMoved * silent! checktime
augroup END

augroup my-ctags
    autocmd!
    " autocmd BufWritePost * if finddir('.git', ';') != '' | call jobstart(['git', 'ctags']) | endif
augroup END

augroup tmux-window-name
    autocmd!
    autocmd FocusGained,VimEnter,WinEnter,DirChanged * if exists('$TMUX') && executable('tmux')
            \| silent! execute "!tmux rename-window ".shellescape('  '.fnamemodify(getcwd(), ':t'))
            \| endif
    autocmd VimLeave,FocusLost * if exists('$TMUX') && executable('tmux')
            \| silent! execute '!tmux set-option -w automatic-rename on'
            \| endif
augroup END

function s:track_changes(off)
    if a:off
        augroup my-arg-changes
            autocmd!
        augroup END
        augroup! my-arg-changes
        echo "No longer tracking changed files in the argslist."
    else
        augroup my-arg-changes
            autocmd!
            autocmd VimEnter * ChangedFiles
            autocmd DirChanged * ChangedFiles
            autocmd BufWritePost * ChangedFiles
        augroup END
        ChangedFiles
        echo "Now tracking changed files in the argslist."
    endif
endfunction

command! -bang TrackChanges call <SID>track_changes(expand("<bang>") == '!')
