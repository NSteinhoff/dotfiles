setlocal commentstring=//\ %s
setlocal keywordprg=:vert\ Man\ 3
iabbrev <buffer> pr printf("");<c-o>F"
iabbrev <buffer> prn printf("\n");<c-o>F\
iabbrev <buffer> #inc" #include ""<left>
iabbrev <buffer> #inc< #include <><left>

command -buffer CompileAndRun w|make %:r|!./%:r
