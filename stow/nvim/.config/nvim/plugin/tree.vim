command -nargs=* Tree !tree --dirsfirst --gitignore --prune <args>

call abbrev#cmdline('tree', 'Tree')
