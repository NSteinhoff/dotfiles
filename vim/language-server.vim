" LANGUAGE SERVER CLIENT
" ----------------------
set runtimepath+=~/.vim-plugins/LanguageClient-neovim

let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 1
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_diagnosticsList = "Location"

if executable('pyls')
    let g:LanguageClient_serverCommands.python = ['pyls']
    augroup python_language_server
        autocmd!
        au FileType python setlocal omnifunc=LanguageClient#complete
        au FileType python setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
        au FileType python nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
        au FileType python nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    augroup END
endif
