let s:revision_format = '%h\ %d\ %s\ \(%cr\)'

function s:ref(revision)
    return a:revision != '' ? split(a:revision)[0] : get(t:, 'diff_target', 'HEAD')
endfunction

" Split path into directory and filename
function s:pathsplit(fpath)
    let fpath = expand(a:fpath)
    if isdirectory(fpath)
        return [fnamemodify(fpath, ':p'), '']
    endif
    return [fnamemodify(fpath, ':p:h'), fnamemodify(fpath, ':t')]
endfunction

function s:git(dir, cmd)
    let cmd = 'git -C '..shellescape(a:dir)..' '..a:cmd
    let result = systemlist(cmd)
    if v:shell_error
        echoerr "Git ("..v:shell_error.."): "..result[0].." Running '"..cmd.."'"
        return []
    endif
    return result
endfunction

command -nargs=* Test echo s:git(getcwd(), <q-args>)

" -------------------------------- Revision ----------------------------------
" HEAD revision
function commander#git#head(directory)
    return s:git(a:directory, ' show @ --format='..s:revision_format)[0]
endfunction

" Get a single revision
function commander#git#revision(revision, directory)
    let ref = s:ref(a:revision)
    return s:git(a:directory, ' show '..ref)
endfunction

" ----------------------------------- Log ------------------------------------
" Get all revisions
function commander#git#log(directory)
    return s:git(a:directory, ' log --format='..s:revision_format)
endfunction

" Get revisions for a file
function commander#git#file_log(path)
    let [fdir, fname] = s:pathsplit(a:path)
    return s:git(fdir, ' log --no-patch --format='..s:revision_format..' -- '..fname)
endfunction

" Get revisions for lines in a file
function commander#git#line_log(line1, line2, path)
    let [fdir, fname] = s:pathsplit(a:path)
    return s:git(fdir, ' log -L '..a:line1..','..a:line2..':'..fname..' --no-patch --format='..s:revision_format)
endfunction

" ------------------------------ File Version --------------------------------
" Show a file revision
function commander#git#file_version(revision, path)
    let [fdir, fname] = s:pathsplit(a:path)
    let ref = s:ref(a:revision)
    let lines = s:git(fdir, ' show '..ref..':./'..fname)
    if v:shell_error
        echoerr join(lines, "\n")
    else
        return lines
    endif
endfunction


" -------------------------------------------------------------------------- "
"                                   Blame                                    "
" -------------------------------------------------------------------------- "
function commander#git#blame(line1, line2)
    let [fdir, fname] = s:pathsplit(@%)
    return s:git(fdir, ' blame -L '..a:line1..','..a:line2..' --date=short '..fname)
endfunction

function s:blame_update()
    let b:blame = commander#git#blame(1, line('$'))
endfunction

function s:blame_mark(lnum)
    let lnum = a:lnum - 1
    let text = get(get(b:, 'blame', []), lnum, '')
    let ns = nvim_create_namespace('git_blame')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
    call nvim_buf_set_extmark(0, ns, lnum, 0, {'virt_text': [['    '..text, 'Comment']]})
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

" -------------------------------------------------------------------------- "
"                                  Usecases                                  "
" -------------------------------------------------------------------------- "
function commander#git#side_by_side_diff(revision, path)
    if empty(a:path)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = a:path..'@'..s:ref(a:revision)
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

function commander#git#inline_diff(split, revision, path) abort
    if empty(a:path)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = a:path..' VS '..s:ref(a:revision)
    let ref = s:ref(a:revision)
    let lines = s:git(fdir, ' diff '..ref..' -- '..fname)
    if empty(lines)|return -1|endif
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'diff', {'cmd': cmd})

    return bufnr
endfunction

function commander#git#show_diff(split, from, until, path) abort
    if empty(a:path)|return|endif
    if empty(a:until) || empty(a:from)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let until = split(a:until)[0]
    let from = split(a:from)[0]
    let bufname = 'PATCH: '..a:path..'@'..(from == until ? until : from..'..'..until)
    let lines = s:git(fdir, ' diff '..from..'~ '..until..(!empty(fname) ? ' -- '..fname : ''))
    if empty(lines)|return -1|endif
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'diff', {'cmd': cmd})

    return bufnr
