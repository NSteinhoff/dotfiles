" Return the window numbers of the current tab page where the buffer <bufname>
" is visible. Does a full match on the buffer name.
function s:tab_win_findbuf(bufname, tabpagenr) abort
    let fullmatch = '^'..a:bufname..'$'
    let bs = getbufinfo(fullmatch)
    if len(bs) != 1|return []|endif
    let b = bs[0]

    let ts = gettabinfo(a:tabpagenr)
    if len(ts) != 1|return []|endif
    let t = ts[0]

    let indeces = map(b.windows, { _, window -> index(t.windows, window) })
    let indeces = filter(indeces, { _, idx -> idx != -1 } )
    return map(indeces, { _, idx -> idx + 1 })
endfunction

" Go the the window in the tabpage that displays the buffer.
" Returns the window number or '0' otherwise.
"
" Exmaple:
"
"     if s:tab_win_gotobuf(b, t)|return|endif
"
function s:tab_win_gotobuf(bufname, tabpagenr)
    let window = get(s:tab_win_findbuf(a:bufname, a:tabpagenr), 0)
    if window
        execute window..'wincmd w'
        return window
    endif
endfunction

" Split path into directory and filename
function s:pathsplit(fpath)
    let fpath = expand(a:fpath)
    return [fnamemodify(fpath, ':p:h'), fnamemodify(fpath, ':t')]
endfunction

" Get revisions in current file's repo
function commander#git#local_revisions(...)
    let path = a:0 ? a:1 : expand('%')
    let [fdir, fname] = s:pathsplit(path)
    return systemlist('git -C ' . shellescape(fdir) . ' log --format=%h\ %d\ %s\ \(%cr\)')
endfunction

" HEAD revision
function commander#git#get_head()
    return systemlist('git -C ' . shellescape(getcwd()) . ' log @ --format=%h\ %d\ %s\ \(%cr\)')[0]
endfunction

" Get revisions
function commander#git#global_revisions()
    return systemlist('git -C ' . shellescape(getcwd()) . ' log --format=%h\ %d\ %s\ \(%cr\)')
endfunction

" Get revisions for a file
function commander#git#file_revisions(...)
    let path = a:0 ? a:1 : expand('%')
    let [fdir, fname] = s:pathsplit(path)
    return systemlist('git -C ' . shellescape(fdir) . ' log --no-patch --format=%h\ %d\ %s\ \(%cr\) -- ' . fname)
endfunction

" Get revisions for lines in a file
function commander#git#line_revisions(line1, line2, ...)
    let path = a:0 ? a:1 : expand('%')
    let [fdir, fname] = s:pathsplit(path)
    return systemlist('git -C ' . shellescape(fdir) . ' log -L '.a:line1.','.a:line2.':'.fname.' --no-patch --format=%h\ %d\ %s\ \(%cr\)')
endfunction

" Show a local revision
function commander#git#local_revision(revision, ...)
    let ref = (a:revision != '' ? split(a:revision)[0] : get(t:, 'diff_target', 'HEAD'))
    let path = a:0 ? a:1 : expand('%')
    let [fdir, fname] = s:pathsplit(path)
    return systemlist('git -C '.shellescape(fdir).' show '.ref)
endfunction

" Show a file revision
function commander#git#local_file_revision(revision, ...)
    let path = a:0 ? a:1 : expand('%')
    let [fdir, fname] = s:pathsplit(path)
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

