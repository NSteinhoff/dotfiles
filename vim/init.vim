" Use same options as Vim
source ~/.vimrc

"-------------------------------- Cursorline ----------------------------------
    set cursorline                              " Highlight the line with the cursor
    " Cursorline in active window
    augroup active_window_indicator
        autocmd!
        autocmd WinEnter * set cursorline
        autocmd WinLeave * set nocursorline
    augroup END

"---------------------------------- Python ------------------------------------
    :autocmd TermOpen * setlocal statusline=%{b:term_title}
    let g:python_host_prog  = expand('~').'/.virtualenvs/nvim2/bin/python'
    let g:python3_host_prog  = expand('~').'/.virtualenvs/nvim3/bin/python'
