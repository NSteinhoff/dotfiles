" using :pattern: instead of /pattern/ to make matching file paths easier
command -nargs=* Broldfiles execute 'browse '..(<q-args> != '' ? 'filter :'..<q-args>..': ' : '')..'oldfiles'
