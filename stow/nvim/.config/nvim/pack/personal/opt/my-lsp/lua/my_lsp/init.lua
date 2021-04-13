vim.cmd("packadd nvim-lspconfig")
local lspconfig = require("lspconfig")

vim.lsp.handlers["textDocument/publishDiagnostics"] = require("my_lsp.diagnostics").on_publish_diagnostics

local function on_attach(...)
    require("my_lsp.diagnostics").on_attach(...)
    require("my_lsp.options").on_attach(...)
    require("my_lsp.commands").on_attach(...)
    require("my_lsp.mappings").on_attach(...)
end

local servers = { "clangd", "jsonls", "cssls" }
for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
    })
end

lspconfig["tsserver"].setup({
    on_attach = function(client, bufnr, ...)
        vim.cmd("packadd nvim-lsp-ts-utils")
        require("nvim-lsp-ts-utils").setup {
            disable_commands = true,
            enable_import_on_completion = false,
            import_on_completion_timeout = 5000
        }

        vim.cmd([[command! -bar -buffer LspTsOrganize lua require'nvim-lsp-ts-utils'.organize_imports()]])
        vim.cmd([[command! -bar -buffer LspTsFixCurrent lua require'nvim-lsp-ts-utils'.fix_current()]])
        vim.cmd([[command! -bar -buffer LspTsRenameFile lua require'nvim-lsp-ts-utils'.rename_file()]])
        vim.cmd([[command! -bar -buffer LspTsImportAll lua require'nvim-lsp-ts-utils'.import_all()]])

        vim.api.nvim_buf_set_keymap(bufnr, "n", "dcO", "<CMD>LspTsOrganize<CR>", {silent = true, noremap = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "dcA", "<CMD>LspTsFixCurrent<CR>", {silent = true, noremap = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "dcR", "<CMD>LspTsRenameFile<CR>", {silent = true, noremap = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "dcI", "<CMD>LspTsImportAll<CR>", {silent = true, noremap = true})

        on_attach(client, bufnr, ...)
    end,
    root_dir = function(fname)
        -- Prefer the repository root for typescript
        -- NOTE:
        -- This may break for projects that don't use project references defined
        -- in the root tsconfig.json, or when typescript is only used in a subdirectory.
        local lsputil = require("lspconfig/util")
        local git_root = lsputil.find_git_ancestor(fname)
        return git_root
            and lsputil.path.is_file(lsputil.path.join(git_root, "tsconfig.json"))
            and git_root
            or lsputil.root_pattern("tsconfig.json", "package.json")(fname)
    end,
})

---[[
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
--]]

return {
    util = require("my_lsp.util"),
    diagnostics = require("my_lsp.diagnostics"),
    status = require("my_lsp.status"),
}
