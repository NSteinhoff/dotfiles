" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Sat 19 Oct 2019 08:24:21 CEST
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

if !executable('git')
    echoerr "You must have git installed to use this plugin"
    finish
endif


let s:comments = []
let s:qfid = 0
let s:debug = 1

function! s:log_debug(text)
    if s:debug
        echo a:text
    endif
endfunction

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
    let max_len_name = 50

    for ref in s:git_branches()
        let pref = '-@ '
        let name = ref
        let desc = s:git_ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc, 'pref': pref}
        let candidates[len(candidates)+1] = item
    endfor

    for [branch, ref] in items(s:git_mergebases())
        let pref = '-< '
        let name = branch.' ('.s:git_chash(ref).')'
        let desc = s:git_ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc, 'pref': pref}
        let candidates[len(candidates)+1] = item
    endfor

    let n_commits = 9
    let i = 0
    for ref in s:git_commits(n_commits)
        let i += 1
        let pref = '~'.i.' '
        let name = strcharpart(ref, 0, 7)
        let desc = s:git_ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc, 'pref': pref}
        let candidates[len(candidates)+1] = item
    endfor
    unlet i

    for [i, candidate] in items(candidates)
        let pref = candidate['pref']
        let name = candidate['name']
        if strchars(name) > max_len_name
            let start = strchars(name) - max_len_name + 2
            let display_name = '..'.strcharpart(name, start, max_len_name)
        else
            let display_name = name
        endif
        let shift = repeat(' ', max_len_name + 2 - strwidth(display_name))
        let desc = candidate['desc']
        let num = repeat(' ', strchars(len(candidates)) - strchars(i)).i
        let entry = ' '.num.') '.pref.display_name.shift.desc
        call add(items, entry)
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
    elseif exists('s:diff_remote') && s:diff_remote != ""
        return s:diff_remote
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

function! s:patch_this(target)
    if !s:git_check() | return | endif
    let ref = s:target_ref(a:target)
    let fname = expand('%')
    let bname = '[PATCH:'.ref.'] '.fname.': '. s:git_ctitle(ref)
    execute 'new '.bname
    wincmd K | resize 15
    call s:load_patch(fname, ref)
endfunction

function! s:patch_all(target)
    if !s:git_check() | return | endif
    let ref = s:target_ref(a:target)
    execute 'tabnew __PATCH__' . ref
    call s:load_patch_all(ref)
endfunction

function! s:get_comment(filename, lnum)
    for item in s:comments
        if item.filename == a:filename && item.lnum == a:lnum
            return item.lines
        endif
    endfor
    return []
endfunction

function! s:update_comment(filename, lnum, lines)
    for item in s:comments
        if item.filename == a:filename && item.lnum == a:lnum
            let item.lines = a:lines
            return
        endif
    endfor
    let item = {'lnum': a:lnum, 'filename': a:filename, 'lines': a:lines}
    call add(s:comments, item)
endfunction

function! s:edit_comment(fname, lnum, lines)
    let bname = '[COMMENT:'.a:fname.':'.a:lnum.']'
    execute 'new '.bname
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=markdown
    wincmd K | resize 15

    let b:fname = a:fname
    let b:lnum = a:lnum

    au BufUnload <buffer> call s:update_comment(b:fname, b:lnum, getline(0, '$')) | call s:set_quickfix_comments()

    let previous = s:get_comment(a:fname, a:lnum)
    call append(0, previous + a:lines) | normal dd
endfunction

function! s:set_quickfix_comments()
    let items = []
    for c in s:comments
        let nlines = len(c.lines)
        call add(items, {'filename': c.filename, 'lnum': c.lnum, 'text': '('.nlines.') '.c.lines[0]})
    endfor
    call setqflist([], 'r', {'id': s:qfid, 'items': items})
endfunction


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

function! differ#patch(target, bang)
    if a:bang == ''
        call s:patch_this(a:target)
    else
        call s:patch_all(a:target)
    endif
endfunction

function! differ#list_refs(A,L,P)
    if !s:git_check() | return | endif
    let refs = s:git_refs()
    return refs
endfun

function! differ#set_target(target, bang)
    if !s:git_check() | return | endif
    if a:bang == ''
        let s:diff_remote = a:target == "" ? s:select_ref() : a:target
        if s:diff_remote != ""
            echo "Setting diff target ref to '".s:diff_remote."'."
        else
            echo "Using default target ref."
        endif
    else
        echo "Pass"
    endif
endfunction

function! differ#status()
    if !s:git_check() | return | endif
    echo s:git_status()
    let local = 'HEAD'
    let remote = s:target_ref('')
    echo "\n---\n"
    echo 'LOCAL: '.s:git_csummary(local)
    echo 'REMOTE: '.remote.' - '.s:git_csummary(remote)
    echo "\n---\n"
    echo 'Comments: '.len(s:comments)
    if len(s:comments) > 0
        echo 'Read your comments with :DShowComments or check the quickfix list.'
    endif
endfunction

function! differ#show_comments()
    let bname = '[COMMENTS]'
    execute 'tabnew '.bname
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=markdown

    call append(0, ['WARNING: changes will not be saved!!!', '', '---'])

    for c in s:comments
        let header = '# '.c.filename.':'.c.lnum
        call append('$', ['', header, ''] + c.lines)
    endfor
endfunction

function! differ#comment(text, bang)
    " We don't want to keep creating new quickfix lists with
    " every new comment. Instead, we keep overwriting the same one.
    if s:qfid == 0
        " Create a new quickfix list
        call setqflist([], ' ', {'title': 'Diff Comments'})

        let s:qfid = getqflist({'id': 0}).id
    endif

    let lnum = line('.')
    let fname = expand('%:.')
    let lines = a:text == ''?[]:[a:text]

    if a:bang == ''
        call s:edit_comment(fname, lnum, lines)
    else
        if input('Do you really want to wipe all comments? yes/no': ) == 'yes'
            let s:comments = []
            call s:set_quickfix_comments()
            echo 'Comments wiped!'
        else
            echo 'Ok then.'
        endif
    endif
endfunction
