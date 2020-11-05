# Pomodoro

This plugin adds a simple, low-maintenance pomodoro timer.

The goal of this timer is to require as little conscious effort on your part
as possible. It starts automatically, recognizes when you are taking a break,
and start the next session when you resume work.

When a pomodoro session is running over time, it will continue to bug you
until you take a break. Interrupting a break by moving the cursor will cause
it to complain and restarts the break timer from the beginning.

## Usage

Pomodoro can be started automatically by setting

    let g:pomodoro_autostart = 1

It can also be toggled on/off:

    :PomodoroToggle

The current settings as well as current and past session can be checked with

    :PomodoroStatus


## Statusline

A simple statusline indicator can be added

    set statusline+='%{v:lua.pomodoro.statusline()}'


## To-do

- [ ] enable and disable
- [ ] display settings
- [ ] start a new session when neither session or break are in progress
- [ ] the user is considered on break when the current session duration
  has exceeded the target duration and the difference between the current
  time and the last activity is smaller than the target break length.
- [ ] activity during a break restarts the break by extending the current
  session.
- [ ] overtime causes increasingly annoying reminders to take a break.
- [ ] display stats with progress bars
- [ ] show the current time in a floating window or in the statusline.
