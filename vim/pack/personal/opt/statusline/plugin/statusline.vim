function! Errors()
    let nqf = len(getqflist())
    let nloc = len(getloclist(0))
    if nloc || nqf
        return '[q:'.nqf.'|l:'.nloc.'] '
    else
        return ''
    endif
endfunction

function! Args()
    let nargs = argc()
    let idx = argidx() + 1
    if nargs > 1
        return '['.idx.'/'.nargs.'] '
    else
        return ''
    endif
endfunction

function! Buffers()
    let n_buffers = len(getbufinfo({'buflisted': 1}))
    return '['.n_buffers.']'
endfunction

function! Compiler()
    let compiler = compiler#which()
    if compiler == 'NONE'
        return ''
    else
        return '['.compiler.'] '
    endif
endfunction

function! Spell()
    return &spell ? '[spell] ' : ''
endfunction

function! statusline#()
    let BAR         = '%*'
    let OPT         = '%#Question#'
    let SEP         = '%='

    let buffers     = '%{Buffers()}'
    let file        = '%y %f '
    let args        = '%{Args()} '
    let tags        = '%m %h %w %q '
    let spell       = '%{Spell()}'
    let compiler    = '%{Compiler()}'
    let errors      = '%{Errors()}'
    let lsp         = '%{lsp#Indicator()}'
    let position    = ' ☰ %l:%c | %p%% '

    return buffers.file.OPT.args.tags.SEP.errors.lsp.compiler.spell.BAR.position
endfunction

set statusline=%!statusline#()
