if vim.g.did_load_filetypes then
    return
end

local filetypes = {
    cfg = { "flake8", ".flake8" },
    dockerfile = { "Dockerfile.*" },
    gitconfig = { "*/.config/git/config.*" },
    lox = { "*.lox" },
    taskpaper = { "*.taskpaper" },
    -- scratch = { "scratch://*" },
}

vim.api.nvim_create_augroup("filetypedetect", { clear = false })
for ft, pattern in pairs(filetypes) do
    vim.api.nvim_create_autocmd({ "BufFilePost", "BufNewFile", "BufRead" }, {
        group = "filetypedetect",
        pattern = pattern,
        command = "setfiletype " .. ft,
    })
end
