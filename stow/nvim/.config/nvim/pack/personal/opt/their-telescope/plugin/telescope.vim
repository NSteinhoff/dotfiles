packadd popup.nvim
packadd plenary.nvim
packadd telescope.nvim

nnoremap <c-p> <cmd>lua require'telescope.builtin'.find_files{}<CR>

command FindFiles lua require'telescope.builtin'.find_files{}
command GitFiles lua require'telescope.builtin'.git_files{}
command Config lua require'telescope.builtin'.find_files{ cwd = "~/.config/nvim/" }
command Dotfiles lua require'telescope.builtin'.find_files{ cwd = "~/dev/dotfiles/" }
command Oldfiles lua require'telescope.builtin'.oldfiles{}<Cr>
command Quickfix lua require'telescope.builtin'.quickfix{}<Cr>
command Loclist lua require'telescope.builtin'.loclist{}<Cr>
command History lua require'telescope.builtin'.command_history{}<Cr>

" Live grep through all files using ripgrep
if executable('rg')
    command! LiveGrep lua require'telescope.builtin'.live_grep{}
    nnoremap <c-g> <cmd>LiveGrep<CR>
endif
