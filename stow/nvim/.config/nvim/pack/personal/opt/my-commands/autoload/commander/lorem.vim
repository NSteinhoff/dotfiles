if exists("loaded_lorem_autoload")
    finish
endif
let loaded_lorem_autoload = 1

let s:filepath = expand('<sfile>:p:h')..'/lorem.txt'
let s:lines = readfile(s:filepath)
let s:words = split(join(s:lines, "\n"), ' ')

function! commander#lorem#lines()
    return s:lines
endfunction

function! commander#lorem#words(n)
    return s:words[:a:n]
endfunction

function commander#lorem#text(n)
    return join(commander#lorem#words(a:n), ' ')
endfunction

function commander#lorem#insert(n, bang)
    let savereg=@l
    let @l = commander#lorem#text(a:n)
    if a:bang
        put l
    else
        normal "lp
    endif
    if &formatprg == ''
        normal `[gq`]
    endif
    let @l=savereg
    if &formatprg == ''
        normal `[
    endif
endfunction
