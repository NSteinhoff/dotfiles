local map = vim.keymap.set
local cfg = vim.fn.expand("$MYVIMRC")
local cfgd = vim.fn.fnamemodify(cfg, ":h")

local function plug(name) return cfgd .. "/after/plugin/" .. name .. ".lua" end
local function edit(path) return function() vim.cmd.edit(path) end end

-- Basic QoL
map("n", "<BS>", "<c-^>", { desc = "Switch to alternative buffer." })
map("n", "|", "<c-w>v", { desc = "Split window vertically."})
map("n", "<space>", "za", { desc = "Toggle folds." })

-- Opening settings
map("n", "<leader>,,", edit(cfg), { desc = "Open settings file." })
map("n", "<leader>,m", edit(plug("keymap")), { desc = "Open keymaps." })
map("n", "<leader>,a", edit(plug("autocmd")), { desc = "Open autocommands." })
map("n", "m<space>", "<cmd>wall<bar>make!<cr>", { desc = "Build with :make." } );
