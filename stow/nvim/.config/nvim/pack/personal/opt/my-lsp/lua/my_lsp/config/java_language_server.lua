local lspconfig = require("lspconfig")

return function(config)
    config.cmd = {
        vim.fn.expand("$HOME")
            .. "/.local/share/java-language-server/dist/lang_server_mac.sh",
    }

    lspconfig["java_language_server"].setup(config)
end
