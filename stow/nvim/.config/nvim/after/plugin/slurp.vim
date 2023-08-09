command! -nargs=+ Slurp <mods> new | set bt=nofile | file slurp://<args> | read !<args>
