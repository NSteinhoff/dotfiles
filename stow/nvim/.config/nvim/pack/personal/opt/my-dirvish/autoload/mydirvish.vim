function! mydirvish#create_range_edit_command(name, cmd, require_range = v:false)
    let cmd = a:name

    if a:require_range
        let cmd .= printf(" if <range> < 2 || <line1> == <line2> | echo 'Command :%s needs a range. Abort!' | else | ", a:name)
    endif

    let cmd .= printf(" execute '<line1>,<line2>w !xargs '..(<bang>0 ? 'echo ' : ' ')..'%s <args>'", a:cmd)

    if a:require_range
        let cmd .= " | endif"
    endif

    execute "command! -buffer -range -bang -nargs=* "..cmd

    call abbrev#cmdline(tolower(a:name), a:name, {'buffer': v:true, 'range': v:true})
endfunction

function! mydirvish#add_segment()
    let lnum = line('.')
    let head = getline(lnum)
    let path = expand('%:p'..(get(g:, 'dirvish_relative_paths') ? ':.' : ''))

    if head == path || path !~# '^'..escape(head, '/.')
        return
    endif

    let tail = substitute(path, escape(head, '/.'), '', '')
    let segment = matchstr(tail, '^.\{-}/')
    call setline(lnum, head..segment)
endfunction

function! mydirvish#add_line_below()
    let lnum = line('.')
    call append(lnum, @%)
    call feedkeys('jA')
endfunction

function! mydirvish#add_line_above()
    let lnum = line('.') - 1
    call append(lnum, @%)
    call feedkeys('kA')
endfunction

function mydirvish#path_sort()
    let pdir = '/$'
    " match only the '.' but require a '/' before and a filename after
    let phidden = '/\zs\.\ze\([^/]\+/\?$\)'
    " match the extension or the filename if no extension
    let pfile = '/\.\@![^/]\{-}\zs\.\?[^/.]\+$'
    let pattern = pdir..'\|'..phidden..'\|'..pfile
    " exclude file pattern
    let pexclude = '.DS_STORE'

    let lines = getline(0, '$')
    call filter(lines, { i, v -> v !~ pexclude })

    let grouped = {}
    for line in lines
        let suffix = matchstr(line, pattern)
        let grouped[suffix] = add(get(grouped, suffix, []), line)
    endfor

    silent 1,$ delete _

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

    if get(g:, 'dirvish_hide_dotfiles', v:false)
        let hidden = []
    endif

    let lnum = 1
    for line in sort(dirs)
        call setline(lnum, line)
        let lnum += 1
    endfor

    " sort by group
    for [_, lines] in sort(items(grouped))
        " sort within group
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
