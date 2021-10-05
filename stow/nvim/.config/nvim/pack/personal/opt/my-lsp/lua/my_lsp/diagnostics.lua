local severities = {
    error = "",
    warning = "",
    info = "כֿ",
    hint = "",
}

local function setup_signs()
    vim.fn.sign_define(
        "DiagnosticSignError",
        { text = severities.error, texthl = "DiagnosticSignError" }
    )
    vim.fn.sign_define(
        "DiagnosticSignWarning",
        { text = severities.warning, texthl = "DiagnosticSignWarning" }
    )
    vim.fn.sign_define(
        "DiagnosticSignInformation",
        { text = severities.info, texthl = "DiagnosticSignInformation" }
    )
    vim.fn.sign_define(
        "DiagnosticSignHint",
        { text = severities.hint, texthl = "DiagnosticSignHint" }
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
