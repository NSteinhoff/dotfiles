local M = {}

function M.on_attach()
    vim.cmd('packadd completion-nvim')

    require'completion'.on_attach()

    vim.g.completion_enable_auto_popup = false
    vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy", "all"}

    vim.g.completion_auto_change_source = 0
    vim.g.completion_enable_auto_paren = 1
    vim.g.completion_matching_smart_case = 1

    vim.g.completion_chain_complete_list = {
        default = {
            {complete_items = {"lsp"}},
        }
    }

    --[[
    vim.g.completion_customize_lsp_label = {
        Function = "? [function]",
        Method = "? [method]",
        Reference = "? [reference]",
        Enum = "? [enum]",
        Field = "? [field]",
        Keyword = "? [key]",
        Variable = "? [variable]",
        Folder = "? [folder]",
        Snippet = "? [snippet]",
        Operator = "? [operator]",
        Module = "? [module]",
        Text = "?[text]",
        Class = "? [class]",
        Interface = "? [interface]"
    }
    ]]

    vim.g.completion_chain_complete_list = {
        default = {
            comment = {},
            string = {},
            default = {
                {complete_items = {'lsp'}},
            }
        }
    }

    vim.cmd [[ imap <buffer> <c-space> <Plug>(completion_trigger) ]]
    vim.cmd [[ imap <buffer> <c-j> <Plug>(completion_next_source) ]]
    vim.cmd [[ imap <buffer> <c-k> <Plug>(completion_prev_source) ]]
    -- vim.cmd [[ set completeopt=menuone,noinsert,noselect ]]

    mode = 'code'
    if mode == 'smarttab' then
        vim.g.completion_enable_auto_popup = 1
        vim.cmd[[ imap <buffer> <expr> <Tab>   pumvisible() ? "<C-n>" : "<Plug>(completion_smart_tab)" ]]
        vim.cmd[[ imap <buffer> <expr> <S-Tab> pumvisible() ? "<C-p>" : "<Plug>(completion_smart_s_tab)" ]]
    elseif mode == 'code' then
        vim.g.completion_enable_auto_popup = 1
        vim.cmd [[ inoremap <buffer> <expr> <Tab> pumvisible() ? "<C-y>" : "<Tab>" ]]
    end
end

return M
