lua require('my_lsp')

let s:lua_dir = expand('<sfile>:h:h')..'/lua'
let s:lua_paths = glob(copy(s:lua_dir)..'/**/*.lua', 1, 1)
let s:lua_files = map(copy(s:lua_paths), { _, p -> substitute(p, '^'..s:lua_dir..'/', '', '') })
let s:lua_modules = map(copy(s:lua_files), { _, f -> substitute(substitute(f, '/', '.', 'g'), '\(\.init\)\?\.lua$', '', '') })


function s:reload()
    for m in s:lua_modules
        execute 'lua package.loaded["'..m..'"] = nil'
    endfor
    lua require('my_lsp')
endfunction

aug my-lsp-reload
    autocmd!
    execute 'autocmd BufWritePost '..join(s:lua_paths, ',')..' call s:reload()'
aug END
