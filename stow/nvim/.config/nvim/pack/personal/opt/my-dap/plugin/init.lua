vim.cmd([[packadd nvim-dap]])
local dap = require("dap")

-- Remove most of the default :Dap* commands
local keep_commands =
    { "DapStart", "DapShowLog", "DapContinue", "DapSetLogLevel" }
for name, _ in pairs(vim.api.nvim_get_commands({})) do
    if
        string.match(name, "Dap%u%a*")
        and not vim.tbl_contains(keep_commands, name)
    then
        vim.api.nvim_del_user_command(name)
    end
end

-- Adapters
dap.adapters.lldb = {
    type = "executable",
    command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
    name = "lldb",
}

-- Configurations
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
        stopOnEntry = false,
        pid = "${command:pickProcess}",
        args = {},
    },
    {
        name = "RdThr",
        type = "lldb",
        request = "attach",
        stopOnEntry = false,
        pid = function()
            return require("dap.utils").pick_process({ filter = "rdthr" })
        end,
        args = {},
    },
}

-- Mappings and Commands
local ui = require("dap.ui.widgets")
local scopes_sidebar = ui.sidebar(ui.scopes, { width = 30 }, "leftabove vertical split")

local keymaps = {
    ["n"] = {
        -- Inspect / Hover
        ["dK"] = { rhs = ui.hover, opts = { desc = "DAP Hover" } },

        ["<leader>dc"] = {
            rhs = dap.continue,
            opts = { desc = "DAP Continue / Start" },
        },

        -- Stepping
        ["<leader>d."] = {
            rhs = dap.run_to_cursor,
            opts = { desc = "DAP Run to cursor" },
        },
        ["<leader>ds"] = {
            rhs = dap.step_into,
            opts = { desc = "DAP Step into" },
        },
        ["<leader>dn"] = {
            rhs = dap.step_over,
            opts = { desc = "DAP Step over" },
        },
        ["<leader>dd"] = {
            rhs = dap.step_over,
            opts = { desc = "DAP Step over" },
        },
        ["<leader>df"] = {
            rhs = dap.step_out,
            opts = { desc = "DAP Step out / Finish" },
        },

        -- Breakpoints
        ["<leader>db"] = {
            rhs = dap.toggle_breakpoint,
            opts = { desc = "DAP Toggle breakpoint" },
        },
        ["<leader>dl"] = {
            rhs = function()
                dap.list_breakpoints()
                vim.cmd.cwindow()
            end,
            opts = { desc = "DAP List all breakpoints in quickfix list" },
        },
        ["<leader>dB"] = {
            rhs = dap.clear_breakpoints,
            opts = { desc = "DAP Clear all breakpoints" },
        },
        ["<leader>dC"] = {
            rhs = function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            opts = { desc = "DAP Set breakpoint condition" },
        },
        ["<leader>dL"] = {
            rhs = function()
                dap.set_breakpoint(
                    nil,
                    nil,
                    vim.fn.input("Log point message: ")
                )
            end,
            opts = { desc = "DAP Set log point" },
        },

        -- Navigate stack frame
        ["<leader>d<"] = {
            rhs = dap.up,
            opts = { desc = "DAP Go up one stack frame" },
        },
        ["<leader>d>"] = {
            rhs = dap.down,
            opts = { desc = "DAP Go down one stack frame" },
        },

        -- Widgets
        ["<leader>dr"] = {
            rhs = dap.repl.toggle,
            opts = { desc = "DAP Toggle REPL" },
        },

        ["<leader>dP"] = {
            rhs = function()
                ui.preview()
            end,
            opts = { desc = "DAP Preview" },
        },
        ["<Leader>dF"] = {
            rhs = function()
                ui.centered_float(ui.frames)
            end,
            opts = { desc = "DAP Show frames" },
        },
        ["<Leader>dS"] = {
            rhs = function()
                ui.centered_float(ui.scopes)
            end,
            opts = { desc = "DAP Show scopes" },
        },
        -- Session management
        ["<Leader>dR"] = {
            rhs = dap.run_last,
            opts = { desc = "DAP Run last" },
        },
        ["<Leader>dD"] = {
            rhs = function()
                dap.disconnect()
                dap.close()
            end,
            opts = {
                desc = "DAP Disconnect from Debugee and close Debug Adapter",
            },
        },
        ["<Leader>dT"] = {
            rhs = dap.terminate,
            opts = { desc = "DAP Terminate Debugee and Adapter" },
        },
        ["<Leader>d,"] = {
            rhs = dap.focus_frame,
            opts = { desc = "DAP Focus current Frame" },
        },
    },
}

