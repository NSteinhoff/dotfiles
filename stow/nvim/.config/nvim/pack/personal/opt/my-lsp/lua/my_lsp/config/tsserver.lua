local lspconfig = require("lspconfig")

return function(config)
    local override = {
        autostart = true,

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
    }

    lspconfig["tsserver"].setup(vim.tbl_extend("keep", override, config))
end
