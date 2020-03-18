function s:gitlist(cmd)
    return systemlist("git -C ".git#root()." ".a:cmd)
endfunction

function s:git(cmd)
    return trim(system("git -C ".git#root()." ".a:cmd))
endfunction

function s:fpath(path) abort
    let fullpath = fnamemodify(a:path, ':p')
    let fullroot = fnamemodify(git#root(), ':p')
    return substitute(fullpath, fullroot, '', '')
endfunction

function! s:cfiles(ref)
    return s:gitlist("diff --name-only ".a:ref)
endfunction

function! git#root()
    return fnamemodify(finddir('.git', expand("%:p:h").";~"), ':h').'/'
endfunction

function! s:has_changed(filename, ref)
    return count(s:cfiles(a:ref), a:filename) > 0
endfunction

function! s:commits_short(n)
    return s:gitlist("log -n ".a:n." --pretty='%h'")
endfunction

function! s:current_branch()
    return s:git("rev-parse --abbrev-ref HEAD")
endfunction

function! git#check()
    let out = s:git("status")
    if v:shell_error == 0
        return 1
    else
        echomsg "Unable to get git status:'".out."'"
    endif
endfunction

function! git#status()
    echo "Repository: ".git#root()
    let status = system("git -C ".git#root()." status")
    let stat = system("git -C ".git#root()." diff --stat")
    return status."\n".stat
endfunction

function! git#branches()
    return s:gitlist("branch --format '%(refname:short)'")
endfunction

function! git#commits(n)
    return s:gitlist("log -n ".a:n." --pretty='%H'")
endfunction

function! git#refs()
    let branches = git#branches()
    let commits = s:commits_short(50)
    return branches + commits
endfunction

function! git#files(ref)
    let paths = s:cfiles(a:ref)
    let fullpaths = map(copy(paths), {_, val -> git#root().val})
    let relpaths = map(copy(fullpaths), {_, val -> fnamemodify(val, ':.')})
    return relpaths
endfunction

function! git#mergebase(this, that)
    return s:git("merge-base ".a:this." ".a:that)
endfunction

function! git#mergebases()
    let this = "HEAD"
    let bases = {}
    for b in git#branches()
        let bases[b] = git#mergebase(b, "HEAD")
    endfor
    return bases
endfunction

function! git#chash(ref)
    return s:git("log -n1 --format='%h' ".a:ref)
endfunction

function! git#ctitle(ref)
    return s:git("log -n1 --format='%s (%cr)' ".a:ref)
endfunction

function! git#csummary(ref)
    return s:git("log -n1 --format='%h - %s (%cr)' ".a:ref)
endfunction

function! git#original(filename, ref, n) abort
    let fpath = s:fpath(a:filename)
    return s:gitlist("show ".a:ref."~".a:n.":".fpath)
endfunction

function! git#patch(filename, ref)
    return s:gitlist("diff ".a:ref." -- ".a:filename)
endfunction

function! git#patch_all(ref)
    return s:gitlist("diff ".a:ref)
endfunction
