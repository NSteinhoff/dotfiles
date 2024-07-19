-- Add additional entries to the 'path' option
require('editorconfig').properties.pathadd = function(bufnr, val, opts)
    if not val then return end
    vim.opt_local.path:append(val)
end
