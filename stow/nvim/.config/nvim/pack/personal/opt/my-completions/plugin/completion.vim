" lua require('my_completion')

function CompleteRegisters(findstart, base)
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
                    call add(items, {'abbr': (i > 0 ? '... ' : '' ).word, 'word': word, 'menu': reg})
                endfor
            endif
        endfor
        return items
    endif
endfunction

set completefunc=CompleteRegisters
