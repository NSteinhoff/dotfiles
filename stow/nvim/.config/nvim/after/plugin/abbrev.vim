" ------------------------------- Command Line --------------------------------
" Open man pages
cnoreabbrev <expr> man getcmdtype() ==# ':' && getcmdline() =~# '^\(tab\s\\|vert\s\)\?man' ? 'Man' : 'man'
cnoreabbrev <expr> cfilter getcmdtype() ==# ':' && getcmdline() ==# 'cfilter' ? 'Cfilter' : 'man'

" ---------------------------------- Dates ------------------------------------
" Local date
iabbrev <expr> ddd strftime("%Y-%m-%d")
" Local date in human readable format
iabbrev <expr> ddh strftime("%d %B %Y")
" Local date in German format
iabbrev <expr> ddg strftime("%d.%m.%Y")
" Local date-time
iabbrev <expr> ddc strftime("%c")
" Long format
iabbrev <expr> ddl strftime("%a %b %e %Y %r")

" --------------------------------- Favicon -----------------------------------
" Favicon href
iabbrev "myfavicon" "https://gist.githubusercontent.com/NSteinhoff/9bc4844403ca3d1e2f9a3c698dfc1493/raw/069483f72ee493a4cb890c1c18de43666c1096e0/favicon.ico"

" vim:foldmethod=marker textwidth=0

function! CompleteAbbrev(findstart, base) abort
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\S'
            let start -= 1
        endwhile
        return start
    endif
    return execute('iabbrev')
                \ ->split('\n')
                \ ->map({ _, l -> split(l, '\s\+') })
                \ ->map({ _, parts -> {'trigger': parts[1], 'replacement': join(parts[1:], ' ')}})
                \ ->filter({ _, a -> a.trigger =~ a:base })
                \ ->map({ _, a -> {'word': a.trigger, 'menu': a.replacement} })
endfunction
set completefunc=CompleteAbbrev
