local lspconfig = require("lspconfig")

return function(on_attach)
    lspconfig["rust_analyzer"].setup({
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                diagnostics = {
                    -- Rust Analyzer does not handle procedural macros yet.
                    disabled = { "missing-unsafe" },
                },
            },
        },
    })
end
