command! CompilerInfo call compiler#describe()
command! -nargs=1 -bang -complete=compiler CompileWith call compiler#with(<bang>0, <f-args>)
