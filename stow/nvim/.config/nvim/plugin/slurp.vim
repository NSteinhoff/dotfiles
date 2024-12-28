command! -nargs=+ -complete=shellcmd Slurp <mods> new | set bt=nofile | execute 'file slurp://'..escape((expand("<args>")), '|') | read !<args>
call abbrev#cmdline('slurp', 'Slurp')
