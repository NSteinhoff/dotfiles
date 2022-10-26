function s:scratch(mods)
    let b = 'scratch//SCRATCH'
    let winnr = bufwinnr(bufnr(b))
    if winnr == -1
        execute a:mods..' split +set\ nobuflisted\ buftype=nofile\ bufhidden=hide\ noswapfile '..b
    else
        execute winnr .. 'wincmd w'
    endif
endfunction

command! -bar Scratch call s:scratch('<mods>')
