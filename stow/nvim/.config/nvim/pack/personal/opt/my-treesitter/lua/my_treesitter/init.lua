vim.cmd([[packadd nvim-treesitter]])
-- vim.cmd([[packadd nvim-treesitter-rainbow]])
-- vim.cmd([[packadd nvim-treesitter-textobjects]])
-- vim.cmd([[packadd nvim-treesitter-commentstring]])
-- vim.cmd([[packadd nvim-treesitter-refactor]])

local function init()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "vim",
            "vimdoc",
            "markdown",
            "markdown_inline",
            "c",
            "lua",
            "python",
            "bash",
            "javascript",
            "typescript",
        },
        sync_install = false,
        auto_install = true,
        ignore_install = { "phpdoc" },

        -- base
        highlight = {
            enable = true,
            disable = function(lang, bufnr)
                --[[
                if lang == "markdown" then
                    return true
                end
                --]]

                -- Disable in syntax help to show 'group-name' highlights
                if
                    lang == "vimdoc"
                    and vim.endswith(
                        vim.api.nvim_buf_get_name(bufnr),
                        "runtime/doc/syntax.txt"
                    )
                then
                    return true
                end

                return false
            end,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                scope_incremental = "-",
                node_decremental = "<BS>",
            },
        },
        indent = { enable = false },

        -- plugin
        rainbow = { enable = true },
        context_commentstring = { enable = true },
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
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["aF"] = "@frame.outer",
                    ["iF"] = "@frame.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
                },
            },
        },
        refactor = {
            enable = false,
            highlight_definitions = { enable = true },
            highlight_current_scope = { enable = true },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = "gd",
                    list_definitions_toc = "gO",
                },
            },
        },
    })
end

-- Delay the initialization to make sure that other initialization does not get
-- blocked / timedout because of slow treesitter parser loading.
vim.schedule(init)
