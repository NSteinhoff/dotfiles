local disable = {
    "python3_provider",
    "pythonx_provider",
    "ruby_provider",
    "node_provider",
    "perl_provider",
    "matchparen",
    "matchit",
    "netrwPlugin",
    "tutor_mode_plugin",
    "remote_plugins",
    "gzip",
    "tarPlugin",
    "zipPlugin",
    "2html_plugin",
}

for _, name in ipairs(disable) do
    vim.g["loaded_" .. name] = true
end

--  Speed up diff syntax highlighting by disabling localization
vim.g.diff_translations = 0
--  Prefer C over C++ for header files
vim.g.c_syntax_for_h = 1
--  Better folding for markdown.
vim.g.markdown_folding = 1
