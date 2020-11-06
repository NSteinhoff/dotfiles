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
    autocmd BufReadPost *.err execute "compiler ".expand("<afile>:r") | cgetbuffer
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


function s:track_changes(bang)
    augroup user-arg-changes
        autocmd!
        if !a:bang
            echo "Now tracking changed files in the argslist."
            ChangedFiles
            autocmd VimEnter * ChangedFiles
            autocmd DirChanged * ChangedFiles
            autocmd BufWritePost * ChangedFiles
        else
            echo "No longer tracking changed files in the argslist."
        endif
    augroup END
endfunction

command -bang TrackChanges call <SID>track_changes(expand("<bang>") == '!')
" vim:foldmethod=marker textwidth=0
