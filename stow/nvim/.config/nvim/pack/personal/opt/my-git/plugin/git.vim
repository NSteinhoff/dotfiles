" Show the author who last changed the selected line
command! -range Blame echo join(git#blame(<line1>, <line2>), "\n")
command! ShowBlame call git#blame_on()
command! NoShowBlame call git#blame_off()

" Regenerate the git ctags
command! Ctags call git#ctags(0)
command! CtagsLib call git#ctags(1)
function s:complete_file_log(arglead, cmdline, cursorpos)
    return filter(git#file_log(@%), { _, v -> v =~ a:arglead})
endfunction
function s:complete_log(arglead, cmdline, cursorpos)
    return filter(git#log(getcwd()), { _, v -> v =~ a:arglead})
endfunction

function s:log(bang, args)
    let split_window = !(a:bang || empty(@%))
    call git#show_log(split_window, getcwd(), a:args)
endfunction

function s:timeline(bang, line1, line2, range)
    let split_window = !(a:bang || empty(@%))
    call git#show_timeline(split_window, a:line1, a:line2, a:range, @%)
endfunction

command! -bang -nargs=* GitLog call s:log(<bang>0, <q-args>)
command! -bang -range=% Timeline call s:timeline(<bang>0, <line1>, <line2>, <range>)
command! -bar -nargs=? -complete=customlist,s:complete_file_log DiffThis call git#side_by_side_diff(<q-args>, @%)
command! -bang -nargs=? -complete=customlist,s:complete_file_log PatchThis call git#inline_diff(<bang>1, <q-args>, @%)
command! -bar -nargs=? -complete=buffer GitAdd call git#add(<q-args>)
command! -bar -nargs=? -complete=buffer GitReset call git#reset(<q-args>)
command! -bar -nargs=? -complete=buffer GitStatus call git#status(<q-args>)

function s:changed_files(revision, goto)
    call git#load_changed_files(a:revision)
    if a:goto && argc()
        first
    endif
    args
endfunction
command! -nargs=? -bang -complete=customlist,s:complete_log ChangedFiles call s:changed_files(<q-args>, <bang>1)
command! -nargs=? -bang -complete=customlist,s:complete_log DiffTarget call git#set_diff_target(<bang>0, <q-args>)
command! -nargs=? -complete=customlist,s:complete_log Review call git#review(<q-args>)
command! MarkReviewed only | diffoff! | argdelete % | argument | DiffThis | echo "Mark reviewed '"..expand("%").."'"
command! -nargs=? -bang -complete=customlist,s:complete_log QuickDiff call git#quick_diff(<q-args>, <bang>1)

function s:track_changes(jump)
    augroup my-changed-files
        autocmd!
        autocmd VimResume,FocusGained * call git#load_changed_files()
        autocmd DirChanged * call git#load_changed_files()
        autocmd BufWritePost * call git#load_changed_files()
        autocmd User MyGitAdd call git#load_changed_files()
    augroup END

    call git#load_changed_files()

    if a:jump
        first
    endif
endfunction

function s:no_track_changes()
    if !exists('#my-changed-files') | return | endif

    augroup my-changed-files
        autocmd!
    augroup END

    augroup! my-changed-files

    argd *
endfunction

command -bang TrackChanges call s:track_changes(<bang>0)
command -bang NoTrackChanges call s:no_track_changes()

nnoremap <plug>(git-diff-split) <cmd>DiffThis<cr>
nnoremap <plug>(git-patch-split) <cmd>PatchThis<cr>
nnoremap <plug>(git-diff-split-ref) :DiffThis <c-z>
nnoremap <plug>(git-patch-split-ref) :PatchThis <c-z>
nnoremap <plug>(git-blame) <cmd>Blame<cr>
vnoremap <plug>(git-blame) :Blame<cr>
nnoremap <plug>(git-add) <cmd>GitAdd<cr>
nnoremap <plug>(git-reset) <cmd>GitReset<cr>
nnoremap <plug>(git-review-next) <cmd>only<bar>diffoff!<bar>next<bar>DiffThis<cr>
nnoremap <plug>(git-review-prev) <cmd>only<bar>diffoff!<bar>prev<bar>DiffThis<cr>
nnoremap <plug>(git-review-first) <cmd>only<bar>diffoff!<bar>first<bar>DiffThis<cr>
nnoremap <plug>(git-review-mark-seen) <cmd>MarkReviewed<cr>

call abbrev#cmdline('dd', 'DiffThis')
