command! CompilerDescribe call compiler#describe()
command! CompilerInfo call compiler#info()
command! -nargs=* -complete=compiler CompileWith call compiler#with(0, <f-args>)
command! -nargs=* -complete=compiler LCompileWith call compiler#with(1, <f-args>)

nnoremap <silent> <plug>(compiler-with) <cmd>wall<bar>CompileWith<cr>
nnoremap <plug>(compiler-info) <cmd>CompilerInfo<cr>
