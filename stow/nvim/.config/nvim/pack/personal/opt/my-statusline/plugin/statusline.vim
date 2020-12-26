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

function Pomodoro()
    try
        return v:lua.Pomodoro.statusline()
    catch
        return ''
    endtry
endfunction

function LspStatus()
    try
        return v:lua.My_lsp.status()
    catch
        return ''
    endtry
endfunction

function TSStatus()
    try
        let s:tree = nvim_treesitter#statusline()
        return s:tree != 'null' && s:tree != '' ? s:tree : ''
    catch
        return ''
    endtry
endfunction

function CoCStatus()
    if exists("*coc#status")
        let l:status = coc#status()
        return !empty(l:status) ? ' '.l:status.' ' : ''
    endif
    return ''
endfunction

function! MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#StatusLineNC#'
    let SEP         = '%='
    let GIT         = '%#GitBranch#'

    let args        = '%a'
    let ft          = '%y'
    let pre         = '%w'
    if &ft == 'dirvish'
        let file        = ' %f '
    else
        let file        = ' %f '
    endif
    let branch      = '%{GitBranch()}'
    let tree        = '%{TSStatus()}'
    let mod        = '%m'
    let spell       = '%{Spell()}'
    let compiler    = '%{Compiler()}'
    let errors      = '%{Errors()}'
    let pomodoro    = '%{Pomodoro()}'
    let position    = ' ☰ %l:%c | %p%% '
    let lsp         = '%{LspStatus()}'
    let coc         = '%{CoCStatus()}'

    return pre.ft.OPT.file.mod.args.SEP.coc.lsp.errors.compiler.spell.BAR.position
endfunction

set statusline=%!MyStatusline()
set laststatus=2
