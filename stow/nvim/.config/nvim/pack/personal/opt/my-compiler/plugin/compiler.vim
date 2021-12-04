command! CompilerInfo call compiler#describe()
command! -nargs=* -bang -complete=compiler CompileWith call compiler#with(<bang>0, <f-args>)

nnoremap <silent> <plug>(compiler-with) <cmd>CompileWith<cr>
nnoremap <plug>(compiler-info) <cmd>CompilerInfo<cr>
