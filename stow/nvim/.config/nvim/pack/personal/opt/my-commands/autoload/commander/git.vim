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

function commander#git#load_diff_in_split(revision, ...)
    let ft = &ft
    let content = call('commander#git#local_file_revision', [a:revision] + a:000)
    call commander#lib#load_lines_in_split(content, 'vertical')
    execute 'file '.(a:revision != '' ? a:revision : 'HEAD')
    let &ft=ft
    au BufWipeout <buffer> diffoff!
    diffthis | wincmd p | diffthis | wincmd p
endfunction

function commander#git#load_patch(revision, ...) abort
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    let ref = (a:revision != '' ? split(a:revision)[0] : 'HEAD')
    let content = systemlist('git -C '.shellescape(fdir).' diff '.ref.' -- '.fname)
    call commander#lib#load_lines(content)
    execute 'file '.expand('#').'.'.(a:revision != '' ? a:revision : 'HEAD')
    set ft=diff
endfunction

function commander#git#load_timeline(line1, line2, ...)
    let [fdir, fname] = s:pathsplit(a:0 ? a:1 : '%')
    let ft=&ft
    let content = call('commander#git#line_revisions', [a:line1, a:line2] + a:000)
    call commander#lib#load_lines(content)
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
