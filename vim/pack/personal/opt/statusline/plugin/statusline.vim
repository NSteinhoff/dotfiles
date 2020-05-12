function! Errors()
    let nqf = len(filter(getqflist(), 'v:val["valid"] == 1'))
    let nloc = len(filter(getloclist(0), 'v:val["valid"] == 1'))
    return nloc || nqf ? '[q:'.nqf.'|l:'.nloc.'] ' : ''
endfunction

function! Compiler()
    let compiler = compiler#which()
    return compiler != 'NONE' ? '['.compiler.'] ' : ''
endfunction

function! Spell()
    return &spell ? '[spell] ' : ''
endfunction

function! MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#Question#'
    let SEP         = '%='

    let args        = '%a'
    let file        = '%y %t '
    let tags        = ' %m %h %w %q '
    let spell       = '%{Spell()}'
    let compiler    = '%{Compiler()}'
    let errors      = '%{Errors()}'
    let lsp         = '%{lsp#Indicator()}'
    let position    = ' ☰ %l:%c | %p%% '

    return file.OPT.args.tags.SEP.errors.lsp.compiler.spell.BAR.position
endfunction

set statusline=%!MyStatusline()
