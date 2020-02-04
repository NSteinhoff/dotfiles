" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Sat 19 Oct 2019 08:24:21 CEST
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

if !executable('git')
    echoerr "You must have git installed to use this plugin"
    finish
endif

let s:debug = 1

function! s:log_debug(text)
    if s:debug
        echo a:text
    endif
endfunction

function! s:select_ref()
    let candidates = {}
    let items = ["Pick a ref to diff against:"]
    let max_len_name = 50

    for ref in git#branches()
        let pref = '-@ '
        let name = ref
        let desc = git#ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc, 'pref': pref}
        let candidates[len(candidates)+1] = item
    endfor

    for [branch, ref] in items(git#mergebases())
        let pref = '-< '
        let name = branch.' ('.git#chash(ref).')'
        let desc = git#ctitle(ref)
        let item = {'ref': ref, 'name': name, 'desc': desc, 'pref': pref}
        let candidates[len(candidates)+1] = item
    endfor

    let n_commits = 9
    let i = 0
    for ref in git#commits(n_commits)
        let i += 1
        let pref = '~'.i.' '
        let name = strcharpart(ref, 0, 7)
        let desc = git#ctitle(ref)
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

function! s:load_original(filename, ref, ft)
    setlocal buftype=nofile bufhidden=wipe noswapfile | let &l:ft = a:ft
    au BufUnload,BufWinLeave <buffer> diffoff!

    let original = git#original(a:filename, a:ref)
    call append(0, original)
    $delete

    diffthis | wincmd p | diffthis
endfun

function! s:load_patch(filename, ref)
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=diff

    let patch = git#patch(a:filename, a:ref)
    call append(0, patch)
    $delete
    wincmd p
endfun

function! s:load_patch_all(ref)
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=diff

    let patch = git#patch_all(a:ref)
    call append(0, patch)
endfun

function! s:patch_this(target)
    if !git#check() | return | endif
    let ref = s:target_ref(a:target)
    let filename = expand('%')
    let bname = '[PATCH:'.ref.'] '.filename.': '. git#ctitle(ref)
    execute 'new '.bname
    wincmd K | resize 15
    call s:load_patch(filename, ref)
endfunction

function! s:patch_all(target)
    if !git#check() | return | endif
    let ref = s:target_ref(a:target)
    execute 'tabnew __PATCH__' . ref
    call s:load_patch_all(ref)
endfunction

function! s:edit_comment(filename, lnum, lines)
    let bname = '[COMMENT:'.a:filename.':'.a:lnum.']'
    execute 'new '.bname
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=markdown
    wincmd K | resize 15

    let b:filename = a:filename
    let b:lnum = a:lnum

    au BufUnload <buffer> call comment#write(b:filename, b:lnum, getline(0, '$'))

    let previous = comment#get(a:filename, a:lnum)
    let lines = empty(previous) ? a:lines : previous.lines + a:lines
    call append(0, lines) | normal dd
endfunction

" -------------------------------------------------------------
" Section: Public
" -------------------------------------------------------------

function! differ#remote_types(A,L,P)
    return ['branches', 'commits', 'mergebases']
endfunction

function! differ#list_refs(A,L,P)
    if !git#check() | return | endif
    let refs = git#refs()
    return refs
endfun

function! differ#diff(target) abort
    if !git#check() | return | endif
    let ref = s:target_ref(a:target)
    let ft = &ft
    let filename = expand('%')
    execute 'vnew '.filename.'@'.ref
    call s:load_original(filename, ref, ft)
endfunction

function! differ#patch(target, bang)
    if a:bang == ''
        call s:patch_this(a:target)
    else
        call s:patch_all(a:target)
    endif
endfunction

function! differ#set_target(bang)
    if !git#check() | return | endif

    if a:bang == '!'
        let s:diff_remote = s:select_ref()
        if s:diff_remote != ""
            echo "Setting diff target ref to '".s:diff_remote."'."
            if argc(-1) > 0
                argd *
            endif
            for fname in git#files(s:diff_remote)
                echo fname
                exe 'argadd '.fname
            endfor
        else
            echo "Using previous target remote: ".s:target_ref('')
        endif
    else
        echo "REMOTE: ".s:target_ref('')
    endif
endfunction

function! differ#status()
    if !git#check() | return | endif
    echo git#status()
    let remote = s:target_ref('')
    echo "\n---\n"
    echo 'LOCAL: '.git#csummary('HEAD')
    echo 'REMOTE: '.remote.' - '.git#csummary(remote)
    echo "\n---\n"
    echo 'Comments: '.len(comment#list())
    if len(comment#list()) > 0
        echo 'Read your comments with :DShowComments or check the quickfix list.'
    endif
endfunction

function! differ#show_comments()
    let bname = '[COMMENTS]'
    execute 'tabnew '.bname
    setlocal buftype=nofile bufhidden=wipe noswapfile ft=markdown

    call append(0, ['WARNING: changes will not be saved!!!', '', '---'])

    for c in comment#list()
        let header = '# '.c.filename.':'.c.lnum
        call append('$', ['', header, ''] + c.lines)
    endfor
endfunction

function! differ#comment(text, bang)
    let lnum = line('.')
    let filename = expand('%:.')
    let lines = a:text == ''?[]:[a:text]

    if a:bang == ''
        call s:edit_comment(filename, lnum, lines)
    else
        if input('Do you really want to wipe all comments? yes/no: ' ) == 'yes'
            call comment#wipe()
            echo "\nComments wiped!"
        else
            echo 'Ok then.'
        endif
    endif
endfunction