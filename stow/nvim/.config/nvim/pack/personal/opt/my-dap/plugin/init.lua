local default_opts = { buffer = false, silent = false }

local colors = {
    editing = vim.g.colors_name,
    debugging = "darkblue",
}

local function create_commands(commands)
    for name, command in pairs(commands) do
        local opts = vim.tbl_extend("force", { nargs = 0 }, command.opts or {})
        vim.api.nvim_create_user_command(name, command.cmd, opts)
    end
end

local function remove_commands(commands)
    if commands == nil then
        -- Remove global commands
        for name, _ in pairs(vim.api.nvim_get_commands({})) do
            if string.match(name, "Dap%u%a*") then
                vim.api.nvim_del_user_command(name)
            end
        end
        return
    end

    for name, _ in pairs(commands) do
        vim.api.nvim_del_user_command(name)
    end
end

local function create_keymaps(keymaps)
    for lhs, mapping in pairs(keymaps) do
        local opts = vim.tbl_extend("force", default_opts, mapping.opts or {})
        vim.keymap.set("n", lhs, mapping.rhs, opts)
    end
end

local function remove_keymaps(keymaps)
    for lhs, _ in pairs(keymaps) do
        vim.keymap.del("n", lhs, default_opts)
    end
end

local function set_colorscheme(debugging)
    if debugging then
        vim.o.termguicolors = true
        vim.cmd("colorscheme " .. colors.debugging)
    else
        vim.o.termguicolors = false
        vim.cmd("colorscheme " .. colors.editing)
    end
end

local function define_signs()
    local signs = {
        DapBreakpoint = {
            text = "B",
            texthl = "Special",
            linehl = "",
            numhl = "",
        },
        DapBreakpointCondition = {
            text = "C",
            texthl = "Special",
            linehl = "",
            numhl = "",
        },
        DapBreakpointRejected = {
            text = "R",
            texthl = "Error",
            linehl = "",
            numhl = "",
        },
        DapLogPoint = {
            text = "R",
            texthl = "Special",
            linehl = "",
            numhl = "",
        },
        DapStopped = {
            text = "→",
            texthl = "Todo",
            linehl = "Underlined",
            numhl = "",
        },
    }

    for name, sign in pairs(signs) do
        vim.fn.sign_define(name, sign)
    end
end

local function add_env_vars()
    local variables = {}
    for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format("%s=%s", k, v))
    end
    return variables
end

