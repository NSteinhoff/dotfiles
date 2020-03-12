function! StatuslineErrors()
    let nqf = len(getqflist())
    let nloc = len(getloclist(0))
    if nloc || nqf
        return '['.nqf.'|'.nloc.'] '
    else
        return ''
    endif
endfunction

function! StatuslineArgs()
    let nargs = argc()
    let idx = argidx() + 1
    if nargs > 1
        return '['.idx.'/'.nargs.'] '
    else
        return ''
    endif
endfunction

function! StatuslineCompiler()
    let compiler = compiler#which()
    if compiler == 'NONE'
        return ''
    else
        return '['.compiler.'] '
    endif
endfunction

function! StatuslineSpell()
    return &spell ? '[spell] ' : ''
endfunction

function! statusline#Statusline()
    let BAR         = '%*'
    let OPT         = '%#Question#'
    let SEP         = '%='

    let file        = '%y %f '
    let args        = '%{StatuslineArgs()} '
    let tags        = '%m %h %w %q '
    let spell       = '%{StatuslineSpell()}'
    let compiler    = '%{StatuslineCompiler()}'
    let errors      = '%{StatuslineErrors()}'
    let lsp         = '%{lsp#Indicator()}'
    let position    = ' ☰ %l:%c | %p%% '

    return file.OPT.args.tags.SEP.errors.lsp.compiler.spell.BAR.position
endfunction


set laststatus=2
set statusline=%!statusline#Statusline()
