return {
    on_attach = function(client, ...)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.semanticTokensProvider = false
    end,
}
