-- Disable builtin bloat
local plugins = {
        -- Provider
        "python3_provider",
        "pythonx_provider",
        "ruby_provider",
        "node_provider",
        "perl_provider",
        -- Plugins
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
for _, name in ipairs(plugins) do vim.g["loaded_"..name] = true end

-- Set terminal colors
vim.cmd.colorscheme("ludite")

-- Options
local options = {
        ttimeoutlen     = 25,
        swapfile        = false,
        termguicolors   = false,
        number          = false,
        signcolumn      = "number",
        undofile        = true,
        showmatch       = true,
        concealcursor   = "n",

        foldmethod      = "indent",
        foldlevelstart  = 99,

        splitright      = true,
        inccommand      = "split",

        scrolloff       = 1,
        sidescrolloff   = 1,

        ignorecase      = true,
        smartcase       = true,
        tagcase         = "match",

        mouse           = "nv",
        mousemodel      = "extend",

        list            = false,
        listchars       = [[tab:¦ ,trail:▓,extends:»,precedes:«,nbsp:␣,eol:¬,lead: ]],

        wrap            = false,
        linebreak       = true,
        breakindent     = true,
        showbreak       = "└",
        smartindent     = true,

        tabstop         = 4,
        shiftwidth      = 4,
        softtabstop     = -1,
        expandtab       = true,

        formatoptions   = "cjlnpqr",
        formatlistpat   = [[^\s*\(\d\+[\]:.)}\t ]\|[*-][\t ]\)\s*]],

        wildmode        = { "longest:full", "full" },
        wildoptions     = "pum",
        completeopt     = { "menuone", "noinsert", "noselect" },
        shortmess        = "ltToOCFsc",
}
for key, value in pairs(options) do vim.opt[key] = value end
