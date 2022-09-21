function run#interpret(...)
    if empty(get(b:, 'interpreter'))
        echom 'Interpreter not set. Set b:interpreter for this buffer.'
        return
    endif
    execute 'w !'..b:interpreter..(a:0 > 0 ? ' '..a:000->join(' ') : '')
endfunction
