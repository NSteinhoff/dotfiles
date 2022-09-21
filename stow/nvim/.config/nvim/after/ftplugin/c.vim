" Add Homebrew installed headers
" if !empty(finddir('/opt/homebrew/include/'))
"     setlocal path+=/opt/homebrew/include/
"     setlocal path+=/opt/homebrew/opt/*/include
" endif

" Add Mac OS X development headers location
if (executable('xcrun'))
        execute 'setlocal path+='..systemlist('xcrun --show-sdk-path')[0]..'/usr/include/'
endif

setlocal commentstring=//%s
" Add Rust style 'internal' doc comments for module level documentation.
setlocal comments+=://!
setlocal keywordprg=:Man\ 3
iabbrev <buffer> :pr: printf("");<c-o>F"
iabbrev <buffer> :prn: printf("\n");<c-o>F\
iabbrev <buffer> #inc" #include ""<left>
iabbrev <buffer> #inc< #include <><left>

command! -buffer -nargs=* CompileAndRun w|make %:r|!./%:r <args>

let b:interpreter  = 'clang'
let b:interpreter .= ' -Wall -Wextra -pedantic -Weverything -Wno-declaration-after-statement -Wno-strict-prototypes -Wno-shadow -Wno-padded'
let b:interpreter .= ' -Wno-error'
let b:interpreter .= ' -o /tmp/'..expand('%:t:r')
let b:interpreter .= ' -xc -'
let b:interpreter .= ' && /tmp/'..expand('%:t:r')

if findfile('Makefile') == ""
    compiler clang
endif
