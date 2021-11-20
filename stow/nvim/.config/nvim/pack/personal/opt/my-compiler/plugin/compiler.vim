command! CompilerInfo call compiler#describe()
command! -nargs=* -bang -complete=compiler CompileWith call compiler#with(<bang>0, <f-args>)
