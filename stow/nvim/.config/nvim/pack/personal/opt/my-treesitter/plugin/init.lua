local function init()
    vim.cmd("packadd nvim-treesitter")

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
                    and (
                        vim.endswith(
                            vim.api.nvim_buf_get_name(bufnr),
                            "runtime/doc/syntax.txt"
                        )
                        or vim.endswith(
                            vim.api.nvim_buf_get_name(bufnr),
                            "runtime/syntax/colortest.vim"
                        )
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
                node_incremental = "v",
                scope_incremental = "<CR>",
                node_decremental = "<BS>",
            },
        },

        indent = { enable = false },
    })

    vim.g.initialized_treesitter = true
end

-- Delay the initialization
vim.schedule(init)
