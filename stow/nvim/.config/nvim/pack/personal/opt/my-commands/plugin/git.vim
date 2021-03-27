command! GlobalRevisions echo join(commander#git#global_revisions(), "\n")
command! LocalRevisions echo join(commander#git#local_revisions(), "\n")

" Show the author who last changed the selected line
command! -range Blame echo join(commander#git#blame(<line1>, <line2>), "\n")
command! BlameOn call commander#git#blame_on()
command! BlameOff call commander#git#blame_off()
command! -range -bang BlameLense
    \ if <bang>0
    \|call commander#git#blame_clear()
    \|else
    \|call commander#git#blame_lense(<line1>, <line2>)
    \|endif

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

command! -bang -range=% Timeline call commander#git#load_timeline(<bang>0, <line1>, <line2>, <range>)
command! -nargs=? -complete=customlist,s:complete_file_revisions ChangeSplit call commander#git#load_diff_in_split(<q-args>)
command! -nargs=? -complete=customlist,s:complete_file_revisions ChangePatch call commander#git#load_patch(<q-args>)

command! -nargs=? -bang -complete=customlist,s:complete_global_revisions ChangedFiles call commander#git#set_changed_args(<q-args>)
            \| if <bang>0 && argc()
            \|     echom s:edit_args_msg()
            \|     call feedkeys("[A")
            \| endif


nnoremap <Plug>(git-diff-split) <CMD>ChangeSplit<CR>
nnoremap <Plug>(git-patch-split) <CMD>ChangePatch<CR>
nnoremap <Plug>(git-diff-split-ref) :ChangeSplit <C-Z>
nnoremap <Plug>(git-patch-split-ref) :ChangePatch <C-Z>
nnoremap <Plug>(git-blame) <CMD>Blame<CR>
vnoremap <Plug>(git-blame) :Blame<CR>
