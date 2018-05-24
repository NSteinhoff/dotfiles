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


"-------------------------- Language Server Client ----------------------------
set runtimepath+=~/.vim-plugins/LanguageClient-neovim

let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {}

if executable('pyls')
    let g:LanguageClient_serverCommands.python = ['pyls']
    augroup python_language_server
        autocmd!
        au FileType python setlocal omnifunc=LanguageClient#complete
        au FileType python nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
        au FileType python nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    augroup END
endif
