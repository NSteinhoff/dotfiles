augroup AUTO
    autocmd!
    autocmd CursorMoved * silent! checktime
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}
    autocmd BufWritePre /tmp/* setlocal noundofile
    autocmd BufWritePost init.vim,mappings.vim,options.vim source <afile>
    autocmd QuickFixCmdPre * call make#ignore_make_errors()
augroup END
