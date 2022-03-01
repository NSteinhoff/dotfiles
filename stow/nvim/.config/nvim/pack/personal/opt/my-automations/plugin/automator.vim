augroup my-automations
    autocmd!
    autocmd BufWritePost vimrc,.vimrc,init.vim source <afile>
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}
    autocmd CursorMoved * silent! checktime

    " Automatic session loading
    autocmd VimEnter * if v:argv == ['nvim'] && findfile('Session.vim', ',,') != ''
                \| source Session.vim
                \| let g:auto_session=1
                \| echom "Resuming session from "..strftime("%c", getftime('Session.vim')..".")
                \| endif
    autocmd VimLeave * if exists('g:auto_session') && fnamemodify(v:this_session, ':t') == 'Session.vim'
                \| mksession!
                \| endif
augroup END
