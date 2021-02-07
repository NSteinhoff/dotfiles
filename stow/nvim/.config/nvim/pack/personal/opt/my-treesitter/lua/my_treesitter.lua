vim.cmd('packadd nvim-treesitter')

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    indent = {
        enable = false,
    },
    highlight = {
        enable = true,
        disable = { 'typescript', 'typescriptreact' },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "gnn",
            node_decremental = "gnm",
            scope_incremental = "gnc",
        },
    },
    textobjects = {
        enable = true
    },
}
