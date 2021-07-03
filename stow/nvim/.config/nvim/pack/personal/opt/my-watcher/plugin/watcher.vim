command Watchers call watcher#info()
command -nargs=* -complete=file Watch call watcher#watch(<f-args>)
command -nargs=? -complete=customlist,watcher#complete Unwatch call watcher#unwatch(<q-args>)
