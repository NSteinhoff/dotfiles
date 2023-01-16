command! -nargs=+ Slurp <mods> new | set bt=nofile | file slurp://<args> | r !<args>
