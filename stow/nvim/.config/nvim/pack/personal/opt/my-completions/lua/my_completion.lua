local M = {}

vim.cmd('packadd completion-nvim')
vim.cmd('packadd completion-tags')
vim.cmd('packadd completion-treesitter')

vim.cmd('augroup user-completion')
vim.cmd('autocmd BufEnter * lua require"my_completion".on_attach()')
vim.cmd('augroup END')


function M.on_attach()
    require'completion'.on_attach()

    -- Set completeopt to have a better completion experience
    vim.cmd('set completeopt=menuone,noinsert,noselect')

    -- Avoid showing message extra message when using completion
    vim.cmd('set shortmess+=c')

    -- Trigger completions with CTRL-SPACE
    vim.cmd('imap <c-space> <Plug>(completion_trigger)')

    -- Cycle completion sources
    vim.cmd('imap <c-j> <Plug>(completion_next_source)')

    if vim.g.my_completion_smart_tab == 1 then
        -- Use <Tab> and <S-Tab> to navigate through popup menu and trigger completions
        vim.cmd('imap <expr> <Tab>   pumvisible() ? "<C-n>" : "<Plug>(completion_smart_tab)"')
        vim.cmd('imap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<Plug>(completion_smart_s_tab)"')
    else
        -- Use <Tab> and <S-Tab> to navigate through popup menu
        vim.cmd('inoremap <expr> <Tab>   pumvisible() ? "<C-n>" : "<Tab>"')
        vim.cmd('inoremap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"')
    end
end


return M
