local Session = require('pomodoro_session')

pomodoro = {}


local session_length = 25 * 60
local break_length = 5 * 60
local sessions = {}


local function sec2min(seconds)
    return math.floor(seconds / 60)
end


local function min2sec(minutes)
    return minutes * 60
end


local function duration2time(seconds)
    return {
        min = sec2min(seconds),
        sec = seconds % 60,
    }
end


-- Start a pomodoro session
--
-- Record the start time of the new session and start a timer.
local function on_session_start()
end


-- Start a break
--
-- When a session has run its duration and the cursor is not moved,
-- a break timer is started. When the cursor is moved before the desired
-- break time has elapsed, the timer is reset.
local function on_break_start()
end


-- Log cursor activity
--
-- Every time the cursor is moved, this activity is logged as the
-- last activity of the current session.
local function on_activity(time)
    if #sessions == 0 or sessions[#sessions].finished then
        table.insert(sessions, Session:new(session_length))
        print("Started session #", #sessions)
    end


    local session = sessions[#sessions]
    session.last = time


    if session:duration() >= session.length then
        session.finished = true
        print("Finished session #", #sessions)
    end
end


local function is_enabled()
    return vim.fn.exists("#pomodoro#CursorMoved") == 1
end




function pomodoro.statusline()
    if not is_enabled() then return "" end


    return "[pomodoro]"
end


function pomodoro.status()
    vim.fn["pomodoro#settings"]()
end


function pomodoro.toggle()
    if is_enabled() then
        pomodoro.disable()
    else
        pomodoro.enable()
    end
end


function pomodoro.ping()
    on_activity(os.time())
end


function pomodoro.enable()
    vim.cmd('augroup pomodoro')
    vim.cmd('autocmd!')
    vim.cmd('autocmd CursorMoved * lua require("pomodoro").ping()')
    vim.cmd('augroup END')
end


function pomodoro.disable()
    vim.cmd('augroup pomodoro')
    vim.cmd('autocmd!')
    vim.cmd('augroup END')
end


function pomodoro.init()
    if vim.g.pomodoro_autostart == 1 then
        pomodoro.enable()
    end
end


function TESTER()
    return Session:new()
end


return pomodoro
