" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Sat 19 Oct 2019 08:24:21 CEST
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

if !executable('git')
    echoerr "You must have git installed to use this plugin"
    finish
endif

function! s:git_check()
    let out = trim(system('git status'))
    if v:shell_error == 0
        return 1
    else
        echomsg "Unable to get git status:'".out."'"
    endif
endfunction

function! s:git_status()
    let status = system('git status')
    let stat = system('git diff --stat')
    return status."\n".stat
endfunction

function! s:git_branches()
    return systemlist("git branch -a --format '%(refname:short)'")
endfunction

function! s:git_commits_short(n)
    return systemlist("git log -n ".a:n." --pretty='%h'")
endfunction

function! s:git_commits(n)
    return systemlist("git log -n ".a:n." --pretty='%H'")
endfunction

function! s:git_refs()
    let branches = s:git_branches()
    let commits = s:git_commits_short(50)
    return branches + commits
endfunction

function! s:git_current_branch()
    return trim(system("git rev-parse --abbrev-ref HEAD"))
endfunction

function! s:git_mergebase(this, that)
    let that = s:target_ref(a:that)
    return trim(system("git merge-base ".a:this." ".that))
endfunction

function! s:git_mergebases()
    let this = "HEAD"
    let bases = {}
    for b in s:git_branches()
        let bases[b] = s:git_mergebase(b, "HEAD")
    endfor
    return bases
endfunction

function! s:git_cfiles(ref)
    return systemlist("git diff --name-only ".a:ref)
endfunction

function! s:git_has_changed(fname, ref)
    return count(s:git_cfiles(a:ref), a:fname) > 0
endfunction

function! s:git_chash(ref)
    return trim(system("git log -n1 --format='%h' ".a:ref))
endfunction

function! s:git_ctitle(ref)
    return trim(system("git log -n1 --format='%s (%cr)' ".a:ref))
endfunction

function! s:git_csummary(ref)
    return trim(system("git log -n1 --format='%h - %s (%cr)' ".a:ref))
endfunction

function! s:git_original(fname, ref)
    return systemlist('git show '.a:ref.':'.a:fname)
endfunction

function! s:git_patch(fname, ref)
    return systemlist('git diff '.a:ref.' -- '.a:fname)
endfunction

function! s:git_patch_all(ref)
    return systemlist('git diff '.a:ref)
endfunction

function! s:select_ref()
    let candidates = {}
    let items = ["Pick a ref to diff against:"]

    for ref in s:git_branches()
        let name = '-@ '.ref.' ('.s:git_chash(ref).')'
        let desc = s:git_ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc}
        let candidates[len(candidates)+1] = item
    endfor

    for [branch, ref] in items(s:git_mergebases())
        let name = '-< '.branch.' ('.s:git_chash(ref).')'
        let desc = s:git_ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc}
        let candidates[len(candidates)+1] = item
    endfor

    let n_commits = &lines - len(items) - 10
    for ref in s:git_commits(n_commits)
        let name = '-- '.strcharpart(ref, 0, 7)
        let desc = s:git_ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc}
        let candidates[len(candidates)+1] = item
    endfor

    for [i, candidate] in items(candidates)
        let name = candidate['name']
        let shift = repeat(' ', 30 - strwidth(name))
        let desc = candidate['desc']
        let num = repeat(' ', strchars(len(candidates)) - strchars(i)).i
        call add(items, ' '.num.') '.name.shift.desc)
    endfor
    let choice = inputlist(sort(items)) | echo "\n"

    if choice <= 0
        echo "Okay then..."
        return ""
    elseif choice >= len(items)
        echo "Sorry! '".choice."' is not a valid choice!"
        return ""
    else
        echo choice.': '.candidates[choice]['name']
        return candidates[choice]['ref']
    endif
endfunction

function! s:target_ref(target)
    if a:target != ""
        return a:target
    elseif exists('s:target_ref') && s:target_ref
        return s:target_ref
    else
        return 'HEAD'
endfunction

function! s:load_original(fname, ref, ft)
    setlocal buftype=nofile bufhidden=wipe noswapfile | let &l:ft = a:ft
    au BufUnload,BufWinLeave <buffer> diffoff!

    let original = s:git_original(a:fname, a:ref)
    call append(0, original)

    diffthis | wincmd p | diffthis
endfun

function! s:load_patch(fname, ref)
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=diff

    let patch = s:git_patch(a:fname, a:ref)
    call append(0, patch)
    wincmd p
endfun

function! s:load_patch_all(ref)
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=diff

    let patch = s:git_patch_all(a:ref)
    call append(0, patch)
endfun


" -------------------------------------------------------------
" Section: Public
" -------------------------------------------------------------

function! differ#diff(target)
    if !s:git_check() | return | endif
    let ref = s:target_ref(a:target)
    let ft = &ft
    let fname = expand('%')
    execute 'vnew [DIFF:'.ref.'] '.fname.': '. s:git_ctitle(ref)
    call s:load_original(fname, ref, ft)
endfunction

function! differ#patch(target)
    if !s:git_check() | return | endif
    let ref = s:target_ref(a:target)
    let fname = expand('%')
    execute 'new [PATCH:'.ref.'] '.fname.': '. s:git_ctitle(ref)
    wincmd K | resize 9
    call s:load_patch(fname, ref)
endfunction

function! differ#patch_all(target)
    if !s:git_check() | return | endif
    let ref = s:target_ref(a:target)
    execute 'tabnew __PATCH__' . ref
    call s:load_patch_all(ref)
endfunction

function! differ#list_refs(A,L,P)
    if !s:git_check() | return | endif
    let refs = s:git_refs()
    return refs
endfun

function! differ#set_target(target)
    if !s:git_check() | return | endif
    let s:target_ref = a:target == "" ? s:select_ref() : a:target
    if s:target_ref != ""
        echo "Setting diff target ref to '".s:target_ref."'."
    else
        echo "Using default target ref."
    endif
endfunction

function! differ#status()
    if !s:git_check() | return | endif
    echo s:git_status()
    let local = "HEAD"
    let remote = s:target_ref("")
    echo "\n---\n"
    echo "LOCAL: ".s:git_csummary(local)
    echo "REMOTE: ".remote.' - '.s:git_csummary(remote)
endfunction
