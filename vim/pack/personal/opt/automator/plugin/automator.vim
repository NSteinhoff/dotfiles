augroup user-settings "{{{
    autocmd!
    " Source this file on write
    autocmd BufWritePost init.vim source <afile>
augroup END "}}}
augroup user-errorfiles "{{{
    autocmd!
    " Set the compiler to the root of an errorfile
    " sbt.err -> :compiler sbt
    " flake8.err -> :compiler flake8
    autocmd BufReadPost *.err execute "compiler ".expand("<afile>:r") | cgetbuffer
augroup END "}}}
augroup user-automake "{{{
    autocmd!
    autocmd BufWritePre  * if get(b:, 'format_on_write', 0) | Format | endif
    autocmd BufWritePost * if get(b:, 'make_on_write', 0)   | Make   | endif
augroup END "}}}

" vim:foldmethod=marker textwidth=0