local function init()
    vim.cmd("packadd nvim-dap")
    local dap = require("dap")
    local utils = require("dap.utils")
    local ui = require("dap.ui.widgets")

    -- Adapters
    dap.adapters.lldb = {
        type = "executable",
        command = "/opt/homebrew/opt/llvm/bin/lldb-dap", -- adjust as needed, must be absolute path
        name = "lldb",
    }

    local function pick_process()
        return utils.pick_process({
            filter = vim.fn.input("Filter process name: "),
        })
    end

    local function pick_program()
        return vim.fn.input(
            "Path to executable: ",
            vim.fn.getcwd() .. "/",
            "file"
        )
    end

    local function create_launch_configuration(program)
        local configuration = {
            name = "Launch: " .. program,
            type = "lldb",
            request = "launch",
            program = program,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
            env = add_env_vars,
        }

        return configuration
    end

    local function create_attach_configuration(name)
        local configuration = {
            name = "Attach: " .. name,
            type = "lldb",
            request = "attach",
            pid = function()
                utils.pick_process({
                    filter = name,
                })
            end,
            stopOnEntry = false,
            args = {},
        }

        return configuration
    end

    -- Configurations
    dap.configurations.c = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = pick_program,
            stopOnEntry = false,
            cwd = "${workspaceFolder}",
            args = {},
            env = add_env_vars,
        },
        {
            name = "Attach",
            type = "lldb",
            request = "attach",
            pid = pick_process,
            stopOnEntry = false,
            args = {},
        },
    }

    -- Mappings and Commands
    local scopes_sidebar =
        ui.sidebar(ui.scopes, { width = 32 }, "leftabove vertical split")

    local global_commands = {
        ["DapLaunch"] = {
            cmd = function(opts)
                local program = opts.fargs[1]
                print("DAP Launching " .. program)
                dap.run(create_launch_configuration(program))
            end,
            opts = {
                desc = "DAP Launch file",
                complete = "file",
                nargs = 1,
            },
        },
        ["DapAttach"] = {
            cmd = function(opts)
                local name = opts.fargs[1]
                print("DAP Attaching " .. name)
                dap.run(create_attach_configuration(name))
            end,
            opts = {
                desc = "DAP Attach to process",
                nargs = 1,
            },
        },

        ["DapSessionContinue"] = {
            cmd = function()
                dap.continue()
            end,
            ops = {
                desc = "DAP Start / Continue execution",
            },
        },
        ["DapSessionRestart"] = {
            cmd = function()
                if dap.status() == "" then
                    dap.run_last()
                else
                    dap.restart()
                end
            end,
            opts = {
                desc = "DAP Run last configuration",
            },
        },

        ["DapShowLogs"] = {
            cmd = function()
                dap.show_logs()
            end,
            opts = {
                desc = "DAP Show log files",
            },
        },
        -- Breakpoints / Logpoints
        ["DapBreakpointToggle"] = {
            cmd = function()
                dap.toggle_breakpoint()
            end,
            opts = { desc = "DAP Toggle breakpoint" },
        },
        ["DapBreakpointsClear"] = {
            cmd = function()
                dap.clear_breakpoints()
            end,
            opts = { desc = "DAP Clear all breakpoints" },
        },
        ["DapBreakpointsList"] = {
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
        ["DapBreakpointLog"] = {
            cmd = function()
                dap.set_breakpoint(
                    nil,
                    nil,
                    vim.fn.input("Log point message: ")
                )
            end,
            opts = { desc = "DAP Set log point" },
        },
    }

    local session_commands = {
        -- Stepping
        ["DapStepToCursor"] = {
            cmd = function()
                dap.run_to_cursor()
            end,
            opts = { desc = "DAP Run to cursor" },
        },
        ["DapStepInto"] = {
            cmd = function()
                dap.step_into()
            end,
            opts = { desc = "DAP Step into" },
        },
        ["DapStepOver"] = {
            cmd = function()
                dap.step_over()
            end,
            opts = { desc = "DAP Step over" },
        },
        ["DapStepOut"] = {
            cmd = function()
                dap.step_out()
            end,
            opts = { desc = "DAP Step out / Finish" },
        },
        ["DapStepInstruction"] = {
            cmd = function()
                dap.step_into({ steppingGranularity = "instruction" })
            end,
            opts = { desc = "DAP Step single instruction" },
        },

        -- Navigate stack frame
        ["DapFrameFocus"] = {
            cmd = function()
                dap.focus_frame()
            end,
            opts = { desc = "DAP Focus current Frame" },
        },
        ["DapFrameUp"] = {
            cmd = function()
                dap.up()
            end,
            opts = { desc = "DAP Go up one stack frame" },
        },
        ["DapFrameDown"] = {
            cmd = function()
                dap.down()
            end,
            opts = { desc = "DAP Go down one stack frame" },
        },
        ["DapFrameRestart"] = {
            cmd = function()
                dap.restart_frame()
            end,
            opts = { desc = "DAP Restart frame" },
        },

        -- Session management
        ["DapSessionDisconnect"] = {
            cmd = function()
                dap.disconnect()
                dap.close()
            end,
            opts = {
                desc = "DAP Disconnect from Debugee and close Debug Adapter",
            },
        },
        ["DapSessionTerminate"] = {
            cmd = function()
                dap.terminate()
            end,
            opts = { desc = "DAP Terminate Debugee and Adapter" },
        },

        -- Widgets
        ["DapShowHover"] = {
            cmd = function()
                ui.hover()
            end,
            opts = { desc = "DAP Hover" },
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
        ["DapToggleSidebar"] = {
            cmd = function()
                scopes_sidebar.toggle()
            end,
            opts = { desc = "DAP Toggle scopes sidebar" },
        },
        ["DapToggleRepl"] = {
            cmd = function()
                dap.repl.toggle({ height = 6 })
            end,
            opts = { desc = "DAP Toggle REPL" },
        },
    }

    local global_keymaps = {
        -- Session
        ["<leader>dc"] = { rhs = "<cmd>DapSessionContinue<cr>" },
        ["<leader>dr"] = { rhs = "<cmd>DapSessionRestart<cr>" },

        -- Breakpoints
        ["<leader>dd"] = { rhs = "<cmd>DapBreakpointToggle<cr>" },
        --[[
        ["<leader>dbb"] = { rhs = "<cmd>DapBreakpointToggle<cr>" },
        ["<leader>dbc"] = { rhs = "<cmd>DapBreakpointCondition<cr>" },
        ["<leader>dbl"] = { rhs = "<cmd>DapBreakpointLog<cr>" },
        ["<leader>dbL"] = { rhs = "<cmd>DapBreakpointsList<cr>" },
        ["<leader>dbD"] = { rhs = "<cmd>DapBreakpointsClear<cr>" },
        --]]
    }

    local session_keymaps = {
        -- Stepping
        ["ds\\"] = { rhs = "<cmd>DapSessionContinue<cr>" },
        ["ds."] = { rhs = "<cmd>DapStepToCursor<cr>" },
        ["ds;"] = { rhs = "<cmd>DapStepInto<cr>" },
        ["ds'"] = { rhs = "<cmd>DapStepOver<cr>" },
        ["ds:"] = { rhs = "<cmd>DapStepOut<cr>" },
        ["dsi"] = { rhs = "<cmd>DapStepInstruction<cr>" },

        -- Navigate stack frame
        ["ds,"] = { rhs = "<cmd>DapFrameFocus<cr>" },
        ["ds<"] = { rhs = "<cmd>DapFrameUp<cr>" },
        ["ds>"] = { rhs = "<cmd>DapFrameDown<cr>" },
        ["dsr"] = { rhs = "<cmd>DapFrameRestart<cr>" },

        -- Widgets
        ["<leader>dh"] = { rhs = "<cmd>DapShowHover<cr>" },
        ["<leader>dp"] = { rhs = "<cmd>DapShowPreview<cr>" },
        ["<leader>df"] = { rhs = "<cmd>DapShowFrames<cr>" },
        ["<leader>ds"] = { rhs = "<cmd>DapShowScopes<cr>" },

        -- Session management
        ["<leader>dD"] = { rhs = "<cmd>DapSessionDisconnect<cr>" },
        ["<leader>dT"] = { rhs = "<cmd>DapSessionTerminate<cr>" },
    }

    local function on_attach(_)
        create_keymaps(session_keymaps)
        create_commands(session_commands)
        scopes_sidebar.open()
        dap.repl.open({ height = 6 })
    end

    local function on_detach(_, payload)
        if not payload then
            return
        end
        scopes_sidebar.close()
        dap.repl.close()
        remove_keymaps(session_keymaps)
        remove_commands(session_commands)
        vim.cmd([[redraw]])
    end

    dap.listeners.after.event_initialized["my-dap"] = on_attach
    dap.listeners.after.event_terminated["my-dap"] = on_detach
    dap.listeners.after.event_exited["my-dap"] = on_detach

    -- Signs
    define_signs()

    -- Status Update
    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("dap-status", { clear = true }),
        pattern = "DapProgressUpdate",
        callback = function()
            local status = dap.status()
            vim.g.my_dap_status = status
            set_colorscheme(status ~= "")
            vim.cmd("redrawstatus")
        end,
    })

    -- Global mappings and commands
    remove_commands() -- Clear builtins
    create_keymaps(global_keymaps)
    create_commands(global_commands)

    vim.g.initialized_dap = true
end
--
-- Delay the initialization
vim.schedule(init)
