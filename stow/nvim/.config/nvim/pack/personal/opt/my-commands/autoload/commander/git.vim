" Split path into directory and filename
function s:pathsplit(fpath)
    let fpath = expand(a:fpath)
    return [fnamemodify(fpath, ':p:h'), fnamemodify(fpath, ':t')]
endfunction

" HEAD revision
function commander#git#get_head(directory)
    return systemlist('git -C ' . shellescape(a:directory) . ' log @ --format=%h\ %d\ %s\ \(%cr\)')[0]
endfunction

" Get all revisions
function commander#git#revisions(directory)
    return systemlist('git -C ' . shellescape(a:directory) . ' log --format=%h\ %d\ %s\ \(%cr\)')
endfunction

" Get a single revision
function commander#git#revision(revision, directory)
    let ref = (a:revision != '' ? split(a:revision)[0] : get(t:, 'diff_target', 'HEAD'))
    return systemlist('git -C '.shellescape(a:directory).' show '.ref)
endfunction

" Get revisions for a file
function commander#git#file_revisions(path)
    let [fdir, fname] = s:pathsplit(a:path)
    return systemlist('git -C ' . shellescape(fdir) . ' log --no-patch --format=%h\ %d\ %s\ \(%cr\) -- ' . fname)
endfunction

" Get revisions for lines in a file
function commander#git#line_revisions(line1, line2, path)
    let [fdir, fname] = s:pathsplit(a:path)
    return systemlist('git -C ' . shellescape(fdir) . ' log -L '.a:line1.','.a:line2.':'.fname.' --no-patch --format=%h\ %d\ %s\ \(%cr\)')
endfunction

" Show a file revision
function commander#git#file_version(revision, path)
    let [fdir, fname] = s:pathsplit(a:path)
    let ref = (a:revision != '' ? split(a:revision)[0] : get(t:, 'diff_target', 'HEAD'))
    let lines = systemlist('git -C '.shellescape(fdir).' show '.ref.':./'.fname)
    if v:shell_error
        echoerr join(lines, "\n")
    else
        return lines
    endif
endfunction

function commander#git#blame(line1, line2, ...)
    let path = a:0 ? a:1 : expand('%')
    let [fdir, fname] = s:pathsplit(path)
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
    call nvim_buf_set_extmark(0, ns, lnum, 0, {'virt_text': [['    '.text, 'Comment']]})
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

function commander#git#diff_this(revision, path)
    if empty(a:path)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = a:path.'@'.(a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD'))
    let lines = commander#git#file_version(a:revision, a:path)
    if empty(lines)|return -1|endif
    let bufnr = commander#lib#temp_buffer(lines, bufname, &ft, {'cmd': 'leftabove vertical new'})

    if bufnr > 0
        diffthis
        au BufWipeout <buffer> diffoff!
        wincmd p
        diffthis
    endif

    return bufnr
endfunction

function commander#git#patch_this(split, revision, path) abort
    if empty(a:path)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = a:path.' VS '.(a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD'))
    let ref = (a:revision != '' ? split(a:revision)[0] : get(t:, 'diff_target', 'HEAD'))
    let lines = systemlist('git -C '.shellescape(fdir).' diff '.ref.' -- '.fname)
    if empty(lines)|return -1|endif
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'diff', {'cmd': cmd})

    return bufnr
endfunction

function commander#git#load_patch_for(split, revision, path) abort
    if empty(a:path)|return|endif
    if empty(a:revision)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = 'PATCH: '.a:path.'@'.(a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD'))
    let ref = split(a:revision)[0]
    let lines = systemlist('git -C '.shellescape(fdir).' diff '.ref.'~ '.ref.' -- '.fname)
    if empty(lines)|return -1|endif
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'diff', {'cmd': cmd})

    return bufnr
endfunction

function commander#git#load_patch_between(split, last, first, path) abort
    if empty(a:path)|return|endif
    if empty(a:last) || empty(a:first)|return|endif
    if a:last == a:first
        return commander#git#load_patch_for(a:split, a:last, a:path)
    endif

    let [fdir, fname] = s:pathsplit(a:path)
    let last_ref = split(a:last)[0]
    let first_ref = split(a:first)[0]
    let bufname = 'PATCH: '.a:path.'@ '.first_ref.' -> '.last_ref
    let lines = systemlist('git -C '.shellescape(fdir).' diff '.first_ref.'~ '.last_ref.' -- '.fname)
    if empty(lines)|return -1|endif
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'diff', {'cmd': cmd})

    return bufnr
