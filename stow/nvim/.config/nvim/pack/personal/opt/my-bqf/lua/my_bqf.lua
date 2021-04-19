vim.cmd("packadd nvim-bqf")

vim.cmd("command! BqfAutoToggle lua require('bqf').toggle_auto()")

require("bqf").setup({
    auto_enable = true,
    magic_window = true,
    auto_resize_height = true,
    preview = {
        auto_preview = true,
        border_chars = { "│", "│", "─", "─", "╭", "╮", "╰", "╯", "█" },
        delay_syntax = 50,
        win_height = 15,
        win_vheight = 15,
    },
    func_map = {
        open = "<CR>",
        openc = "o",
        split = "<C-x>",
        vsplit = "<C-v>",
        tab = "",
        tabb = "t",
        ptogglemode = "zp",
        ptoggleitem = "p",
        ptoggleauto = "P",
        pscrollup = "zk",
        pscrolldown = "zj",
        pscrollorig = "zo",
        prevfile = "<C-p>",
        nextfile = "<C-n>",
        prevhist = "<",
        nexthist = ">",
        stoggleup = "<S-Tab>",
        stoggledown = "<Tab>",
        stogglevm = "<Tab>",
        sclear = "z<Tab>",
        filter = "zn",
        filterr = "zN",
        fzffilter = "",
    },
})
