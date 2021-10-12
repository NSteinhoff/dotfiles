if (executable('xcrun'))
        execute 'setlocal path+='..systemlist('xcrun --show-sdk-path')[0]..'/usr/include/'
endif
setlocal commentstring=//\ %s
setlocal keywordprg=:Man\ 3
iabbrev <buffer> pr printf("");<c-o>F"
iabbrev <buffer> prn printf("\n");<c-o>F\
iabbrev <buffer> #inc" #include ""<left>
iabbrev <buffer> #inc< #include <><left>

command -buffer -nargs=* CompileAndRun w|make %:r|!./%:r <args>