endfunction

function commander#git#show_timeline(split, line1, line2, range, path)
    " When we don't have a path, we cannot create a timeline. Just show the
    " log for path the instead.
    if !filereadable(a:path)|return commander#git#show_log(a:split, a:path)|endif

    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = 'TIMELINE: '..fname..(a:range ? ':'..a:line1..','..a:line2 : '')..' '..commander#git#head(fdir)
    let cmd = a:split ? 'leftabove vertical new' : 'enew'
    let ft=&ft
    let lines = commander#git#line_log(a:line1, a:line2, a:path)
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'gitlog', {'cmd': cmd})
    if bufnr > 0
        let b:peek_patch  = { line1, line2 -> commander#git#show_diff(1, getline(line2), getline(line1), fdir..'/'..fname) }
        let b:open_file   = { -> commander#git#show_file_version(getline('.'), fdir..'/'..fname, ft, 0) }
        let b:peek_file   = { -> commander#git#show_file_version(getline('.'), fdir..'/'..fname, ft, 1) }
        let b:open_commit = { -> commander#git#show_revision(getline('.'), fdir, 0) }
        let b:peek_commit = { -> commander#git#show_revision(getline('.'), fdir, 1) }
    endif
    return bufnr
endfunction

function commander#git#show_log(split, path)
    let path = isdirectory(a:path) ? a:path : getcwd()
    let cmd = a:split ? 'leftabove vertical new' : 'enew'
    let bufname = 'GITLOG: '..commander#git#head(path)
    let lines = commander#git#log(path)
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'gitlog', {'cmd': cmd})
    if bufnr > 0
        let b:peek_patch  = { line1, line2 -> commander#git#show_diff(1, getline(line2), getline(line1), path) }
        let b:open_commit = { -> commander#git#show_revision(getline('.'), path, 0) }
        let b:peek_commit = { -> commander#git#show_revision(getline('.'), path, 1) }
    endif
    return bufnr
endfunction

function commander#git#show_revision(revision, directory, split)
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufname = a:revision
    let lines = commander#git#revision(a:revision, a:directory)
    if empty(lines)|return -1|endif
    let bufnr = commander#lib#temp_buffer(lines, bufname, 'git', {'cmd': cmd})
    return bufnr
endfunction

function commander#git#show_file_version(revision, path, filetype, split)
    let cmd = a:split ? 'vertical new' : 'enew'
    if empty(a:path)|return|endif
    let bufname = a:path..'@'..s:ref(a:revision)
    let lines = commander#git#file_version(a:revision, a:path)
    if empty(lines)|return -1|endif
    let bufnr = commander#lib#temp_buffer(lines, bufname, a:filetype, {'cmd': cmd})
    return bufnr
endfunction

function commander#git#load_changed_files(...)
    let ref = s:ref(a:0 ? a:1 : '')
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
    let changed = s:git(getcwd(), 'diff --name-only '..ref..' -- .')
    let absolute = map(changed, { k, v -> gitroot..'/'..v })
    let resolved = map(absolute, { k, v -> resolve(v) })
    let relative = map(resolved, { k, v -> fnamemodify(v, ':.') })
    let filepaths = filter(relative, { k, v -> findfile(v, ',,') != '' })

    %argd
    for path in filepaths
        execute 'argadd '..path
    endfor
endfunction

function commander#git#set_diff_target(reset, revision)
    if a:reset
        if exists('t:diff_target')
            unlet t:diff_target
        endif
    elseif empty(a:revision)
        echo 'Diffing against: '..get(t:, 'diff_target', 'HEAD')
    else
        let t:diff_target = split(a:revision)[0]
    endif
endfunction

function commander#git#review(revision)
    tab split
    call commander#git#set_diff_target(0, a:revision)
    arglocal
    try
        call commander#git#load_changed_files()
        first
    catch
        echo v:exception
        tabclose
    endtry
endfunction
