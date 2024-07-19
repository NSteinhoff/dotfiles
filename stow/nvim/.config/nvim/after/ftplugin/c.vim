" Add Homebrew installed headers
" if !empty(finddir('/opt/homebrew/include/'))
"     setlocal path+=/opt/homebrew/include/
"     setlocal path+=/opt/homebrew/opt/*/include
" endif

" Add Mac OS X development headers location
if (executable('xcrun'))
        execute 'setlocal path+='..systemlist('xcrun --show-sdk-path')[0]..'/usr/include/'
endif

" Add Rust style 'internal' doc comments for module level documentation.
setlocal comments =sO:*\ -,mO:*\ \ ,exO:*/
setlocal comments+=s1:/*,mb:*,ex:*/
setlocal comments+=:///,://!,://
setlocal keywordprg=:Man\ 3
iabbrev <buffer> :pr: printf("");<c-o>F"
iabbrev <buffer> :prn: printf("\n");<c-o>F\
iabbrev <buffer> #inc" #include ""<left>
iabbrev <buffer> #inc< #include <><left>
iabbrev <buffer> :err: if (err) return err;
iabbrev <buffer> :errgo: if (err) goto error;

command! -buffer -nargs=* CompileAndRun w|make %:r|!./%:r <args>
nnoremap <buffer> gO <cmd>TagToc ! m<cr>

let b:interpreter  = 'clang'
let b:interpreter .= ' -Wno-error' " run anyways
let b:interpreter .= ' -Wall'
let b:interpreter .= ' -Wextra'
let b:interpreter .= ' -pedantic'
let b:interpreter .= ' -Wconversion'
let b:interpreter .= ' -Wmissing-prototypes'
let b:interpreter .= ' -o /tmp/'..expand('%:t:r')
let b:interpreter .= ' -xc -'
let b:interpreter .= ' && /tmp/'..expand('%:t:r')

if findfile('Makefile') == ""
    compiler clang
else
    set errorformat+=Assertion\ \failed:\ %m\\,\ file\ %f\\,\ line\ %l%.
endif
