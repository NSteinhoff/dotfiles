function! s:compare_versions(left, right)
    echom [a:left, a:right]
    let [l1, l2, l3] = a:left->split('[.-]')[0:2]->map({ _, s -> str2nr(s)})
    let [r1, r2, r3] = a:right->split('[.-]')[0:2]->map({ _, s -> str2nr(s)})

    if l1 > r1
        return 1
    elseif l1 < r1
        return -1
    elseif l2 > r2
        return 1
    elseif l2 < r2
        return -1
    elseif l3 > r3
        return 1
    elseif l3 < r3
        return -1
    else
        return 0
    endif
endfunction

function! s:parse_yarn_info(info)
    let l:versions = []
    let l:start = v:false
    for line in a:info
        if !l:start
            if line =~ '^\s*time:'
                let l:start = v:true
            endif
            continue
        endif

        if line =~ '^\s*},$'|break|endif

        let l:matches = matchlist(line, '^\s*''\(\([0-9]\+.\)\{2}[0-9]\+\(-\(alpha\|beta\).[0-9]\+\)\?\)'': ''\(.*\)'',\?$')
        if !empty(l:matches)
            call add(l:versions, l:matches[1])
        endif
    endfor
    return l:versions
endfunction

function! s:parse_npm_versions(versions)
    return a:versions->map({_, v -> matchstr(v, '\([0-9]\+.\)\{2}[0-9]\+')})
endfunction

function! CompletePackageJson(findstart, base) abort
    if a:findstart
        let l:line = getline('.')
        let l:start = match(l:line, '^\s*".\{-}":\s\zs')
        return l:start != -1 && l:start < col('.') ? l:start : -3
    endif

    let l:package = matchstr(getline('.'), '^\s*\zs".\{-}"\ze:\s')
    if executable('yarn')
        let l:info = systemlist('yarn info '..l:package)
        let l:versions = s:parse_yarn_info(l:info)
    elseif executable('npm')
        let l:info = systemlist('npm --color=false view '..l:package..' versions')
        let l:versions = s:parse_npm_versions(l:info)
    else
        return []
    endif

    if v:shell_error
        echo l:info->join()
        return []
    endif


    let l:base = empty(a:base) ? ['', '', ''] : matchlist(a:base, '^"\(\D\)\?\(.*\)')
    let l:base_range = l:base[1]
    let l:base_version = l:base[2]

    echom len(l:versions)

    return l:versions
                \->filter({_, v -> !empty(v)})
                \->filter({_, v -> v =~ '^'..l:base_version})
                \->sort({l, r -> s:compare_versions(l, r)})
                \->reverse()
                \->map({_, v -> {'word': '"'..l:base_range..v..'"'}})
endfunction

augroup package-json
    autocmd!
    autocmd BufEnter package.json setlocal completefunc=CompletePackageJson
    autocmd BufEnter package.json command! -buffer Why execute "normal yi\"" | execute "!yarn why \""..@".."\""
    autocmd BufEnter package.json map <buffer> <leader>w <cmd>Why<cr>
augroup END
