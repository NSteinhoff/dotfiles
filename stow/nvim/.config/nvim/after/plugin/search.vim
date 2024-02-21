let s:engines = {}
let s:engines.ddg       = 'https://duckduckgo.com/?q=%s'
let s:engines.devdocs   = 'https://devdocs.io/?q=%s'
let s:engines.mdn       = 'https://developer.mozilla.org/en-US/search?q=%s'
let s:engines.rustdoc   = 'https://doc.rust-lang.org/std/index.html?search=%s'

function s:complete_engine(arglead, cmdline, cursorpos)
    return filter(keys(s:engines), { _, e -> e =~ a:arglead})
endfunction

function s:search(engine, ...)
    if !a:0
        echo "Error: no search query provided"
        return
    endif

    if !has_key(s:engines, a:engine)
        echo "Error: unknown search engine '"..a:engine.."'"
        return
    endif

    let engine = s:engines[a:engine]
    let query = join(a:000, '+')
    let uri = substitute(engine, '%s', query, '')
    execute 'Open '..uri
endfunction

command -nargs=+ -complete=customlist,<sid>complete_engine Search call s:search(<f-args>)
call abbrev#cmdline('search', 'Search')
