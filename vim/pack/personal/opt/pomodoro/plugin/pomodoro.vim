" Vim plugin for keeping track of uninterrupted time worked
" Last Change:      2019 Sep 08
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

command! PomodoroToggle call pomodoro#toggle()
command! PomodoroStatus call pomodoro#settings()

if exists('g:pomodoro_autostart') && g:pomodoro_autostart
    call pomodoro#enable()
endif
