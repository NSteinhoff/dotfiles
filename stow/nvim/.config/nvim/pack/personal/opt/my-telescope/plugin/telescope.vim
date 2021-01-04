packadd popup.nvim
packadd plenary.nvim
packadd telescope.nvim

lua require('telescope').setup{
    \  defaults = {
    \    shorten_path = false,
    \    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    \    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    \    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    \  }
    \}

" Prefer git files over find files for git repositories
command TelescopeFiles execute empty(finddir('.git', ';')) ? 'Telescope find_files' : 'Telescope git_files'

command Config lua require'telescope.builtin'.find_files{
    \ cwd = "~/.config/",
    \ find_command = { "rg", "--hidden", "--files", "-L" }
    \ }
command Dotfiles lua require'telescope.builtin'.find_files{
    \ cwd = "~/dev/dotfiles/",
    \ find_command = { "rg", "--hidden", "--files", "-g", "!.git" }
    \ }

" Live grep through all files using ripgrep
if executable('rg')
    command TelescopeGrep lua require'telescope.builtin'.live_grep{ file_ignore_patterns = { "%.lock" } }
endif
