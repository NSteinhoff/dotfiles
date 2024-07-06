augroup AUTO
    autocmd!
    autocmd BufWritePost vimrc,.vimrc,init.vim source <afile>
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}
    autocmd CursorMoved * silent! checktime
    autocmd QuickFixCmdPre * call make#ignore_make_errors()
    " autocmd BufWritePost * call tags#refresh_buf(expand("<afile>"))
    " autocmd CursorHold *.[ch] ++nested call preview#preview_word('')
augroup END
