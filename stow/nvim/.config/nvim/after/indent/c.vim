source <sfile>:h/formatter/clang-format.vim

setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=0
setlocal cinoptions+=l1
setlocal textwidth=100

function s:create_fix()
    return 'clang-tidy --fix --format-style='..s:style()..' '..expand('%')
endfunction

if executable('clang-tidy')
    let b:fixprgfunc = function('s:create_fix')
endif
