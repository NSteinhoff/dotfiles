require("nvim-treesitter.configs").setup({
    -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
        enable = true, -- false will disable the whole extension
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enabled = false,
    },
    incremental_selection = {
        enable = false,
        keymaps = {
            init_selection = "<leader>gnn",
            node_incremental = "<leader>grn",
            scope_incremental = "<leader>grc",
            node_decremental = "<leader>gmn",
        },
    },
    context_commentstring = {
        enable = true,
    },
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
    rainbow = {
        enable = true,
    },
})
