-- configure the litee.nvim library
require("litee.lib").setup({
    tree = {
        icon_set = "nerd",
    },
    panel = {
        orientation = "left",
        panel_size = 50,
    },
})
-- configure litee-calltree.nvim
require("litee.calltree").setup({
    on_open = "panel",
})
-- configure litee-symboltree.nvim
require("litee.symboltree").setup({
    on_open = "panel",
    keymaps = {
        expand = "zo",
        collapse = "zc",
        collapse_all = "zM",
        jump = "<CR>",
        close = "X",
        close_panel_pop_out = "<Esc>",
    },
})
