Pomodoro = {}

local session_length = 1
local break_length = 5
local sessions = {}

local Session = {count = 0}

function Session:new()
    local o = setmetatable({}, self)
    self.__index = self
    local now = 0

    self.count = self.count + 1

    o.id = self.count
    o.start = os.time()
    o.last = os.time()

    return o
end

function Session:elapsed()
    return self.last - self.start
end

function Session:remaining()
    return session_length * 60 - self:elapsed()
end

function Session:in_overtime()
    return self:remaining() < 0
end

function Session:until_next_session()
    return math.max(0, math.min(break_length, break_length + self:remaining()))
end

function Session:__tostring()
    local fmt = '%s: %s'
    return fmt:format(self.id, self:remaining())
end


-- Start a pomodoro session
--
-- Record the start time of the new session and start a timer.
local function on_session_start()
end


-- Process cursor activity
--
-- Every time the cursor is moved, this activity is logged as the
-- last activity of the current session.
local function on_activity(time)
    if #sessions == 0 or sessions[#sessions]:until_next_session() == 0 then
        table.insert(sessions, Session:new())
        print("Started session #", #sessions)
    end

    if sessions[#sessions]:in_overtime() then
        print("Take a break!")
    end

    local session = sessions[#sessions]
    session.last = time
end


local function is_enabled()
    return vim.fn.exists("#pomodoro#CursorMoved") == 1
end


local function display_sessions(sessions)
    local displaystring = ''
    for _, session in pairs(sessions) do
        displaystring = displaystring .. tostring(session)
    end
    return displaystring
end


function Pomodoro.show_settings()
    local fmt = 'Pomodoro Settings:\n' ..
    '    Session: %s min\n' ..
    '    Break:   %s min\n' ..
    '    Enabled: %s'
    print(fmt:format(session_length, break_length, is_enabled()))
    print(display_sessions(sessions))
end


function Pomodoro.statusline()
    if not is_enabled() then return "" end
    return "[pomodoro]"
end


function Pomodoro.status()
    print(sessions[#sessions])
end


function Pomodoro.toggle()
    if is_enabled() then
        Pomodoro.disable()
    else
        Pomodoro.enable()
    end
end


function Pomodoro.ping()
    on_activity(os.time())
end


function Pomodoro.enable()
    vim.cmd('augroup pomodoro')
    vim.cmd('autocmd!')
    vim.cmd('autocmd CursorMoved * lua require("pomodoro").ping()')
    vim.cmd('augroup END')
end


function Pomodoro.disable()
    vim.cmd('augroup pomodoro')
    vim.cmd('autocmd!')
    vim.cmd('augroup END')
end


function Pomodoro.init()
    if vim.g.pomodoro_autostart == 1 then
        print("Enabling Pomodoro")
        Pomodoro.enable()
    end
end

function TESTER()
    print("=== TESTER ===")

    Pomodoro.show_settings()
    local sessions = {
        Session:new(), Session: new()
    }
    print(tostring(Session:new()))
    -- print(display_sessions(sessions))
    print("=== END ===")
end


return Pomodoro
