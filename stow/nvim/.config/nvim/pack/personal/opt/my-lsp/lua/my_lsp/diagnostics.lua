local function setup_signs()
    vim.fn.sign_define(
        "DiagnosticSignError",
        { text = "E", texthl = "DiagnosticSignError" }
    )
    vim.fn.sign_define(
        "DiagnosticSignWarn",
        { text = "W", texthl = "DiagnosticSignWarn" }
    )
    vim.fn.sign_define(
        "DiagnosticSignInfo",
        { text = "I", texthl = "DiagnosticSignInfo" }
    )
    vim.fn.sign_define(
        "DiagnosticSignHint",
        { text = "H", texthl = "DiagnosticSignHint" }
    )
end

local function config()
    vim.diagnostic.config({
        signs = true,
        underline = false,
        virtual_text = false,
        update_in_insert = false,
    })
    setup_signs()
end

return {
    config = config,
}
