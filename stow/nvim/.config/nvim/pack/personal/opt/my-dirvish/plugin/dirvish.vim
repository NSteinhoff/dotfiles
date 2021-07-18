packadd vim-dirvish

function s:path_sort()
    let pd = '/$'
    let ph = '/\@<=\.\([^/]\+/\?$\)\@='
    let pf = '[^/.]\+$'
    let pattern = pd..'\|'..ph..'\|'..pf

    let grouped = {}
    for line in getline(0, '$')
        let suffix = matchstr(line, pattern)
        let grouped[suffix] = add(get(grouped, suffix, []), line)
    endfor

    " for [m, ls] in items(grouped)
    "     echo 'Suffix: '..m
    "     echo '- '..join(ls, "\n- ")
    "     echo "\n"
    " endfor

    let lnum = 1
    if has_key(grouped, '/')
        let dirs = remove(grouped, '/')
    else
        let dirs = []
    endif

    if has_key(grouped, '.')
        let hidden = remove(grouped, '.')
    else
        let hidden = []
    endif

    let lnum = 1
    for line in sort(dirs)
        call setline(lnum, line)
        let lnum += 1
    endfor

    for [_, lines] in sort(items(grouped))
        for line in sort(lines)
            call setline(lnum, line)
            let lnum += 1
        endfor
    endfor

    for line in sort(hidden)
        call setline(lnum, line)
        let lnum += 1
    endfor
endfunction
command DirvishSort call s:path_sort()

let g:dirvish_mode = ':DirvishSort'
let g:dirvish_relative_paths = 0

command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Texplore tab split | silent Dirvish <args>
