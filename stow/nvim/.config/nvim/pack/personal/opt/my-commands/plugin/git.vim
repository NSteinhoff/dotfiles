" Show the author who last changed the selected line
command! -range Blame echo join(commander#git#blame(<line1>, <line2>), "\n")
command! ShowBlame call commander#git#blame_on()
command! NoShowBlame call commander#git#blame_off()

" Regenerate the git ctags kept under .git/tags
command! Ctags if finddir('.git', ';') != ''
    \| call jobstart(['git', 'ctags']) | else
    \| echo "'".getcwd()."' is not a git repository. Can only run Ctags from within a git repository." | endif

function s:complete_file_revisions(arglead, cmdline, cursorpos)
    return filter(commander#git#file_revisions(@%), { _, v -> v =~ a:arglead})
endfunction
function s:complete_global_revisions(arglead, cmdline, cursorpos)
    return filter(commander#git#revisions(getcwd()), { _, v -> v =~ a:arglead})
endfunction

function s:edit_args_msg()
    if argc() == 1
        return "Editing the only changed file."
    endif
    return "Editing the first of ".argc()." changed files."
endfunction

function s:log(bang)
    let open_in_split = !(a:bang || empty(@%))
    call commander#git#load_log(open_in_split, getcwd())
endfunction

function s:timeline(bang, line1, line2, range)
    let open_in_split = !(a:bang || empty(@%))
    call commander#git#load_timeline(open_in_split, a:line1, a:line2, a:range, @%)
endfunction

command! -bang -range=% GitLog call s:log(<bang>0)
command! -bang -range=% Timeline call s:timeline(<bang>0, <line1>, <line2>, <range>)
command! -nargs=? -complete=customlist,s:complete_file_revisions DiffThis call commander#git#diff_this(<q-args>, @%)
command! -bang -nargs=? -complete=customlist,s:complete_file_revisions PatchThis call commander#git#patch_this(<bang>1, <q-args>, @%)

function s:changed_files(revision, goto)
    call commander#git#set_changed_args(a:revision)
    if a:goto && argc()
        first
    endif
    args
endfunction
command! -nargs=? -bang -complete=customlist,s:complete_global_revisions ChangedFiles call s:changed_files(<q-args>, <bang>1)
command! -nargs=? -bang -complete=customlist,s:complete_global_revisions DiffTarget call call('commander#git#set_diff_target', <bang>1 ? [<q-args>] : [])
command! -nargs=+ -complete=customlist,s:complete_global_revisions Review call commander#git#review(<q-args>)

function s:track_changes()
    augroup my-changed-files
        autocmd!
        autocmd VimResume,FocusGained * call commander#git#set_changed_args()
        autocmd DirChanged * call commander#git#set_changed_args()
        autocmd BufWritePost * call commander#git#set_changed_args()
    augroup END

    call commander#git#set_changed_args()
endfunction

function s:no_track_changes()
    if !exists('#my-changed-files') | return | endif

    augroup my-changed-files
        autocmd!
    augroup END

    augroup! my-changed-files

    argd *
endfunction

command -bang TrackChanges call s:track_changes()
command -bang NoTrackChanges call s:no_track_changes()

nnoremap <plug>(git-diff-split) <cmd>DiffThis<cr>
nnoremap <plug>(git-patch-split) <cmd>PatchThis<cr>
nnoremap <plug>(git-diff-split-ref) :DiffThis <c-z>
nnoremap <plug>(git-patch-split-ref) :PatchThis <c-z>
nnoremap <plug>(git-blame) <cmd>Blame<cr>
vnoremap <plug>(git-blame) :Blame<cr>
