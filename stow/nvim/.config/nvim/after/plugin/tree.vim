command -nargs=* Tree !tree --dirsfirst --gitignore --prune <args>
cnoreabbrev <expr> tree (getcmdtype() ==# ':' && getcmdline() ==# 'tree') ? 'Tree' : 'tree'
