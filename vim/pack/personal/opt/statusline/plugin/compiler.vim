" What's the current compiler?
function! compiler#which()
    if exists('b:current_compiler')
        return b:current_compiler
    elseif exists('g:current_compiler')
        return g:current_compiler
    else
        return 'NONE'
endfunction


function! compiler#with(name)
    let old = compiler#which()
    execute 'compiler! '.a:name
    make
    if old != 'NONE'
        execute 'compiler '.old
    endif
endfunction


function! compiler#describe()
    if exists('g:current_compiler')
        let gcompiler = g:current_compiler
    else
        let gcompiler = 'NONE'
    endif
    if exists('b:current_compiler')
        let bcompiler = b:current_compiler
    else
        let bcompiler = 'NONE'
    endif

    echo "Compiler: "
    echo "\tGlobal: ".gcompiler
    echo "\tLocal: ".bcompiler
    verbose set mp?
    verbose set efm?
endfunction
