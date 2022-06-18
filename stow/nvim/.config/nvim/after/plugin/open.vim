""" Open with default application
command -nargs=? Open silent execute '!'..(system('uname') =~? 'darwin' ? 'open' : 'xdg-open')..' '..open#uri(<q-args>)
