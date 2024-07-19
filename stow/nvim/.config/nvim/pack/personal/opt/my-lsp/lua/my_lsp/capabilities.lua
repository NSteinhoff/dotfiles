return {
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = nil
        client.server_capabilities.semanticTokensProvider = nil
    end,
}