local commands = {
    -- Breakpoints / Logpoints
    ["DapBreakpointToggle"] = {
        cmd = dap.toggle_breakpoint,
        opts = { desc = "DAP Toggle breakpoint on current line" },
    },
    ["DapBreakpointClear"] = {
        cmd = dap.clear_breakpoints,
        opts = { desc = "DAP Clear all breakpoints" },
    },
    ["DapBreakpointList"] = {
        cmd = function()
            dap.list_breakpoints()
            vim.cmd.cwindow()
        end,
        opts = { desc = "DAP List breakpoints in quickfix list" },
    },
    ["DapBreakpointCondition"] = {
        cmd = function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        opts = { desc = "DAP Set breakpoint condition" },
    },
    ["DapLogpointSet"] = {
        cmd = function()
            dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        opts = { desc = "DAP Set log point" },
    },

    -- Session management
    ["DapSessionDisconnect"] = {
        cmd = function()
            dap.disconnect()
            dap.close()
        end,
        opts = { desc = "DAP Disconnect from Debugee and close Debug Adapter" },
    },
    ["DapSessionRunLast"] = {
        cmd = dap.run_last,
        opts = { desc = "DAP Run last" },
    },
    ["DapSessionTerminate"] = {
        cmd = dap.terminate,
        opts = { desc = "DAP Terminate Debugee and Adapter" },
    },
    ["DapFrameFocus"] = {
        cmd = dap.focus_frame,
        opts = { desc = "DAP Focus current Frame" },
    },

    -- Widgets
    ["DapShowRepl"] = {
        cmd = function()
            dap.repl.toggle()
        end,
        opts = { desc = "DAP Toggle REPL" },
    },
    ["DapShowPreview"] = {
        cmd = function()
            ui.preview()
        end,
        opts = { desc = "DAP Preview" },
    },
    ["DapShowFrames"] = {
        cmd = function()
            ui.centered_float(ui.frames)
        end,
        opts = { desc = "DAP Show frames" },
    },
    ["DapShowScopes"] = {
        cmd = function()
            ui.centered_float(ui.scopes)
        end,
        opts = { desc = "DAP Show scopes" },
    },
    ["DapToggleScopes"] = {
        cmd = function()
            scopes_sidebar.toggle()
        end,
        opts = { desc = "DAP Show scopes" },
    },
}

local default_opts = { buffer = false, silent = false }

function on_attach(client)
    for mode, mode_map in pairs(keymaps) do
        for lhs, mapping in pairs(mode_map) do
            local opts = vim.tbl_extend("force", default_opts, mapping.opts)
            vim.keymap.set(mode, lhs, mapping.rhs, opts)
        end
    end
    for name, command in pairs(commands) do
        vim.api.nvim_create_user_command(name, command.cmd, command.opts)
    end
    scopes_sidebar.open()
end

function on_detach()
    for mode, mode_map in pairs(keymaps) do
        for lhs, _ in pairs(mode_map) do
            vim.keymap.del(mode, lhs, default_opts)
        end
    end
    for name, _ in pairs(commands) do
        vim.api.nvim_del_user_command(name)
    end
    scopes_sidebar.close()
end

dap.listeners.after.event_initialized["my-dap"] = on_attach
dap.listeners.before.event_terminated["my-dap"] = on_detach
dap.listeners.before.event_exited["my-dap"] = on_detach
