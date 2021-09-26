function s:listpaths()
    return globpath(&packpath, 'pack/*/*/*', 0, 1)
endfunction

function s:listfiles()
    let vimscript = globpath(&packpath, 'pack/**/*.vim', 0, 1)
    let lua = globpath(&packpath, 'pack/**/*.lua', 0, 1)
    return sort(vimscript + lua)
endfunction

function s:listnames()
    return map(s:listpaths(), { _, path -> fnamemodify(path, ":t") })
endfunction

function s:locatepack(name)
    let paths = filter(s:listpaths(), 'v:val =~ "/" .. a:name .. "$"')

    if empty(paths)
        echo "Package '" .. a:name .. "' not found."
        return ''
    endif

    return paths[0]
endfunction

function s:findfile(name)
    let paths = filter(s:listfiles(), 'v:val =~ a:name .. "$"')

    if empty(paths)
        echo "File '" .. a:name .. "' not found."
        return ''
    endif

    return paths[0]
endfunction

" -------------------------------------------------------------------------- "
"                                   Public                                   "
" -------------------------------------------------------------------------- "
function packer#locatepack(name)
    return s:locatepack(a:name)
endfunction

function packer#printpacks(fullpath)
    let packs = a:fullpath ? s:listpaths() : s:listnames()
    for p in packs
        echo p
    endfor
endfunction

function packer#openpack(name)
    let path = s:locatepack(a:name)
    if !empty(path)
        execute "edit " .. path
    endif
endfunction

function packer#findfile(name)
    let path = s:findfile(a:name)
    if !empty(path)
        execute "edit " .. path
    endif
endfunction

" ------------------------------- Completions --------------------------------
function! packer#completenames(arglead, cmdline, cursorpos) abort
    let names = s:listnames()
    call filter(names, { _, v -> v =~ a:arglead })
    call sort(names)
    return names
endfunction

function! packer#completefiles(arglead, cmdline, cursorpos) abort
    let files = s:listfiles()
    call filter(files, { _, v -> v =~ a:arglead })
    call sort(files)
    return files
endfunction
