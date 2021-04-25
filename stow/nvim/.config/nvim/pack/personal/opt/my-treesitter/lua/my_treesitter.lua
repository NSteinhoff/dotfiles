vim.cmd("packadd nvim-treesitter")

require("nvim-treesitter.configs").setup({
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    indent = {
        enable = true,
    },
    highlight = {
        enable = true,
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
        enable = true,
    },
})
