vim.cmd([[packadd nvim-dap]])
local dap = require("dap")

-- Remove most of the default :Dap* commands
local keep_commands = {
    "DapShowLog",
    "DapSetLogLevel",
    "DapContinue",
    "DapToggleBreakpoint",
    "DapRunLast",
}

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
    command = "/opt/homebrew/opt/llvm/bin/lldb-dap", -- adjust as needed, must be absolute path
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
        stopOnEntry = false,
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
        name = "LaunchThisFile",
        type = "lldb",
        request = "launch",
        program = "${fileBasenameNoExtension}",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
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
    {
        name = "Nin",
        type = "lldb",
        request = "attach",
        stopOnEntry = false,
        pid = function()
            return require("dap.utils").pick_process({ filter = "nin" })
        end,
        args = {},
    },
}

-- Mappings and Commands
local ui = require("dap.ui.widgets")
local scopes_sidebar =
    ui.sidebar(ui.scopes, { width = 42 }, "leftabove vertical split")

local keymaps = {
    ["n"] = {
        -- Inspect / Hover
        ["dK"] = { rhs = ui.hover, opts = { desc = "DAP Hover" } },

        -- Continue
        ["dc"] = {
            rhs = dap.continue,
            opts = { desc = "DAP Continue / Start" },
        },

        -- Stepping
        ["d."] = {
            rhs = dap.run_to_cursor,
            opts = { desc = "DAP Run to cursor" },
        },
        ["di"] = {
            rhs = function()
                dap.step_into({ steppingGranularity = "instruction" })
            end,
            opts = { desc = "DAP Step into" },
        },
        ["ds"] = {
            rhs = dap.step_into,
            opts = { desc = "DAP Step into" },
        },
        ["dn"] = {
            rhs = dap.step_over,
            opts = { desc = "DAP Step over" },
        },
        ["df"] = {
            rhs = dap.step_out,
            opts = { desc = "DAP Step out / Finish" },
        },

        -- Breakpoints
        ["db"] = {
            rhs = dap.toggle_breakpoint,
            opts = { desc = "DAP Toggle breakpoint" },
        },
        ["dl"] = {
            rhs = function()
                dap.list_breakpoints()
                vim.cmd.cwindow()
            end,
            opts = { desc = "DAP List all breakpoints in quickfix list" },
        },
        ["dB"] = {
            rhs = dap.clear_breakpoints,
            opts = { desc = "DAP Clear all breakpoints" },
        },
        ["dC"] = {
            rhs = function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            opts = { desc = "DAP Set breakpoint condition" },
        },
        ["dL"] = {
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
        ["d<"] = {
            rhs = dap.up,
            opts = { desc = "DAP Go up one stack frame" },
        },
        ["d>"] = {
            rhs = dap.down,
            opts = { desc = "DAP Go down one stack frame" },
        },

        -- Widgets
        ["dr"] = {
            rhs = dap.repl.toggle,
            opts = { desc = "DAP Toggle REPL" },
        },

        ["dP"] = {
            rhs = function()
                ui.preview()
            end,
            opts = { desc = "DAP Preview" },
        },
        ["dF"] = {
            rhs = function()
                ui.centered_float(ui.frames)
            end,
            opts = { desc = "DAP Show frames" },
        },
        ["dS"] = {
            rhs = function()
                ui.centered_float(ui.scopes)
            end,
            opts = { desc = "DAP Show scopes" },
        },
        ["dts"] = {
            rhs = function()
                scopes_sidebar.toggle()
            end,
            opts = { desc = "DAP Toggle scopes sidebar" },
        },
        -- Session management
        ["dR"] = {
            rhs = dap.run_last,
            opts = { desc = "DAP Run last" },
        },
        ["dD"] = {
            rhs = function()
                dap.disconnect()
                dap.close()
            end,
            opts = {
                desc = "DAP Disconnect from Debugee and close Debug Adapter",
            },
        },
        ["dT"] = {
            rhs = dap.terminate,
            opts = { desc = "DAP Terminate Debugee and Adapter" },
        },
        ["d,"] = {
            rhs = dap.focus_frame,
            opts = { desc = "DAP Focus current Frame" },
        },
    },
}

local commands = {
    ["DapRunLast"] = {
        cmd = dap.run_last,
        opts = { desc = "DAP Run last" },
    },
    ["DapFrameFocus"] = {
        cmd = dap.focus_frame,
        opts = { desc = "DAP Focus current Frame" },
    },

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
    ["DapSessionTerminate"] = {
        cmd = dap.terminate,
        opts = { desc = "DAP Terminate Debugee and Adapter" },
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
        opts = { desc = "DAP Toggle scopes sidebar" },
    },
}

local default_opts = { buffer = false, silent = false }

local function on_attach(_)
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

local function on_detach(_, payload)
    if not payload then
        return
    end

    for mode, mode_map in pairs(keymaps) do
        for lhs, _ in pairs(mode_map) do
            vim.keymap.del(mode, lhs, default_opts)
        end
    end
    for name, _ in pairs(commands) do
        if not vim.tbl_contains(keep_commands, name) then
            vim.api.nvim_del_user_command(name)
        end
    end
    scopes_sidebar.close()
    vim.cmd([[redraw]])
end

dap.listeners.after.event_initialized["my-dap"] = on_attach
dap.listeners.after.event_terminated["my-dap"] = on_detach
dap.listeners.after.event_exited["my-dap"] = on_detach

vim.fn.sign_define(
    "DapBreakpoint",
    { text = "B", texthl = "Special", linehl = "", numhl = "" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "C", texthl = "Special", linehl = "", numhl = "" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "R", texthl = "Error", linehl = "", numhl = "" }
)
vim.fn.sign_define(
    "DapLogPoint",
    { text = "R", texthl = "Special", linehl = "", numhl = "" }
)
vim.fn.sign_define(
    "DapStopped",
    { text = "→", texthl = "Todo", linehl = "Underlined", numhl = "" }
)

vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("dap-status", { clear = true }),
    pattern = "DapProgressUpdate",
    command = "redrawstatus",
})
