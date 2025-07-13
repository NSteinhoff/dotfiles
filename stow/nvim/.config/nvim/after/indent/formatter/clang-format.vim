let s:config_file = expand("~/.clang-format")

function s:style()
    let l:config = {}
    if (filereadable(s:config_file))
        let l:config = s:read_config_file()
    else
        let l:config['BasedOnStyle'] = "LLVM"
    endif
    let l:config = s:apply_local_settings(l:config)
    let l:style  = s:dump_config(l:config)
    return l:style
endfunction

function s:read_config_file()
    let l:lines = readfile(s:config_file)
    let l:len = len(l:lines)

    let l:config = {}
    let l:num = 0
    let l:sub = ''
    while l:num < l:len
        let l:line = l:lines[l:num]
        let l:num += 1

        if empty(l:line)
            continue
        endif

        if !empty(l:sub) && match(l:line, '\S') == 0
            let l:sub = ''
        endif

        let l:parts = split(l:line, ':\s*')
        let l:key = trim(parts[0])
        if len(l:parts) == 1
            let l:sub = l:key
            let l:config[l:sub] = {}
            continue
        endif

        if empty(l:sub)
            let l:config[l:key] = trim(l:parts[1])
        else
            let l:config[l:sub][l:key] = trim(l:parts[1])
        endif
    endwhile

    return l:config
endfunction

function s:dump_config(config)
    let l:config = a:config
    let l:style = '"{'
    let n = 0
    for [k, v] in items(l:config)
        if type(v) == v:t_dict
            let s = "{"
            let nn = 0
            for [kk, vv] in items(v)
                let s .= (nn > 0 ? ", " : "")..kk..": "..vv
                let nn += 1
            endfor
            let s .= "}"
        else
            let s = v
        endif

        let l:style .= (n > 0 ? ", " : "")..k..": "..s
        let n += 1
    endfor
    let l:style .= '}"'

    return l:style
endfunction

function s:apply_local_settings(config)
    let l:config = a:config
    if (&textwidth)
        let l:config['ColumnLimit'] = &textwidth
    endif
    let l:config['UseTab'] = &expandtab ? 'Never' : 'AlignWithSpaces'
    let l:config['TabWidth'] = &tabstop
    let l:config['IndentWidth'] = &shiftwidth ? &shiftwidth : &tabstop
    let l:config['ContinuationIndentWidth'] = l:config['IndentWidth']
    return l:config
endfunction

function s:create_fmt()
    return 'clang-format --assume-filename=file.c --style='..s:style()
endfunction

if executable('clang-format')
    let b:formatprgfunc = function('s:create_fmt')
endif

command! ClangFormatShowStyle echo s:style()
