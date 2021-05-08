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

        let l:matches = matchlist(line, '^\s*''\(\([0-9]\+.\)\{2}[0-9]\+\)'': ''\(.*\)'',\?$')
        if !empty(l:matches)
            let l:date = strftime(' %Y-%m-%d', strptime('%Y-%m-%dT%T', l:matches[3]))
            call add(l:versions, {'word': l:matches[1], 'menu': l:date})
        endif
    endfor
    return l:versions
endfunction

function! s:parse_npm_versions(versions)
    let l:versions = map(a:versions, {_, v -> matchstr(v, '\([0-9]\+.\)\{2}[0-9]\+')})
    let l:versions = filter(l:versions, {_, v -> !empty(v)})
    let l:versions = map(l:versions, {_, v -> {'word': v}})
    return l:versions
endfunction

function! CompletePackageJson(findstart, base) abort
    if a:findstart
        let l:line = getline('.')
        let l:start = match(l:line, '^\s*".\{-}":\s\zs')
        return l:start != -1 && l:start < col('.') ? l:start : -3
    endif

    let l:package = matchstr(getline('.'), '^\s*\zs".\{-}"\ze:\s')
    if executable('yarn')
        let l:versions = s:parse_yarn_info(systemlist('yarn info '..l:package))
    elseif executable('npm')
        let l:versions = s:parse_npm_versions(systemlist('npm --color=false view '..l:package..' versions'))
    else
        return []
    endif
    if v:shell_error|return []|endif

    let l:base = empty(a:base) ? ['', '', ''] : matchlist(a:base, '^"\(\D\)\?\(.*\)')
    let l:base_range = l:base[1]
    let l:base_version = l:base[2]

    let l:versions = filter(l:versions, {_, v -> v.word =~ '^'..l:base_version})
    let l:versions = map(l:versions, {_, v -> {'word': '"'..l:base_range..v.word..'"', 'menu': get(v, 'menu', '')}})

    return reverse(l:versions)
endfunction

if expand('%') =~ 'package.json'
    setlocal omnifunc=CompletePackageJson
endif
