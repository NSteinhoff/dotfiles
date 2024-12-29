local function init()
    vim.cmd("packadd nvim-treesitter")
    -- vim.cmd("packadd nvim-treesitter-rainbow")
    -- vim.cmd("packadd nvim-treesitter-textobjects")

    require("nvim-treesitter.configs").setup({
        sync_install = false,
        auto_install = true,

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

        ignore_install = { "phpdoc" },

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

            -- The indentation function needs to be able to inspect syntax elements
            additional_vim_regex_highlighting = { "javascript", "typescript" },
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
    })

    vim.cmd([[echom "'my-treesitter' initialized"]])
end

-- Delay the initialization
vim.schedule(init)
