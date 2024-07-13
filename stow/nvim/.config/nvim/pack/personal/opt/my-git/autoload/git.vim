let s:revision_format = '%h\ %d\ %s\ \(%cr\)'

function s:git(dir, cmd)
    let cmd = 'git -C '..shellescape(a:dir)..' '..a:cmd
    let result = systemlist(cmd)
    if v:shell_error
        echoerr "Git ("..v:shell_error.."): "..result[0].." Running '"..cmd.."'"
        return []
    endif
    return result
endfunction

function s:gitroot()
    let gitdir = finddir('.git', ';')
    if empty(gitdir)
        " We might be in a worktree where '.git' is not a directory
        let gitdir = findfile('.git', ';')
    endif
    if empty(gitdir)
        echoerr "You don't seem to be inside a git repository."
        return ''
    endif
    return fnamemodify(gitdir, ':h')
endfunction

function s:main()
    let branches = s:git(getcwd(), "branch --list --format='%(refname:short)'")->filter({_, v -> v =~ 'main\|master'})
    return branches[0]
endfunction

function s:ref(revision, default = 'HEAD')
    return a:revision != '' ? split(a:revision)[0] : get(t:, 'diff_target', a:default)
endfunction

function s:can_be_alt(bufname)
    return !empty(a:bufname) && buflisted(a:bufname)
endfunction

