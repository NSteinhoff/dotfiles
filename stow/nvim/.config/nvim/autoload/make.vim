function make#ignore_make_errors()
    if empty(&errorformat)|return|endif
    if empty(&makeprg)|return|endif
    if &makeprg !~ '^make'|return|endif
    if &errorformat =~ '%-Gmake: \*\*\*%\.%#'|return|endif

    let local = empty(&l:errorformat) ? '' : 'local'
    execute 'set'..local..' errorformat^=%-Gmake:\ ***%.%#'
endfunction