function commander#git#load_diff(split, revision, ...)
    let path = a:0 ? a:1 : expand('%')
    if empty(path)|return|endif
    let [fdir, fname] = s:pathsplit(path)
    let bufname = (a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD')).':'.fname
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let ft = &ft
    try
        let content = call('commander#git#local_file_revision', [a:revision] + a:000)
        diffthis
        if a:split
            call commander#lib#load_lines_in_split(content, 'leftabove vertical')
        else
            call commander#lib#load_lines(content)
        endif
        diffthis
        execute 'file '.bufname
        let &ft=ft
        au BufWipeout <buffer> diffoff!
        wincmd p
    catch
        diffoff!
        echom v:exception
    endtry
endfunction

function commander#git#load_patch(split, revision, ...) abort
    let bufname = expand('#').'.'.(a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD'))
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let path = a:0 ? a:1 : expand('%')
    if empty(path)|return|endif
    let [fdir, fname] = s:pathsplit(path)
    let ref = (a:revision != '' ? split(a:revision)[0] : get(t:, 'diff_target', 'HEAD'))
    let content = systemlist('git -C '.shellescape(fdir).' diff '.ref.' -- '.fname)
    if a:split
        call commander#lib#load_lines_in_split(content)
    else
        call commander#lib#load_lines(content)
    endif
    execute 'file '.bufname
    set ft=diff
endfunction

function commander#git#load_patch_for(revision, ...) abort
    let bufname = expand('#').'.'.a:revision
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let path = a:0 ? a:1 : expand('%')
    if empty(path)|return|endif
    let [fdir, fname] = s:pathsplit(path)

    let ref = split(a:revision)[0]
    let content = systemlist('git -C '.shellescape(fdir).' diff '.ref.'~ '.ref.' -- '.fname)
    call commander#lib#load_lines_in_split(content)
    execute 'file '.bufname
    set ft=diff
endfunction

function commander#git#load_patch_between(last, first, ...) abort
    if a:last == a:first
        return call('commander#git#load_patch_for', [a:last] + a:000)
    endif

    let bufname = expand('#').'.'.a:first.' -> '.a:last
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let path = a:0 ? a:1 : expand('%')
    if empty(path)|return|endif
    let [fdir, fname] = s:pathsplit(path)

    let last_ref = split(a:last)[0]
    let first_ref = split(a:first)[0]
    let content = systemlist('git -C '.shellescape(fdir).' diff '.first_ref.'~ '.last_ref.' -- '.fname)
    call commander#lib#load_lines_in_split(content)
    execute 'file '.bufname
    set ft=diff
endfunction

function commander#git#load_timeline(split, line1, line2, range, ...)
    let path = a:0 ? a:1 : expand('%')

    " When we don't have a path, we cannot create a timeline. Just show the
    " log instead.
    if empty(path)|return commander#git#load_log(a:split)|endif

    let [fdir, fname] = s:pathsplit(path)
    let bufname = 'TIMELINE: '..fname..(a:range ? ':'..a:line1..','..a:line2 : '')..' '..commander#git#get_head()
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let ft=&ft
    let content = call('commander#git#line_revisions', [a:line1, a:line2] + a:000)
    if a:split
        call commander#lib#load_lines_in_split(content, 'left vertical')
    else
        call commander#lib#load_lines(content)
    endif
    execute 'file '.bufname
    set ft=gitlog
    let b:peek_patch = { line1, line2 -> commander#git#load_patch_between(getline(line1), getline(line2), fdir.'/'.fname) }
    let b:open_file = { -> commander#git#load_file_revision(getline('.'), fdir.'/'.fname, ft) }
    let b:peek_file = { -> commander#git#load_file_revision_in_split(getline('.'), fdir.'/'.fname, ft) }
    let b:open_commit = { -> commander#git#load_revision(getline('.')) }
    let b:peek_commit = { -> commander#git#load_revision_in_split(getline('.')) }
endfunction

function commander#git#load_log(split, ...)
    let bufname = 'GITLOG: '..commander#git#get_head()
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let ft=&ft
    let content = commander#git#global_revisions()
    let bufnr = a:split
                \ ? commander#lib#load_lines_in_split(content, 'left vertical')
                \ : commander#lib#load_lines(content)

    if bufnr == -1|return|endif

    execute 'file '.bufname
    set ft=gitlog
    let b:open_commit = { -> commander#git#load_revision(getline('.')) }
    let b:peek_commit = { -> commander#git#load_revision_in_split(getline('.')) }
endfunction

function commander#git#load_revision(revision)
    let bufname = a:revision
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let content = commander#git#local_revision(a:revision)
    call commander#lib#load_lines(content)
    set ft=git
    execute 'file '.bufname
endfunction

function commander#git#load_revision_in_split(revision)
    let bufname = a:revision
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let content = commander#git#local_revision(a:revision)
    call commander#lib#load_lines_in_split(content)
    set ft=git
    execute 'file '.bufname
endfunction

function commander#git#load_file_revision(revision, ...)
    let path = a:0 ? a:1 : expand('%')
    if empty(path)|return|endif
    let [fdir, fname] = s:pathsplit(path)

    let bufname = fdir.'/'.fname.'@'.(a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD'))
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let ft = a:0 >= 2 ? a:2 : &ft
    try
        let content = call('commander#git#local_file_revision', [a:revision] + a:000)
        call commander#lib#load_lines(content)
        execute 'file '.bufname
        let &ft=ft
    catch
        echom v:exception
    endtry
endfunction

function commander#git#load_file_revision_in_split(revision, ...)
    let path = a:0 ? a:1 : expand('%')
    if empty(path)|return|endif
    let [fdir, fname] = s:pathsplit(path)
    let bufname = fdir.'/'.fname.'@'.(a:revision != '' ? a:revision : get(t:, 'diff_target', 'HEAD'))
    if s:tab_win_gotobuf(bufname, tabpagenr())|return|endif

    let ft = a:0 >= 2 ? a:2 : &ft
    try
        let content = call('commander#git#local_file_revision', [a:revision] + a:000)
        call commander#lib#load_lines_in_split(content, 'vertical')
        execute 'file '.bufname
        let &ft=ft
    catch
        echom v:exception
    endtry
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
