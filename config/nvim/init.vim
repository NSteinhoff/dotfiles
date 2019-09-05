" vim:foldmethod=marker

" Use same options as Vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

"-------------------------------- Cursorline ----------------------------------{{{
set cursorline                              " Highlight the line with the cursor
" Cursorline in active window
augroup active_window_indicator
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END
"}}}

"---------------------------------- Provider ------------------------------------{{{
:autocmd TermOpen * setlocal statusline=%{b:term_title}
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog  = expand('~').'/.pyenv/versions/py3nvim/bin/python'
let g:node_host_prog = expand('~').'/.nvm/versions/node/v12.10.0/bin/neovim-node-host'
" }}}
