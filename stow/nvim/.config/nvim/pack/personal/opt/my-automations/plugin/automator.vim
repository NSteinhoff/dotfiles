augroup my-settings
    autocmd!
    autocmd BufWritePost vimrc,.vimrc,init.vim source <afile>
augroup END

augroup my-autoread
    autocmd!
    autocmd CursorMoved * silent! checktime
augroup END

augroup my-tmux-window-name
    autocmd!
    autocmd FocusGained,VimEnter,WinEnter,DirChanged * if exists('$TMUX') && executable('tmux')
            \| silent! execute "!tmux rename-window ".shellescape('  '.fnamemodify(getcwd(), ':t'))
            \| endif
    autocmd VimLeave,FocusLost * if exists('$TMUX') && executable('tmux')
            \| silent! execute '!tmux set-option -w automatic-rename on'
            \| endif
augroup END

augroup my-sessions
    autocmd!
    autocmd VimEnter * if findfile('Session.vim') != ''
                \| source Session.vim
                \| echom "Resuming session from ".strftime("%c", getftime('Session.vim').".")
                \| endif
augroup END

augroup my-changed-files
    autocmd!
    autocmd VimEnter * ChangedFilesOnStartup
    autocmd VimResume,FocusGained * ChangedFiles
    autocmd DirChanged * ChangedFiles
    autocmd BufWritePost * ChangedFiles
augroup END
