lua require('my_lsp')

let s:dir = resolve(expand('<sfile>:h:h')..'/lua')
let s:paths = glob(copy(s:dir)..'/**/*.lua', 1, 1)
let s:files = map(copy(s:paths), { _, p -> substitute(p, '^'..s:dir..'/', '', '') })
let s:patterns = map(copy(s:files), { _, f -> '**/'..f })
let s:modules = map(copy(s:files), { _, f -> substitute(substitute(f, '/', '.', 'g'), '\(\.init\)\?\.lua$', '', '') })


function s:reload()
    LspStop

    for m in s:modules
        execute 'lua package.loaded["'..m..'"] = nil'
    endfor

    lua require('my_lsp')
endfunction

aug my-lsp-set-diagnostics
    autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false })
aug END

aug my-lsp-reload
    autocmd!
    execute 'autocmd BufWritePost '..join(s:patterns, ',')..' call s:reload()'
aug END
