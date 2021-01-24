function! Errors()
    let nqf = len(filter(getqflist(), 'v:val["valid"] == 1'))
    let nloc = len(filter(getloclist(0), 'v:val["valid"] == 1'))
    return nloc || nqf ? '[q:'.nqf.'|l:'.nloc.'] ' : ''
endfunction

function! Compiler()
    let compiler = compiler#which()
    return compiler != 'NONE' ? '[ '.compiler.'] ' : ''
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
        return v:lua.lsp_status()
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

function GitBranch()
    if empty(finddir('.git', ';$HOME')) | return '' | endif
    try
        let branch = systemlist('git branch --show-current')[0]
        return empty(branch) ? '' : '  '.branch.' '
    catch
        return ''
    endtry
endfunction

function! Alt()
    let alt = expand('#:t')
    if empty(alt)
        return ''
    endif
    return ' (#'.alt.')'
endfunction

function! MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#StatusLineNC#'
    let SEP         = '%='
    let GIT         = '%#GitBranch#'

    let cwd         = '%{getcwd()}'
    let args        = '%a'
    let ft          = '%y'
    let pre         = '%w'
    if &ft == 'dirvish'
        let file        = '  %f '
    elseif &ft == 'filefinder'
        let file        = '  '
    elseif &ft == 'livegrep'
        let file        = '  '
    elseif &ft == 'buflist'
        let file        = '  '
    else
        let file        = '  %f '
    endif
    let alt         = '%{Alt()}'
    let branch      = '%{GitBranch()}'
    let tree        = '%{TSStatus()}'
    let mod        = '%m'
    let spell       = '%{Spell()}'
    let compiler    = '%{Compiler()}'
    let errors      = '%{Errors()}'
    let pomodoro    = '%{Pomodoro()}'
    let position    = ' ☰ %l:%c | %p%% '
    let lsp         = '%{LspStatus()}'

    return pre.ft.branch.OPT.file.alt.mod.args.SEP.lsp.errors.compiler.spell.BAR.position
endfunction

set statusline=%!MyStatusline()
set laststatus=2
