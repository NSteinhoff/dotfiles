packadd popup.nvim
packadd plenary.nvim
packadd telescope.nvim

" Prefer git files over find files for git repositories
nnoremap <expr><c-p> finddir('.git', ';') == ''
            \ ? '<cmd>lua require"telescope.builtin".find_files{}<CR>'
            \ : '<cmd>lua require"telescope.builtin".git_files{}<CR>'

command FindFiles lua require'telescope.builtin'.find_files{}
command GitFiles lua require'telescope.builtin'.git_files{}
command Config lua require'telescope.builtin'.find_files{
            \ cwd = "~/.config/",
            \ find_command = { "rg", "--hidden", "--files", "-L" }
            \ }
command Dotfiles lua require'telescope.builtin'.find_files{
            \ cwd = "~/dev/dotfiles/",
            \ find_command = { "rg", "--hidden", "--files", "-g", "!.git" }
            \ }
command Oldfiles lua require'telescope.builtin'.oldfiles{}<CR>
command Quickfix lua require'telescope.builtin'.quickfix{}<CR>
command Loclist lua require'telescope.builtin'.loclist{}<CR>
command History lua require'telescope.builtin'.command_history{}<CR>
command Buffers lua require'telescope.builtin'.buffers{ shorten_path = true }<CR>
command Commits lua require'telescope.builtin'.git_commits{}<CR>
command BCommits lua require'telescope.builtin'.git_bcommits{}<CR>
command Branches lua require'telescope.builtin'.git_branches{}<CR>
command Help lua require'telescope.builtin'.help_tags{}<CR>
command Treesitter lua require'telescope.builtin'.treesitter{}<CR>

" Live grep through all files using ripgrep
if executable('rg')
    command! LiveGrep lua require'telescope.builtin'.live_grep{ file_ignore_patterns = { "%.lock" } }
    nnoremap <c-g> <cmd>LiveGrep<CR>
endif
