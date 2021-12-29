if exists(':Open')
    command -buffer -nargs=1 RustStd Open https://doc.rust-lang.org/std/index.html?search=<args>
    setlocal keywordprg=:RustStd
endif

set define=^\\v(pub\\s+)?(fn\|struct\|const\|type)\\ze\\s+\\i+
set include=\\v^(pub\\s+)?(mod\|use)\\s+\\zs(\\w+(::)?)+\\ze(::\\{\|::\\*)?.*;
set includeexpr=substitute(substitute(v:fname,'::','/','g'),'/$','','')

let buf = expand('%')

if empty(buf)|finish|endif

" Search from current buffer upwards until $HOME
let path = (isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
" Do we have a Cargo.toml file?
let use_cargo = !empty(findfile('Cargo.toml', path))
" Do we have a Makefile?
let use_make = !empty(findfile('Makefile', path))

if use_cargo
    " When we have a Cargo.toml, we probably want to build with `cargo build`
    compiler cargo
elseif use_make
    " When there is a Makefile, we build using `make`, but we use the
    " 'errorformat' for the `rustc` compiler to parse the output.
    compiler rustc
    set makeprg=make\ $*
else
    " This seems to be a standalone rust file, so we use the plain `rustc`
    " compiler.
    compiler rustc
end


setlocal formatoptions-=o

command Docs call jobstart('cargo doc --open')
