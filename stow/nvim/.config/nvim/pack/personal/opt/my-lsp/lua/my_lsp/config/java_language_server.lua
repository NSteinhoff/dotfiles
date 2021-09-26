local lspconfig = require("lspconfig")

return function(config)
    local override = {
        autostart = false,
        cmd = {
            vim.fn.expand('$HOME') .. '/dev/java-language-server/dist/lang_server_mac.sh',
        },
    }

    lspconfig["java_language_server"].setup(vim.tbl_extend('keep', override, config))
end
