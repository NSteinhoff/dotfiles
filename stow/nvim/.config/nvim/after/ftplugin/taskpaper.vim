setlocal noexpandtab
setlocal shiftwidth=8

command! TaskDone silent s/\(\s\+@done.*\)\?$/ @done/ | nohlsearch
command! TaskUndone silent s/\s\+@done.*$// | nohlsearch
command! ToggleDone if getline('.') =~ '@done.*$' | execute 'TaskUndone' | else | execute 'TaskDone' | endif

nnoremap <buffer> <space> <cmd>ToggleDone<cr>
command! ArchiveDone g/@done/move$ | nohlsearch
nnoremap <buffer> <leader>ta :ArchiveDone<cr>

if exists(':DD')
    setlocal keywordprg=:DD
endif
