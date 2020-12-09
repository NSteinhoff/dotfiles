function commander#git#local_revisions(...)
    return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --format=%h\ %s\ \(%ar\)')
endfunction

function commander#git#global_revisions(...)
    return systemlist('git -C ' . shellescape(getcwd()) . ' log --format=%h\ %s\ \(%ar\)')
endfunction

function commander#git#file_revisions(...)
    return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' log --no-patch --format=%h\ %s\ \(%ar\) -- ' . expand('%:t'))
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
    mark Z
    topleft vnew | call append(0, content) | $delete
    execute 'file '.commit | set buftype=nofile bufhidden=wipe nobuflisted noswapfile | let &ft=ft | 0
    nnoremap <buffer> q :q<CR>`Z
    diffthis | wincmd p | diffthis | wincmd p
endfunction

function commander#git#load_patch(revision)
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    let commit = (a:revision != '' ? a:revision : 'HEAD')
    let content = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' diff '.ref.' -- ' . expand('%:t'))
    let b:alt_save = expand('#')
    enew | call append(0, content) | $delete
    let b:orig = expand('#')
    execute 'file '.commit | set buftype=nofile bufhidden=wipe nobuflisted noswapfile ft=diff | 0
    nnoremap <buffer> <silent> q :execute 'buffer '.b:orig.' \| let @# = b:alt_save'<CR>
endfunction

function commander#git#load_timeline()
    let content = commander#git#file_revisions()
    let b:alt_save = expand('#')
    enew | call append(0, content) | $delete
    let b:orig = expand('#')
    execute 'file '.expand('#').'.timeline' | set buftype=nofile bufhidden=wipe nobuflisted noswapfile ft=gitlog | 0
    nnoremap <buffer> <silent> q :execute 'buffer '.b:orig.' \| let @# = b:alt_save'<CR>
endfunction

function commander#git#load_revision_in_split(revision)
    let content = commander#git#file_revision(a:revision)
    mark Z
    topleft vnew | call append(0, content) | $delete
    execute 'file '.expand('#').'.timeline' | set buftype=nofile bufhidden=wipe nobuflisted noswapfile ft=git | 0
    nnoremap <buffer> q :q<CR>`Z
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
