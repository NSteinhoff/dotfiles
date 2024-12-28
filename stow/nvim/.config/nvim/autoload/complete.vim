function! complete#_localpath(findstart, base) abort
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[a-zA-Z0-9-./]'
          let start -= 1
        endwhile
        return start + 1
    endif

    let curpath = expand('%:.:h')..'/'
    let base = substitute(a:base, '^\./', curpath, '')
    let base = base =~ '^'..curpath ? base : curpath..base
    let pattern = base..'*'
    let files = glob(pattern, 0, 1)
    let files = filter(files, { _, fname -> fname =~ '^'..base })
    let files = map(files, { _, fname -> substitute(fname, curpath, './', '') })
    for suffix in split(&suffixesadd, ',')
        let files = map(files, { _, fname -> substitute(fname, suffix..'$', '', '') })
    endfor
    if !(a:base =~ '^\./')
        let files = map(files, { _, fname -> substitute(fname, '^\./', '', '') })
    endif

    return files
endfunction
function complete#localpath()
    let start = complete#_localpath(1, '')
    let base = getline('.')[start-1:col('.') - 2]

    call complete(start, complete#_localpath(0, base))
    return ''
endfunction
