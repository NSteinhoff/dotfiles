function Errors()
    let nq = len(filter(getqflist(), 'v:val["valid"] == 1'))
    let nl = len(filter(getloclist(0), 'v:val["valid"] == 1'))
    let iq = getqflist({'idx': 0}).idx
    let il = getloclist(0, {'idx': 0}).idx
    let q = nq ? 'Q:'.iq.'/'.nq : ''
    let l = nl ? 'L:'.il.'/'.nl : ''
    return nl || nq ? '['.q.(nl && nq ? '|' : '').l.']' : ''
endfunction

function Compiler()
    let compiler = compiler#which()
    return compiler != 'NONE' ? '[ '.compiler.']' : ''
endfunction


function Spell()
    return &spell ? '[spell]' : ''
endfunction

function LspStatus()
    try
        return v:lua.lsp_status()
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

function Alt()
    let alt = expand('#:t')
    if empty(alt) || expand('#') == expand('%')
        return ''
    endif
    return ' '.alt
endfunction

function CurrentFile()
    if &ft == 'dirvish'
        let file = ' '.(empty(expand('%:.')) ? './' : '').expand('%:.')
    elseif &ft == 'filefinder'
        let file = ' FIND'
    elseif &ft == 'livegrep'
        let file = ' GREP'
    elseif &ft == 'buflist'
        let file = ' BUFFERS'
    else
        let file = !empty(expand('%')) ? ' '.expand('%:t') : ''
    endif

    if empty(expand('#:t')) || expand('#') == expand('%')
        let alt = ''
    else
        let alt = ' '.expand('#:t')
    endif

    return (empty(file) ? '' : '['.file.']').(empty(alt) || empty(file) ? '' : ' ').(empty(alt) ? '' : alt)
endfunction


function MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#StatusLineNC#'
    let CLR         = '%#Normal#'
    let SEP         = '%='
    let GIT         = '%#GitBranch#'

    let cwd         = '%{getcwd()}'
    let args        = '%a'
    let ft          = '%y'
    let pre         = '%w'
    let file        = '%{CurrentFile()}'
    let branch      = '%{GitBranch()}'
    let mod         = '%m'
    let spell       = '%{Spell()}'
    let compiler    = '%{Compiler()}'
    let errors      = '%{Errors()}'
    let position    = '☰ %l:%c | %p%%'
    let lsp         = '%{LspStatus()}'

    return pre.ft.branch.OPT.file.mod.args.CLR.SEP.OPT.spell.errors.lsp.compiler.BAR.' '.position
endfunction

set statusline=%!MyStatusline()
set laststatus=2
