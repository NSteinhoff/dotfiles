packadd popup.nvim
packadd plenary.nvim
packadd telescope.nvim

lua require('telescope').setup()

" Prefer git files over find files for git repositories
command TelescopeFiles execute
    \ empty(finddir('.git', ';')) ?
    \'lua require("telescope.builtin").find_files ()' :
    \'lua require("telescope.builtin").git_files ()'

" Live grep through all files using ripgrep
if executable('rg')
    command TelescopeGrep lua require'telescope.builtin'.live_grep{ file_ignore_patterns = { "%.lock" } }
endif


" --------------------------------- Mappings ----------------------------------
nnoremap <leader>ff <cmd>lua require('telescope.builtin').builtin()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fo <cmd>lua require('telescope.builtin').oldfiles {shorten_path = true}<cr>
nnoremap <leader>fl <cmd>lua require('telescope.builtin').loclist()<cr>
nnoremap <leader>fq <cmd>lua require('telescope.builtin').quickfix()<cr>
nnoremap <leader>f: <cmd>lua require('telescope.builtin').command_history()<cr>
nnoremap <leader>f* <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>

nnoremap <leader>fca <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <leader>fcr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fcd <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
