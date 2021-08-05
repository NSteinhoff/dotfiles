augroup my-settings
    autocmd!
    autocmd BufWritePost vimrc,.vimrc,init.vim source <afile>
augroup END

augroup my-autoread
    autocmd!
    autocmd CursorMoved * silent! checktime
augroup END

" augroup my-tmux-window-name
"     autocmd!
"     autocmd FocusGained,VimEnter,WinEnter,DirChanged * if exists('$TMUX') && executable('tmux')
"             \| silent! execute "!tmux rename-window "..shellescape('  '..fnamemodify(getcwd(), ':t'))
"             \| endif
"     autocmd VimLeave,FocusLost * if exists('$TMUX') && executable('tmux')
"             \| silent! execute '!tmux set-option -w automatic-rename on'
"             \| endif
" augroup END

function s:update_dir()
    if !v:event.changed_window && v:event.scope == 'global'
        let g:current_dir = v:event.cwd
    endif
endfunction

augroup my-working-directories
    autocmd!
    autocmd DirChanged * call s:update_dir()
    autocmd VimEnter * let g:current_dir = getcwd()
augroup END

augroup my-sessions
    autocmd!
    autocmd VimEnter * if v:argv == ['nvim'] && findfile('Session.vim') != ''
                \| source Session.vim
                \| let g:auto_session=1
                \| echom "Resuming session from "..strftime("%c", getftime('Session.vim')..".")
                \| endif
    autocmd VimLeave * if exists('g:auto_session') && fnamemodify(v:this_session, ':t') == 'Session.vim' | mksession! | endif
augroup END
