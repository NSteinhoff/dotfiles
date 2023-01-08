require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    sync_install = false,
    ignore_install = { "phpdoc" },
    highlight = {
        enable = true,
    },
    indent = { enabled = false },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "v<leader>",
            node_incremental = "v<leader>",
            node_decremental = "v<bs>",
        },
    },
    context_commentstring = { enable = true },
    rainbow = { enable = false },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]]"] = "@block.outer",
                ["]m"] = "@function.outer",
            },
            goto_next_end = {
                ["]["] = "@block.outer",
                ["]M"] = "@function.outer",
            },
            goto_previous_start = {
                ["[["] = "@block.outer",
                ["[m"] = "@function.outer",
            },
            goto_previous_end = {
                ["[]"] = "@block.outer",
                ["[M"] = "@function.outer",
            },
        },
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ac"] = "@conditional.outer",
                ["ic"] = "@conditional.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["aF"] = "@frame.outer",
                ["iF"] = "@frame.inner",
            },
        },
    },
    refactor = {
        enable = false,
        highlight_definitions = { enable = false },
        highlight_current_scope = { enable = false },
        navigation = {
            enable = false,
            keymaps = {
                goto_definition = "gd",
                list_definitions_toc = "gO",
            },
        },
    },
})
