augroup AUTO
    autocmd!
    autocmd CursorMoved * silent! checktime
    autocmd BufWritePost init.vim,mappings.vim source <afile>
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}
    autocmd QuickFixCmdPre * call make#ignore_make_errors()
augroup END
