setlocal noexpandtab
setlocal shiftwidth=8

command! TaskDone execute 'normal A @done(' . strftime("%Y-%M-%d") . ')'
nnoremap <buffer> <leader>td :TaskDone<CR>
