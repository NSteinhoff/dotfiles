local opt = vim.opt

-- [[ Disable builtin bloat ]]
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

-- [[ Set terminal colors ]]
vim.cmd.colorscheme("ludite")

-- [[ Options ]]
-- general
opt.ttimeoutlen     = 25
opt.swapfile        = false
opt.termguicolors   = false
opt.number          = false
opt.signcolumn      = "number"
opt.undofile        = true
opt.showmatch       = true
opt.concealcursor   = "n"
-- folding
opt.foldmethod      = "indent"
opt.foldlevelstart  = 99
-- window splitting
opt.splitright      = true
opt.inccommand      = "split"
-- scrolling
opt.scrolloff       = 1
opt.sidescrolloff   = 1
-- search case
opt.ignorecase      = true
opt.smartcase       = true
opt.tagcase         = "match"
-- mouse
opt.mouse           = "nv"
opt.mousemodel      = "extend"
-- special characters
opt.list            = false
opt.listchars       = [[tab:¦ ,trail:▓,extends:»,precedes:«,nbsp:␣,eol:¬,lead: ]]
-- line wrapping
opt.wrap            = false
opt.linebreak       = true
opt.breakindent     = true
opt.showbreak       = "└"
opt.smartindent     = true
-- indentation
opt.tabstop         = 4
opt.shiftwidth      = 4
opt.softtabstop     = -1
opt.expandtab       = true
-- formatting
opt.formatoptions   = "cjlnpqr"
opt.formatlistpat   = [[^\s*\(\d\+[\]:.)}\t ]\|[*-][\t ]\)\s*]]
-- wildmenu
opt.wildmode        = { "longest:full", "full" }
opt.wildoptions     = "pum"
opt.completeopt     = { "menuone", "noinsert", "noselect" }
opt.shortmess       = "ltToOCFsc"
