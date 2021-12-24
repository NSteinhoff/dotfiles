local function setup_signs()
    vim.fn.sign_define(
        "DiagnosticSignError",
        { text = "", texthl = "DiagnosticSignError" }
    )
    vim.fn.sign_define(
        "DiagnosticSignWarn",
        { text = "", texthl = "DiagnosticSignWarn" }
    )
    vim.fn.sign_define(
        "DiagnosticSignInfo",
        { text = "כֿ", texthl = "DiagnosticSignInfo" }
    )
    vim.fn.sign_define(
        "DiagnosticSignHint",
        { text = "", texthl = "DiagnosticSignHint" }
    )
end

local function config()
    vim.diagnostic.config({
        signs = false,
        underline = false,
        virtual_text = false,
        update_in_insert = false,
    })
    setup_signs()
end

return {
    config = config,
}
