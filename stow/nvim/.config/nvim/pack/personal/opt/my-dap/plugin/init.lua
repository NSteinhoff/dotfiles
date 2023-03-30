vim.cmd([[packadd nvim-dap]])
local dap = require("dap")
local ui = require("dap.ui.widgets")

local opts = { buffer = false, silent = false }
local maps = {
    ["n"] = {
        ["dK"] = ui.hover,
        ["<leader>d."] = dap.run_to_cursor,
        ["<leader>dc"] = dap.continue,
        ["<leader>ds"] = dap.step_into,
        ["<leader>dn"] = dap.step_over,
        ["<leader>df"] = dap.step_out,
        ["<leader>d<"] = dap.up,
        ["<leader>d>"] = dap.down,
        ["<leader>db"] = dap.toggle_breakpoint,
        ["<leader>dB"] = function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        ["<leader>dB"] = function()
            dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        ["<leader>dr"] = dap.repl.toggle,
        ["<leader>dD"] = dap.run_last,
        ["<leader>dt"] = dap.terminate,
        ["<leader>dd"] = function() 
            dap.disconnect()
            dap.close()
        end,
        ["<leader>dl"] = function()
            dap.list_breakpoints()
            vim.cmd.cwindow()
        end,
        ["<leader>dL"] = dap.clear_breakpoints,
        ["<leader>dS"] = function()
            print(dap.status())
        end,
    },
}

function on_attach(client)
    for mode, map in pairs(maps) do
        for lhs, rhs in pairs(map) do
            vim.keymap.set(mode, lhs, rhs, opts)
        end
    end
end

function on_detach()
    for mode, map in pairs(maps) do
        for lhs, _ in pairs(map) do
            vim.keymap.del(mode, lhs, opts)
        end
    end
end

dap.adapters.lldb = {
    type = "executable",
    command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
    name = "lldb",
}

local dap = require("dap")
dap.configurations.c = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/",
                "file"
            )
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
        args = {},
        env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
        end,
    },
    {
        name = "Attach",
        type = "lldb",
        request = "attach",
        stopOnEntry = true,
        pid = require('dap.utils').pick_process,
        args = {},
    },
}

dap.configurations.rust = dap.configurations.c
dap.configurations.cpp = dap.configurations.c

on_attach()
