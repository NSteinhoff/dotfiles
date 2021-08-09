function CompleteRegister(findstart, base)
    if a:findstart
        " Always insert in the cursorcolumn
        return -1
    else
        let items = []
        let regs = split('"0123456789abcdefghijklmnopqrstuvwxyz', '\zs')
        for reg in regs
            if getregtype(reg) ==# 'v'
                let lines = getreg(reg, 0, 1)
                for [i, line] in map(lines, { i, v -> [i, v] })
                    let word = trim(line)
                    call add(items, {'abbr': reg, 'word': word, 'menu': (i > 0 ? '... ' : '' )..word})
                endfor
            endif
        endfor
        return items
    endif
endfunction

function InsCompleteRegister()
    call complete(col('.'), CompleteRegister(0, ''))
    return ''
endfunction
imap <plug>(ins-complete-register) <c-r>=InsCompleteRegister()<cr>

function CompletePath(findstart, base)
    if a:findstart
        " Always insert in the cursorcolumn
        return -1
    endif
    let items = [
    \{'menu': getcwd(), 'word': getcwd(), 'abbr': 'CWD'},
    \{'menu': expand('%'), 'word': expand('%'), 'abbr': '%'},
    \{'menu': expand('%:t'), 'word': expand('%:t'), 'abbr': '%:t'},
    \{'menu': expand('%:h'), 'word': expand('%:h'), 'abbr': '%:h'},
    \{'menu': expand('#'), 'word': expand('#'), 'abbr': '#'},
    \{'menu': expand('#:t'), 'word': expand('#:t'), 'abbr': '#:t'},
    \{'menu': expand('#:h'), 'word': expand('#:h'), 'abbr': '#:h'},
    \]
    return items
endfunction

function InsCompletePath()
    call complete(col('.'), CompletePath(0, ''))
    return ''
endfunction
imap <plug>(ins-complete-path) <c-r>=InsCompletePath()<cr>

function! CompleteLocalPath(findstart, base) abort
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[a-zA-Z0-9-./]'
          let start -= 1
        endwhile
        return start + 1
    endif

    let curpath = expand('%:.:h')..'/'
    let base = substitute(a:base, '^\./', curpath, '')
    let base = base =~ '^'..curpath ? base : curpath..base
    let pattern = base..'*'
    let files = glob(pattern, 0, 1)
    let files = filter(files, { _, fname -> fname =~ '^'..base })
    let files = map(files, { _, fname -> substitute(fname, curpath, './', '') })
    for suffix in split(&suffixesadd, ',')
        let files = map(files, { _, fname -> substitute(fname, suffix..'$', '', '') })
    endfor

    return files
endfunction
function InsCompleteLocalPath()
    let start = CompleteLocalPath(1, '')
    let base = getline('.')[start-1:col('.') - 1]

    call complete(start, CompleteLocalPath(0, base))
    return ''
endfunction
imap <plug>(ins-complete-local-path) <c-r>=InsCompleteLocalPath()<cr>

function CompleteCombined(findstart, base)
    if a:findstart
        " Always insert in the cursorcolumn
        return -1
    endif
    let items = []
    call extend(items, CompletePath(a:findstart, a:base))
    call extend(items, CompleteRegister(a:findstart, a:base))
    return items
endfunction

set completefunc=CompleteCombined
