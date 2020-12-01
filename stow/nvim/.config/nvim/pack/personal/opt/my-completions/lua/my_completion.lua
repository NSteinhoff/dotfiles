local M = {}

vim.cmd [[augroup user-completion]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd BufEnter * lua require('my_completion').on_attach()]]
vim.cmd [[augroup END]]

function M.on_attach()
    vim.cmd('packadd completion-nvim')
    vim.cmd('packadd completion-treesitter')
    -- vim.cmd('packadd completion-tags')

    require'completion'.on_attach()

    vim.g.completion_auto_change_source = 1
    vim.g.completion_enable_auto_popup = 0
    vim.g.completion_chain_complete_list = {
        default = {
            comment = {},
            string = {},
            default = {
                {complete_items = {'lsp'}},
                {complete_items = {'ts'}},
            }
        }
    }

    vim.cmd('set completeopt=menuone,noinsert,noselect shortmess+=c')
    vim.cmd('imap <buffer> <c-space> <Plug>(completion_trigger)')
    vim.cmd('imap <buffer> <c-j> <Plug>(completion_next_source)')

    mode = 'smarttab'
    if mode == 'smarttab' then
        vim.g.completion_enable_auto_popup = 1
        vim.cmd('imap <buffer> <expr> <Tab>   pumvisible() ? "<C-n>" : "<Plug>(completion_smart_tab)"')
        vim.cmd('imap <buffer> <expr> <S-Tab> pumvisible() ? "<C-p>" : "<Plug>(completion_smart_s_tab)"')
    elseif mode == 'code' then
        vim.g.completion_enable_auto_popup = 1
        vim.cmd('set completeopt-=noselect')
        vim.cmd('inoremap <buffer> <expr> <Tab> pumvisible() ? "<C-y>" : "<Tab>"')
    else
        vim.cmd('inoremap <buffer> <expr> <Tab>   pumvisible() ? "<C-n>" : "<Tab>"')
        vim.cmd('inoremap <buffer> <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"')
    end
end

return M
