command! -nargs=+ -complete=shellcmd Slurp <mods> new | set bt=nofile | file slurp://<args> | read !<args>
call abbrev#cmdline('slurp', 'Slurp')
