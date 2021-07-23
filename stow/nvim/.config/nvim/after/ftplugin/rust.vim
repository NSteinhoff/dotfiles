set define=^\\v(pub\\s+)?(fn\|struct\|const\|type)\\ze\\s+\\i+
set include=\\v^(pub\\s+)?(mod\|use)\\s+\\zs(\\w+(::)?)+\\ze(::\\{\|::\\*)?.*;
set includeexpr=substitute(substitute(v:fname,'::','/','g'),'/$','','')

compiler cargo

setlocal formatoptions-=o

if executable('rustfmt')
    setlocal formatexpr=
    setlocal formatprg=rustfmt\ --emit=stdout
endif

if exists(':DD')
    setlocal keywordprg=:DD
endif

command Docs call jobstart('cargo doc --open')
