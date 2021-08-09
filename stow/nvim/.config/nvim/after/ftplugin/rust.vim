if exists(':Open')
    command -buffer -nargs=1 RustStd Open https://doc.rust-lang.org/std/index.html?search=<args>
    setlocal keywordprg=:RustStd
endif

set define=^\\v(pub\\s+)?(fn\|struct\|const\|type)\\ze\\s+\\i+
set include=\\v^(pub\\s+)?(mod\|use)\\s+\\zs(\\w+(::)?)+\\ze(::\\{\|::\\*)?.*;
set includeexpr=substitute(substitute(v:fname,'::','/','g'),'/$','','')

compiler cargo

setlocal formatoptions-=o

if executable('rustfmt')
    setlocal formatexpr=
    setlocal formatprg=rustfmt\ --emit=stdout
endif

command Docs call jobstart('cargo doc --open')
