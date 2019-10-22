function! s:cfiles(ref)
    return systemlist("git diff --name-only ".a:ref)
endfunction

function! git#root()
    return fnamemodify(finddir('.git', ";~"), ':h').'/'
endfunction

function! s:has_changed(filename, ref)
    return count(s:cfiles(a:ref), a:filename) > 0
endfunction

function! s:commits_short(n)
    return systemlist("git log -n ".a:n." --pretty='%h'")
endfunction

function! s:current_branch()
    return trim(system("git rev-parse --abbrev-ref HEAD"))
endfunction

function! git#check()
    let out = trim(system('git status'))
    if v:shell_error == 0
        return 1
    else
        echomsg "Unable to get git status:'".out."'"
    endif
endfunction

function! git#status()
    let status = system('git status')
    let stat = system('git diff --stat')
    return status."\n".stat
endfunction

function! git#branches()
    return systemlist("git branch -a --format '%(refname:short)'")
endfunction

function! git#commits(n)
    return systemlist("git log -n ".a:n." --pretty='%H'")
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
    return trim(system("git merge-base ".a:this." ".a:that))
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
    return trim(system("git log -n1 --format='%h' ".a:ref))
endfunction

function! git#ctitle(ref)
    return trim(system("git log -n1 --format='%s (%cr)' ".a:ref))
endfunction

function! git#csummary(ref)
    return trim(system("git log -n1 --format='%h - %s (%cr)' ".a:ref))
endfunction

function! git#original(filename, ref)
    return systemlist('git show '.a:ref.':./'.fnamemodify(a:filename, ":."))
endfunction

function! git#patch(filename, ref)
    return systemlist('git diff '.a:ref.' -- '.a:filename)
endfunction

function! git#patch_all(ref)
    return systemlist('git diff '.a:ref)
endfunction
