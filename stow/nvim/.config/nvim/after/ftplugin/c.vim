" Add Homebrew installed headers
" if !empty(finddir('/opt/homebrew/include/'))
"     setlocal path+=/opt/homebrew/include/
"     setlocal path+=/opt/homebrew/opt/*/include
" endif

" Add Mac OS X development headers location
if (executable('xcrun'))
        execute 'setlocal path+='..systemlist('xcrun --show-sdk-path')[0]..'/usr/include/'
endif

setlocal commentstring=//\ %s
setlocal keywordprg=:Man\ 3
iabbrev <buffer> :pr: printf("");<c-o>F"
iabbrev <buffer> :prn: printf("\n");<c-o>F\
iabbrev <buffer> #inc" #include ""<left>
iabbrev <buffer> #inc< #include <><left>

command! -buffer -nargs=* CompileAndRun w|make %:r|!./%:r <args>

" Switch between source and header files
let b:alt =  expand('%:r')..(expand('%') =~ '.c$' ? '.h' : '.c')
command! -buffer A execute 'edit '..b:alt

let b:interpreter = 'clang -include stdio.h -include stdlib.h -Wall -Wextra -Werror -pedantic -o /tmp/'..expand('%:t:r')..' -xc - && /tmp/'..expand('%:t:r')

if findfile('Makefile') == ""
    compiler clang
endif
