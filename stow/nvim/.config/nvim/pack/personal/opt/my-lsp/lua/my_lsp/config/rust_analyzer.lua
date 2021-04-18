local lspconfig = require("lspconfig")

return function(config)
    local override = {
        settings = {
            ["rust-analyzer"] = {
                diagnostics = {
                    -- Rust Analyzer does not handle procedural macros yet.
                    disabled = { "missing-unsafe" },
                },
            },
        },
    }

    lspconfig["rust_analyzer"].setup(vim.tbl_extend('keep', override, config))
end