function s:temp_buffer(lines, name, filetype, options = {})
    let name = 'my-git://'..escape(a:name, '"#%')
    let bufnr = bufnr('^'..name..'$')
    if bufnr > 0
        " execute 'buffer '..bufnr
        return bufnr
    endif

    let create = get(a:options, 'cmd', 'enew')
    let winfix = get(a:options, 'winfix', v:false)

    let undosteps = []
    if !empty(@%)
        call add(undosteps, "buffer "..bufnr('%').."")
    endif

    if s:can_be_alt(@#)
        call add(undosteps, "let @# = '"..bufnr('#').."'")
    endif

    let initsteps = []
    if s:can_be_alt(@#)
        call add(initsteps, "let @# = '"..bufnr('#').."'")
    endif
    call add(initsteps, "file "..name) 
    call add(initsteps, "set ft="..a:filetype) 

    try
        execute create
        set buftype=nofile bufhidden=wipe nobuflisted noswapfile
        if winfix
            set winfixbuf
        endif
    catch
        echom 'Unable to create buffer: '.v:exception
        for step in undosteps|execute step|endfor
    endtry

    try
        call append(0, a:lines) | $delete
    catch
        echom 'Unable to load lines: '.v:exception
        for step in undosteps|execute step|endfor

        return -1
    endtry

    for step in initsteps
        try
            execute step
        catch
            echom "Error executing init step '"..step.."'"
            for step in undosteps|execute step|endfor
            return -1
        endtry
    endfor

    1 " Got to the first line
    return bufnr()
endfunction

" Show a file revision
function s:file_version(ref, path)
    let [fdir, fname] = s:pathsplit(a:path)
    let lines = s:git(fdir, 'show '..a:ref..':./'..fname)
    if v:shell_error
        echoerr join(lines, "\n")
    else
        return lines
    endif
endfunction

" Split path into directory and filename
function s:pathsplit(fpath)
    let fpath = resolve(expand(a:fpath))
    if isdirectory(fpath)
        return [fnamemodify(fpath, ':p'), '']
    endif
    return [fnamemodify(fpath, ':p:h'), fnamemodify(fpath, ':t')]
endfunction

" -------------------------------- Revision ----------------------------------
" HEAD revision
function s:head(directory)
    return s:git(a:directory, 'show @ --format='..s:revision_format)[0]
endfunction

" Get a single revision
function s:revision(revision, directory)
    let ref = s:ref(a:revision)
    return s:git(a:directory, 'show '..ref)
endfunction

" ----------------------------------- Log ------------------------------------
" Get all revisions
function git#log(directory, args = '')
    return s:git(a:directory, 'log --format='..s:revision_format..' '..a:args)
endfunction

" Get revisions for a file
function git#file_log(path)
    let [fdir, fname] = s:pathsplit(a:path)
    return s:git(fdir, 'log --no-patch --format='..s:revision_format..' -- '..fname)
endfunction

" Get revisions for lines in a file
function s:line_log(line1, line2, path)
    let [fdir, fname] = s:pathsplit(a:path)
    return s:git(fdir, 'log -L '..a:line1..','..a:line2..':'..fname..' --no-patch --format='..s:revision_format)
endfunction

" -------------------------------------------------------------------------- "
"                                   Blame                                    "
" -------------------------------------------------------------------------- "
function git#blame(line1, line2)
    let [fdir, fname] = s:pathsplit(@%)
    return s:git(fdir, 'blame -L '..a:line1..','..a:line2..' --date=short '..fname)
endfunction

function s:blame_update()
    let b:blame = git#blame(1, line('$'))
endfunction

function s:blame_mark(lnum)
    let lnum = a:lnum - 1
    let text = get(get(b:, 'blame', []), lnum, '')
    let ns = nvim_create_namespace('git_blame')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
    call nvim_buf_set_extmark(0, ns, lnum, 0, {'virt_text': [['    '..text, 'Comment']]})
endfunction

function s:blame_enabled()
    return exists('#my-git-blame')
endfunction

function git#blame_toggle()
    if s:blame_enabled()
        call git#blame_off()
    else
        call git#blame_on()
    endif
endfunction

function git#blame_on()
    if s:blame_enabled()|return|endif
    call s:blame_update()
    call s:blame_mark(line('.'))
    aug my-git-blame
    au!
    au CursorMoved <buffer> call s:blame_mark(line('.'))
    au TextChanged <buffer> call s:blame_update()
    aug END
endfunction

function git#blame_off()
    if !s:blame_enabled()|return|endif
    au! my-git-blame
    aug! my-git-blame
    call git#blame_clear()
endfunction

function git#blame_clear()
    let ns = nvim_create_namespace('git_blame')
    call nvim_buf_clear_namespace(0, ns, 0, -1)
endfunction

" -------------------------------------------------------------------------- "
"                                  Usecases                                  "
" -------------------------------------------------------------------------- "
function git#side_by_side_diff(revision, path)
    if empty(a:path)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let ref = s:ref(a:revision, '')
    let bufname = a:path..'@'..ref
    let lines = s:file_version(ref, a:path)
    if empty(lines)|return -1|endif

    let winid = win_getid()
    let bufnr = s:temp_buffer(lines, bufname, &ft, {'cmd': 'leftabove vertical new'})

    if bufnr > 0
        " Left
        set winfixbuf
        diffthis

        " Right
        wincmd p
        set winfixbuf
        diffthis

        " Cleanup
        execute printf('autocmd BufWipeout <buffer=%d> ++once lua vim.api.nvim_set_option_value("diff", false, {win = %d})', bufnr, winid)
        execute printf('autocmd BufWipeout <buffer=%d> ++once lua vim.api.nvim_set_option_value("winfixbuf", false, {win = %d})', bufnr, winid)
    endif

    return bufnr
endfunction

function git#inline_diff(split, revision, path) abort
    if empty(a:path)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let ref = s:ref(a:revision)
    let bufname = a:path..' VS '..ref
    let lines = s:git(fdir, 'diff '..ref..' -- '..fname)
    if empty(lines)|return -1|endif
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufnr = s:temp_buffer(lines, bufname, 'diff', {'cmd': cmd})

    return bufnr
endfunction

function git#show_diff(split, from, until, path) abort
    if empty(a:path)|return|endif
    if empty(a:until) || empty(a:from)|return|endif
    let [fdir, fname] = s:pathsplit(a:path)
    let until = split(a:until)[0]
    let from = split(a:from)[0]
    let bufname = 'PATCH: '..a:path..'@'..(from == until ? until : from..'..'..until)
    let lines = s:git(fdir, 'diff '..from..'~ '..until..(!empty(fname) ? ' -- '..fname : ''))
    if empty(lines)|return -1|endif
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufnr = s:temp_buffer(lines, bufname, 'diff', {'cmd': cmd})

    return bufnr
endfunction

function git#show_timeline(split, line1, line2, range, path)
    " When we don't have a file, we cannot create a timeline. Just show the
    " log for path the instead.
    if !filereadable(a:path)|return git#show_log(a:split, a:path)|endif

    let [fdir, fname] = s:pathsplit(a:path)
    let bufname = 'TIMELINE: '..fname..(a:range ? ':'..a:line1..','..a:line2 : '')..' '..s:head(fdir)
    let cmd = a:split ? 'leftabove vertical new' : 'enew'
    let ft=&ft
    let file_log = git#file_log(a:path)
    let line_log = s:line_log(a:line1, a:line2, a:path)
    let line_log = map(line_log, { _, v -> index(file_log, v) == -1 ? v .. ' [RENAMED]' : v })
    let bufnr = s:temp_buffer(line_log, bufname, 'gitlog', {'cmd': cmd})
    if bufnr > 0
        let b:peek_patch  = { line1, line2 -> git#show_diff(1, getline(line2), getline(line1), fdir..'/'..fname) }
        let b:open_file   = { -> git#show_file_version(getline('.'), fdir..'/'..fname, ft, 0) }
        let b:peek_file   = { -> git#show_file_version(getline('.'), fdir..'/'..fname, ft, 1) }
        let b:open_commit = { -> s:show_revision(getline('.'), fdir, 0) }
        let b:peek_commit = { -> s:show_revision(getline('.'), fdir, 1) }
    endif
    return bufnr
endfunction

function git#show_log(split, path, args)
    let path = isdirectory(a:path) ? a:path : getcwd()
    let cmd = a:split ? 'leftabove vertical new' : 'enew'
    let bufname = 'GITLOG: '..s:head(path)
    let lines = git#log(path, a:args)
    let bufnr = s:temp_buffer(lines, bufname, 'gitlog', {'cmd': cmd})
    if bufnr > 0
        let b:peek_patch  = { line1, line2 -> git#show_diff(1, getline(line2), getline(line1), path) }
        let b:open_commit = { -> s:show_revision(getline('.'), path, 0) }
        let b:peek_commit = { -> s:show_revision(getline('.'), path, 1) }
    endif
    return bufnr
endfunction

function s:show_revision(revision, directory, split)
    let cmd = a:split ? 'leftabove new' : 'enew'
    let bufname = a:revision
    let lines = s:revision(a:revision, a:directory)
    if empty(lines)|return -1|endif
    let bufnr = s:temp_buffer(lines, bufname, 'git', {'cmd': cmd})
    return bufnr
endfunction

function git#show_file_version(revision, path, filetype, split)
    let cmd = a:split ? 'vertical new' : 'enew'
    if empty(a:path)|return|endif
    let ref =s:ref(a:revision)
    let bufname = a:path..'@'..ref
    let lines = s:file_version(ref, a:path)
    if empty(lines)|return -1|endif
    let bufnr = s:temp_buffer(lines, bufname, a:filetype, {'cmd': cmd})
    return bufnr
endfunction

function git#load_changed_files(ref = '')
    let gitroot = s:gitroot()
    let ref = s:ref(a:ref, '')
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

function git#quick_diff(revision, jump)
    let ref = s:ref(a:revision)
    let lines = s:git(getcwd(), 'jump --stdout diff '..ref)
    call setqflist([], 'r', {'efm': "%f:%l:%m", 'title': "Diff <> "..ref, 'lines': lines})
    cwindow
    if a:jump|cc|endif
endfunction

function git#set_diff_target(reset, revision)
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

function git#review(revision)
    let l:main = s:main()
    let l:revision = a:revision == '' ? 'origin/'..l:main : a:revision

    tab split
    call git#set_diff_target(0, l:revision)
    arglocal
    try
        call git#load_changed_files()
        first
    catch
        echo v:exception
        tabclose
    endtry
endfunction

function git#reset(path)
    let path = a:path == '' ? bufname() : a:path
    let [fdir, fname] = s:pathsplit(path)
    let fname = fname == '' ? '.' : fname " The entire directory
    let result = s:git(fdir, 'reset -- '..fname)
    echo "Unstaged '"..path.."'"
    doautocmd User MyGitIndexChanged
endfunction

function git#add(path)
    let path = a:path == '' ? bufname() : a:path
    let [fdir, fname] = s:pathsplit(path)
    let fname = fname == '' ? '.' : fname " The entire directory
    let result = s:git(fdir, 'add -- '..fname)
    echo "Staged '"..path.."'"
    doautocmd User MyGitIndexChanged
endfunction

function git#status(path)
    let path = a:path == '' ? getcwd() : a:path
    let [fdir, fname] = s:pathsplit(path)
    let fname = fname == '' ? '.' : fname " The entire directory
    let lines = s:git(fdir, 'status --short -- '..fname)
    echo lines->join("\n")
endfunction

function git#ctags(lib)
    let l:cmd = a:lib ? 'ctags-lib' : 'ctags'
    if finddir('.git', ';') != '' || findfile('.git', ';') != ''
        call jobstart(['git', l:cmd])
    else 
        echo "Unable to call 'ctags' Git hook'"..getcwd().."' is not a git repository."
    endif
endfunction
