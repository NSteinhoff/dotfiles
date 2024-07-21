-- Add additional entries to the 'path' option
require('editorconfig').properties.pathadd = function(bufnr, val, opts)
    if not val then return end
    vim.opt_local.path:append(val)
end

require('editorconfig').properties.cflagsadd = function(bufnr, val, opts)
    if not val then return end
    if not vim.b.clfagsadd then
        vim.b.cflagsadd = val
    else
        vim.b.cflagsadd = vim.b.cflagsadd .. " " .. val
    end
end
