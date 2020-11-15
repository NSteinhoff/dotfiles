augroup user-settings
    autocmd!
    " Source this file on write
    if has('nvim')
        autocmd BufWritePost init.vim source <afile>
    else
        autocmd BufWritePost vimrc,.vimrc source <afile>
    endif
augroup END

augroup user-errorfiles
    autocmd!
    " Set the compiler to the root of an errorfile
    " sbt.err -> :compiler sbt
    " flake8.err -> :compiler flake8
    autocmd BufReadPost *.err if expand("<afile>:r") != 'errors' | execute "compiler ".expand("<afile>:r") | cgetbuffer | endif
    " autocmd CursorHold * if !bufexists("[Command Line]") && findfile(&errorfile) != '' | cgetfile | endif
augroup END

augroup user-automake
    autocmd!
    if exists(":Format")
        autocmd BufWritePre  * if get(b:, 'format_on_write', 0) | Format | endif
    endif
    if exists(":Make")
        autocmd BufWritePost * if get(b:, 'make_on_write', 0)   | Make   | endif
    endif
augroup END

augroup user-autoread
    autocmd!
    " check for file modification and trigger realoading
    autocmd CursorHold * silent! checktime
augroup END

augroup user-ctags
    autocmd!
    autocmd BufWritePost * if finddir('.git', ';') != '' | call jobstart(['git', 'ctags']) | endif
augroup END


function s:track_changes(off)
    if a:off
        augroup user-arg-changes
            autocmd!
        augroup END
        augroup! user-arg-changes
        echo "No longer tracking changed files in the argslist."
    else
        augroup user-arg-changes
            autocmd!
            autocmd VimEnter * ChangedFiles
            autocmd DirChanged * ChangedFiles
            autocmd BufWritePost * ChangedFiles
        augroup END
        ChangedFiles
        echo "Now tracking changed files in the argslist."
    endif
endfunction

command -bang TrackChanges call <SID>track_changes(expand("<bang>") == '!')
" vim:foldmethod=marker textwidth=0