endfunction

function commander#git#load_timeline(split, line1, line2, range, path)
    " When we don't have a path, we cannot create a timeline. Just show the
    " log for the instead.
    if !filereadable(a:path)|return commander#git#load_log(a:split, a:path)|endif

    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = 'TIMELINE: '..fname..(a:range ? ':'..a:line1..','..a:line2 : '')..' '..commander#git#get_head(fdir)
    let cmd = a:split ? 'leftabove vertical new' : 'enew'
    let ft=&ft
    let lines = commander#git#line_revisions(a:line1, a:line2, a:path)
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'gitlog', {'cmd': cmd})
    if bufnr > 0
        let b:peek_patch = { line1, line2 -> commander#git#load_patch_between(1, getline(line1), getline(line2), fdir.'/'.fname) }
        let b:open_file = { -> commander#git#load_file_version(getline('.'), fdir.'/'.fname, ft, 0) }
        let b:peek_file = { -> commander#git#load_file_version(getline('.'), fdir.'/'.fname, ft, 1) }
        let b:open_commit = { -> commander#git#load_revision(getline('.'), fdir, 0) }
        let b:peek_commit = { -> commander#git#load_revision(getline('.'), fdir, 1) }
    endif
    return bufnr
endfunction

function commander#git#load_log(split, path)
    let path = isdirectory(a:path) ? a:path : getcwd()
    let cmd = a:split ? 'leftabove vertical new' : 'enew'
    let bufname = 'GITLOG: '..commander#git#get_head(path)
    let lines = commander#git#revisions(path)
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'gitlog', {'cmd': cmd})
    if bufnr > 0
        let b:open_commit = { -> commander#git#load_revision(getline('.'), path, 0) }
        let b:peek_commit = { -> commander#git#load_revision(getline('.'), path, 1) }
    endif
    return bufnr
endfunction

function commander#git#load_revision(revision, directory, split)
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufname = a:revision
    let lines = commander#git#revision(a:revision, a:directory)
    if empty(lines)|return -1|endif
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'git', {'cmd': cmd})
    return bufnr
endfunction

function commander#git#load_file_version(revision, path, filetype, split)
    let cmd = a:split ? 'vertical new' : 'enew'
    if empty(a:path)|return|endif
    let bufname = a:path.'@'.(a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD'))
    let lines = commander#git#file_version(a:revision, a:path)
    if empty(lines)|return -1|endif
    let bufnr = commander#lib#temp_buffer(lines, bufname, a:filetype, {'cmd': cmd})
    return bufnr
endfunction

function commander#git#set_changed_args(...)
    let ref = a:0 && !empty(a:1) ? split(a:1)[0] : get(t:, 'diff_target', 'HEAD')
    let cwd = getcwd()
    let gitdir = finddir('.git', ';')
    if empty(gitdir)
        " We might be in a worktree where '.git' is not a directory
        let gitdir = findfile('.git', ';')
    endif
    if empty(gitdir)
        echoerr "You don't seem to be inside a git repository."
        return
    endif
    let gitroot = fnamemodify(gitdir, ':h')
    let changed = systemlist('git diff --name-only '.ref.' -- .')
    let absolute = map(changed, { k, v -> gitroot.'/'.v })
    let resolved = map(absolute, { k, v -> resolve(v) })
    let relative = map(resolved, { k, v -> fnamemodify(v, ':.') })
    let filepaths = filter(relative, { k, v -> findfile(v, ',,') != '' })

    %argd
    for path in filepaths
        execute 'argadd '.path
    endfor
endfunction

function commander#git#set_diff_target(...)
    if !a:0
        if exists('t:diff_target')
            unlet t:diff_target
        endif
    elseif empty(a:1)
        echo 'Diffing against: '..get(t:, 'diff_target', 'HEAD')
    else
        let t:diff_target = split(a:1)[0]
    endif
endfunction

function commander#git#review(ref)
    tab split
    call commander#git#set_diff_target(a:ref)
    arglocal
    try
        call commander#git#set_changed_args()
        first
    catch
        echo v:exception
        tabclose
    endtry
endfunction
