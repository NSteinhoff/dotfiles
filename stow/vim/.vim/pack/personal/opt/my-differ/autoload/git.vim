" Location: autoload/git.vim
" Maintainer: Niko Steinhoff <niko.steinhoff@gmail.com>
"
" This file contains a bunch of helper functions for interacting
" with the git CLI client.

" Find the git root for the repo based on the working directory
function git#root()
    return fnamemodify(finddir('.git', ".;~"), ':h').'/'
endfunction

" Find the git root for the repo based on the path to a file
"
" The file may be outside the current working directory.
function git#root_for_file(filepath)
    let filepath = fnamemodify(expand(a:filepath), ":p")
    return fnamemodify(finddir('.git', a:filepath.";~"), ':h').'/'
endfunction

" Run a command in the local git repo
function s:git_local(cmd)
    return trim(system("git -C ".git#root()." ".a:cmd))
endfunction

" Run a command in the local git repo
"
" Return output lines
function s:gitlist_local(cmd)
    return systemlist("git -C ".git#root()." ".a:cmd)
endfunction

" Run a command in the git repo containing the filepath.
"
" Replace the '{}' in the command with the git root
" relative filepath and run the command in the
" git repo containing the file.
"
" Return output lines
function s:gitlist_relative(cmd, filepath)
    let [before, after] = split(a:cmd, '{}', 1)
    let relpath = git#relpath(a:filepath)
    let cmd = before . relpath . after
    return systemlist("git -C ".git#root_for_file(a:filepath)." ".cmd)
endfunction

" Get the path relative to the git repo's root
"
" The repo may be outside the current working directory
function git#relpath(path) abort
    let fullpath = fnamemodify(a:path, ':p')
    let fullroot = fnamemodify(git#root_for_file(a:path), ':p')
    return substitute(fullpath, fullroot, '', '')
endfunction

" Check that we are inside a git repo
function git#check()
    let out = s:git_local("status")
    if v:shell_error == 0
        return 1
    else
        echomsg "Unable to get git status:'".out."'"
    endif
endfunction

" Get the current git status
function git#status()
    echo "Repository: ".git#root()
    let status = system("git -C ".git#root()." status")
    let stat = system("git -C ".git#root()." diff --stat")
    return status."\n".stat
endfunction

" List short branch names
function git#branches()
    return s:gitlist_local("branch --format '%(refname:short)'")
endfunction

" List hashes of the last 'n' commits
function git#commits(n)
    return s:gitlist_local("log -n ".a:n." --pretty='%H'")
endfunction

" List interesting refs
"
" * branches
" * last 25 commit hashes
function git#refs()
    let branches = git#branches()
    let commits = s:gitlist_local("log -n 25 --pretty='%h'")
    return branches + commits
endfunction

" List all files that contain diffs
function git#files(ref)
    let paths = s:gitlist_local("diff --name-only ".a:ref)
    let relpaths = map(copy(paths), {_, val -> git#relpath(val)})
    return relpaths
endfunction

" Get the merge base for two refs
function git#mergebase(this, that)
    return s:git_local("merge-base ".a:this." ".a:that)
endfunction

" Get all merge bases of the current branch against all other local branches
function git#mergebases()
    let this = "HEAD"
    let bases = {}
    for b in git#branches()
        let bases[b] = git#mergebase(b, "HEAD")
    endfor
    return bases
endfunction

" Get the commit hash of a ref
function git#chash(ref)
    return s:git_local("log -n1 --format='%h' ".a:ref)
endfunction

" Get the commit title of a ref
function git#ctitle(ref)
    return s:git_local("log -n1 --format='%s (%cr)' ".a:ref)
endfunction

" Get the commit summary line of a ref
function git#csummary(ref)
    return s:git_local("log -n1 --format='%h - %s (%cr)' ".a:ref)
endfunction

" Get a version of a file relative to a ref
function git#original(filename, ref, n) abort
    return s:gitlist_relative("show ".a:ref."~".a:n.":{}", a:filename)
endfunction

" Get a the diff for a single file against a ref
function git#patch(filename, ref)
    return s:gitlist_relative("diff ".a:ref." -- {}", a:filename)
endfunction

" Get the full diff against a ref
function git#patch_all(ref)
    return s:gitlist_local("diff ".a:ref)
endfunction
