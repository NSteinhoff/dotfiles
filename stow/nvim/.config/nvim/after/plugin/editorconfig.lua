-- Add additional entries to the 'path' option
require('editorconfig').properties.pathadd = function(bufnr, val, opts)
    if not val then return end
    vim.opt_local.path:append(val)
end

require('editorconfig').properties.cflagsadd = function(bufnr, val, opts)
    if not val then return end

    -- Editorconfig lowercases all keys and value `-Ilib` -> `-ilib`
    -- There is no `-i` flag that I'm aware, so we can support this special case
    -- and uppercase the flag (but not the argument)
    local include_dir = string.match(val, '-i(%a+)')
    if include_dir then
        val = '-I'..include_dir
    end

    if not vim.b.clfagsadd then
        vim.b.cflagsadd = val
    else
        vim.b.cflagsadd = vim.b.cflagsadd .. " " .. val
    end
end
