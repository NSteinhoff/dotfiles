vim.cmd('packadd nvim-treesitter')

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    indent = {
        enable = true,
    },
    highlight = {
        enable = true,
        disable = { 'typescript' },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            node_decremental = "grm",
            scope_incremental = "grc",
        },
    },
    textobjects = {
        enable = true
    },
}

vim.cmd [[set foldmethod=expr]]
vim.cmd [[set foldexpr=nvim_treesitter#foldexpr()]]
