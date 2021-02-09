" Split path into directory and filename
function s:pathsplit(fpath)
    let fpath = expand(a:fpath)
    return [fnamemodify(fpath, ':p:h'), fnamemodify(fpath, ':t')]
endfunction

" Get revisions in current file's repo
function commander#git#local_revisions(...)
    let [fdir, _] = s:pathsplit(a:0 ? a:1 : '%')
    return systemlist('git -C ' . shellescape(fdir) . ' log --format=%h\ %s\ \(%ar\)')
endfunction

" Get revisions
function commander#git#global_revisions()
    return systemlist('git -C ' . shellescape(getcwd()) . ' log --format=%h\ %s\ \(%ar\)')
endfunction

" Get revisions for a file
function commander#git#file_revisions(...)
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    return systemlist('git -C ' . shellescape(fdir) . ' log --no-patch --format=%h\ %s\ \(%ar\) -- ' . fname)
endfunction

" Get revisions for lines in a file
function commander#git#line_revisions(line1, line2, ...)
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    return systemlist('git -C ' . shellescape(fdir) . ' log -L '.a:line1.','.a:line2.':'.fname.' --no-patch --format=%h\ %s\ \(%ar\)')
endfunction

" Show a local revision
function commander#git#local_revision(revision, ...)
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    let [fdir, _] = s:pathsplit(a:0 ? a:1 : '%')
    return systemlist('git -C '.shellescape(fdir).' show '.ref)
endfunction

" Show a file revision
function commander#git#local_file_revision(revision, ...)
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    return systemlist('git -C '.shellescape(fdir).' show '.ref.':./'.fname)
endfunction

function commander#git#blame(line1, line2, ...)
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    return systemlist('git -C '.shellescape(fdir).' blame -L '.a:line1.','.a:line2.' --date=short '.fname)
endfunction

function s:blame_update()
    let b:blame = call('commander#git#blame', [1, line('$')])
endfunction

function s:blame_mark(lnum)
    let lnum = a:lnum - 1
    let text = get(get(b:, 'blame', []), lnum, '')
    let ns = nvim_create_namespace('git_blame')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
    call nvim_buf_set_virtual_text(0, ns, lnum, [['    '.text, 'Comment']], {})
endfunction

function commander#git#blame_on()
    call s:blame_update()
    call s:blame_mark(line('.'))
    aug blame
        au!
        au CursorMoved <buffer> call s:blame_mark(line('.'))
        au TextChanged <buffer> call s:blame_update()
    aug END
endfunction

function commander#git#blame_off()
    au! blame
    call commander#git#blame_clear()
endfunction

function commander#git#blame_clear()
    let ns = nvim_create_namespace('git_blame')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
endfunction

function commander#git#blame_lense(line1, line2, ...)
    let blame = call('commander#git#blame', [a:line1, a:line2] + a:000)
    let ns = nvim_create_namespace('git_blame')
    call nvim_buf_clear_namespace(0, ns, a:line1-1, a:line2-1)
    let blamelines = map(blame, { i, v -> [i+a:line1-1, v] })
    for [lnum, text] in blamelines
        call nvim_buf_set_virtual_text(0, ns, lnum, [[text, 'Comment']], {})
    endfor
endfunction

function commander#git#load_diff_in_split(revision, ...)
    let ft = &ft
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    let content = call('commander#git#local_file_revision', [a:revision] + a:000)
    call commander#lib#load_lines_in_split(content, 'vertical')
    execute 'file '.(a:revision != '' ? a:revision : 'HEAD').':'.fname
    let &ft=ft
    au BufWipeout <buffer> diffoff!
    windo diffthis
endfunction

function commander#git#load_patch(revision, ...) abort
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    let content = systemlist('git -C '.shellescape(fdir).' diff '.ref.' -- '.fname)
    call commander#lib#load_lines(content)
    execute 'file '.expand('#').'.'.(a:revision != '' ? a:revision : 'HEAD')
    set ft=diff
endfunction

function commander#git#load_timeline(split, line1, line2, ...)
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    let ft=&ft
    let content = call('commander#git#line_revisions', [a:line1, a:line2] + a:000)
    if a:split
        call commander#lib#load_lines_in_split(content, 'vertical')
    else
        call commander#lib#load_lines(content)
    endif
    execute 'file '.fdir.'/'.fname.'.timeline'
    set ft=gitlog
    let b:open = { -> commander#git#load_file_revision(getline('.'), fdir.'/'.fname, ft) }
    let b:peek = { -> commander#git#load_file_revision_in_split(getline('.'), fdir.'/'.fname, ft) }
    let b:open_commit = { -> commander#git#load_revision(getline('.')) }
    let b:peek_commit = { -> commander#git#load_revision_in_split(getline('.')) }
endfunction

function commander#git#load_revision(revision)
    let content = commander#git#local_revision(a:revision)
    call commander#lib#load_lines(content)
    set ft=git
    execute 'file '.a:revision
endfunction

function commander#git#load_revision_in_split(revision)
    let content = commander#git#local_revision(a:revision)
    call commander#lib#load_lines_in_split(content, 'vertical')
    set ft=git
    execute 'file '.a:revision
endfunction

function commander#git#load_file_revision(revision, ...)
    let ft = a:0 >= 2 ? a:2 : &ft
    let content = call('commander#git#local_file_revision', [a:revision] + a:000)
    call commander#lib#load_lines(content)
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    execute 'file '.fdir.'/'.fname.'@'.(a:revision != '' ? a:revision : 'HEAD')
    let &ft=ft
endfunction

function commander#git#load_file_revision_in_split(revision, ...)
    let ft = a:0 >= 2 ? a:2 : &ft
    let content = call('commander#git#local_file_revision', [a:revision] + a:000)
    call commander#lib#load_lines_in_split(content, 'vertical')
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    execute 'file '.fdir.'/'.fname.'@'.(a:revision != '' ? a:revision : 'HEAD')
    let &ft=ft
endfunction

function commander#git#set_changed_args(...)
    let ref = a:0 && !empty(a:1) ? split(a:1)[0] : 'HEAD'
    let cwd = getcwd()
    let gitdir = finddir('.git', ';')
    if gitdir == ''
        return
    endif
    let gitroot = fnamemodify(gitdir, ':h')
    let changed = systemlist('git diff --name-only '.ref.' -- .')
    let absolute = map(changed, { k, v -> gitroot.'/'.v })
    let resolved = map(absolute, { k, v -> resolve(v) })
    let relative = map(resolved, { k, v -> fnamemodify(v, ':.') })
    let filepaths = filter(relative, { k, v -> findfile(v) != '' })

    %argd
    for path in filepaths
        execute 'argadd '.path
    endfor
endfunction
