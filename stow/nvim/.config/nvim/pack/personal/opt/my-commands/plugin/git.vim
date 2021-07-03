command! GlobalRevisions echo join(commander#git#global_revisions(), "\n")
command! LocalRevisions echo join(commander#git#local_revisions(), "\n")

" Show the author who last changed the selected line
command! -range Blame echo join(commander#git#blame(<line1>, <line2>), "\n")
command! ShowBlame call commander#git#blame_on()
command! NoShowBlame call commander#git#blame_off()

" Regenerate the git ctags kept under .git/tags
command! Ctags if finddir('.git', ';') != ''
    \| call jobstart(['git', 'ctags']) | else
    \| echo "'".getcwd()."' is not a git repository. Can only run Ctags from within a git repository." | endif

function s:complete_file_revisions(...)
    return commander#git#file_revisions()
endfunction
function s:complete_global_revisions(...)
    return commander#git#global_revisions()
endfunction

function s:edit_args_msg()
    if argc() == 1
        return "Editing the only changed file."
    endif
    return "Editing the first of ".argc()." changed files."
endfunction

command! -bang -range=% GitLog call commander#git#load_log(<bang>0)
command! -bang -range=% Timeline call commander#git#load_timeline(<bang>1, <line1>, <line2>, <range>)
command! -nargs=? -complete=customlist,s:complete_file_revisions ChangeSplit call commander#git#load_diff_in_split(<q-args>)
command! -nargs=? -complete=customlist,s:complete_file_revisions ChangePatch call commander#git#load_patch(<q-args>)

command! -nargs=? -bang -complete=customlist,s:complete_global_revisions ChangedFiles call commander#git#set_changed_args(<q-args>)
            \| if <bang>0 && argc()
            \|     echom s:edit_args_msg()
            \|     call feedkeys("[A")
            \| endif
command! -nargs=? -bang -complete=customlist,s:complete_global_revisions DiffTarget call call('commander#git#set_diff_target', <bang>1 ? [<q-args>] : [])
command! -nargs=+ -complete=customlist,s:complete_global_revisions Review call commander#git#review(<q-args>)


nnoremap <plug>(git-diff-split) <cmd>ChangeSplit<cr>
nnoremap <plug>(git-patch-split) <cmd>ChangePatch<cr>
nnoremap <plug>(git-diff-split-ref) :ChangeSplit <c-z>
nnoremap <plug>(git-patch-split-ref) :ChangePatch <c-z>
nnoremap <plug>(git-blame) <cmd>Blame<cr>
vnoremap <plug>(git-blame) :Blame<cr>
