" lua require('my_completion')

function CompleteRegister(findstart, base)
    if a:findstart
        " Always insert in the cursorcolumn
        return -1
    else
        let items = []
        let regs = ['"', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
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
imap <Plug>(ins-complete-register) <C-R>=InsCompleteRegister()<CR>

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
imap <Plug>(ins-complete-path) <C-R>=InsCompletePath()<CR>

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
