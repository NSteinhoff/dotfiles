function commander#git#local_revisions(...)
    return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --format=%h\ %s\ \(%ar\)')
endfunction

function commander#git#global_revisions(...)
    return systemlist('git -C ' . shellescape(getcwd()) . ' log --format=%h\ %s\ \(%ar\)')
endfunction

function commander#git#file_revisions(...)
    return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --no-patch --format=%h\ %s\ \(%ar\) -- ' . expand('%:t'))
endfunction

function commander#git#line_revisions(...)
    return systemlist("git -C " . shellescape(expand('%:p:h')) . " log -L <line1>,<line2>:" . expand('%:t') . (<q-bang> != '!' ? ' --no-patch --oneline' : '') )
endfunction

function commander#git#file_revision(revision, ...)
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    let opts = a:0 ? join(a:000, ' ') : ''
    return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' show '.ref.' '.opts)
endfunction

function commander#git#load_diff_in_split(revision)
    let ft = &ft
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    let commit = (a:revision != '' ? a:revision : 'HEAD')
    let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' show '.ref.':./' . expand('%:t'))
    call commander#lib#load_lines_in_split(content, 'vertical')
    execute 'file '.commit
    let &ft=ft
    diffthis | wincmd p | diffthis | wincmd p
endfunction

function commander#git#load_patch(revision) abort
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    let commit = (a:revision != '' ? a:revision : 'HEAD')
    let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' diff '.ref.' -- ' . expand('%:t'))
    call commander#lib#load_lines(content)
    execute 'file '.expand('#').'.'.commit
    set ft=diff
endfunction

function commander#git#load_timeline()
    let content = commander#git#file_revisions()
    call commander#lib#load_lines(content)
    execute 'file '.expand('#').'.timeline'
    set ft=gitlog
endfunction

function commander#git#load_revision(revision)
    let content = commander#git#file_revision(a:revision)
    call commander#lib#load_lines(content)
    set ft=git
endfunction

function commander#git#load_revision_in_split(revision)
    let content = commander#git#file_revision(a:revision)
    call commander#lib#load_lines_in_split(content, 'vertical')
    set ft=git
endfunction

function commander#git#set_changed_args()
    let cwd = getcwd()
    let gitdir = finddir('.git', ';')
    if gitdir == ''
        return
    endif
    let gitroot = fnamemodify(gitdir, ':h')
    let changed = systemlist('git diff --name-only -- .')
    let absolute = map(changed, { k, v -> gitroot.'/'.v })
    let relative = map(absolute, { k, v ->
                \ match(v, cwd) ? strcharpart(v, matchend(v, cwd) + 1) : v
                \ })
    let filepaths = filter(relative, { k, v -> findfile(v) != '' })
    %argd
    for path in filepaths
        execute 'argadd '.path
    endfor
endfunction
