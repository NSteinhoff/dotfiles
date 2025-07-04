setlocal nospell
setlocal noexpandtab
setlocal shiftwidth=8

command! -buffer TaskDone silent s/\(\s\+@done.*\)\?$/ @done/ | nohlsearch
command! -buffer TaskUndone silent s/\s\+@done.*$// | nohlsearch
command! -buffer ToggleDone if getline('.') =~ '@done.*$' | execute 'TaskUndone' | else | execute 'TaskDone' | endif

nnoremap <buffer> <space> <cmd>ToggleDone<cr>
