local lspconfig = require("lspconfig")

return function(config)
    config.autostart = false

    config.root_dir = function(fname)
        -- Prefer the repository root for typescript
        -- NOTE:
        -- This may break for projects that don't use project references defined
        -- in the root tsconfig.json, or when typescript is only used in a subdirectory.
        local lsputil = require("lspconfig/util")
        local git_root = lsputil.find_git_ancestor(fname)

        if
            git_root
            and lsputil.path.is_file(
                lsputil.path.join(git_root, "tsconfig.json")
            )
        then
            return git_root
        else
            return lsputil.root_pattern("tsconfig.json", "package.json", ".git")(
                fname
            )
        end
    end

    config.init_options = {
        preferences = {
            disableSuggestions = true,
        },
    }

    lspconfig["tsserver"].setup(config)
end
