" Vim plugin for keeping track of uninterrupted time worked
" Last Change:      Sun Nov  1 13:14:11 2020
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.
let g:pomodoro_autostart = 0
lua require('pomodoro').init()

command! PomodoroToggle lua require('pomodoro').toggle()
command! PomodoroStatus lua require('pomodoro').status()
