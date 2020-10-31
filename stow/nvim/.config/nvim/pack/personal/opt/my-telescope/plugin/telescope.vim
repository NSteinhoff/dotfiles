packadd! popup.nvim
packadd! plenary.nvim
packadd! telescope.nvim

" Search over files in your cwd current working directory.
command Find lua require'telescope.builtin'.find_files{}
command GitFiles lua require'telescope.builtin'.git_files{}
command Config lua require'telescope.builtin'.find_files{ cwd = "~/.config/nvim/" }

function s:find()
    if finddir('.git', ';') == ''
        Find
    else
        GitFiles
    endif
endfunction

nnoremap <c-p> <cmd>call <SID>find()<CR>

" Live grep through all files using ripgrep
if executable('rg')
    command! LiveGrep lua require'telescope.builtin'.live_grep{}
    nnoremap <c-g> <cmd>LiveGrep<CR>
endif

command Oldfiles lua require'telescope.builtin'.oldfiles{}<Cr>
command Quickfix lua require'telescope.builtin'.quickfix{}<Cr>
command Loclist lua require'telescope.builtin'.loclist{}<Cr>
command Commands lua require'telescope.builtin'.command_history{}<Cr>
