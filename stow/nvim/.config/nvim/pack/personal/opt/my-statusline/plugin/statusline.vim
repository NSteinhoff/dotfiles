function Errors()
    if winwidth(0) < 100
        return ''
    endif

    let nq = len(filter(getqflist(), 'v:val["valid"] == 1'))
    let nl = len(filter(getloclist(0), 'v:val["valid"] == 1'))
    let iq = getqflist({'idx': 0}).idx
    let il = getloclist(0, {'idx': 0}).idx
    let q = nq ? iq..':'..nq : '-'
    let l = nl ? il..':'..nl : '-'

    return nl || nq ? '['..q..'|'..l..']' : ''
endfunction

function Compiler()
    let compiler = compiler#which()
    return compiler != 'NONE' ? winwidth(0) < 100 ? ' ' : '[ '..compiler..']' : ''
endfunction

function Tree()
    " if !exists('*nvim_treesitter#statusline') | return '' | endif
    let width = (winwidth(0) - 60) / 2
    if width < 40
        return ''
    endif
    let opts = {
        \   'indicator_size': width,
        \   'separator': '  ',
        \}
    try
        let pos = nvim_treesitter#statusline(opts)
    catch
        let pos = ''
    endtry
    return empty(pos) || pos ==? 'null' ? '' : ' '..pos
endfunction

function Spell()
    return &spell ? '[spell]' : ''
endfunction

function LspStatus()
    try
        let small = winwidth(0) < 100
        let status = luaeval('require("my_lsp").status.'..(small ? 'tiny' : 'long')..'()')
        return !empty(status) ? small ? status..' ' : '['..status..']' : ''
    catch
        return ''
    endtry
endfunction

function GitBranch()
    if empty(finddir('.git', ';$HOME'))|return ''|endif
    if winwidth(0) < 79|return '  '|endif

    try
        let branch = systemlist('git branch --show-current')[0]
        if strchars(branch) > (winwidth(0) < 100 ? 15
                           \ : winwidth(0) < 150 ? 25
                           \ :                     50)
            let shift = winwidth(0) < 100 ? 5
                    \ : winwidth(0) < 150 ? 10
                    \ :                     20
            let branch = branch[0:shift]..'...'..branch[-1-shift:-1]
        endif
        return empty(branch) ? '' : '  '..branch..' '
    catch
        return ''
    endtry
endfunction

function Alt()
    let alt = expand('#:t')
    if empty(alt) || expand('#') == expand('%')
        return ''
    endif
    return ' '..alt
endfunction

function CurrentFile()
    if &ft == 'dirvish'
        let file = ' '..(empty(expand('%:.')) ? './' : '')..expand('%:.')
    elseif &ft == 'filefinder'
        let file = ' '..expand('%')
    elseif &ft == 'livegrep'
        let file = ' '..expand('%')
    elseif &ft == 'buflist'
        let file = ' '..expand('%')
    elseif &ft == 'qfedit'
        let file = ' '..expand('%')
    else
        let file = !empty(expand('%')) ? ' '..expand('%:t') : ''
    endif

    return file
endfunction


function MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#StatusLineNC#'
    let CLR         = '%#Normal#'
    let SPC         = '%#Special#'
    let SEP         = '%='
    let FOC         = '%#StatusLineFocus#'

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
    let tree        = '%{Tree()}'

    return pre..ft..branch..OPT..' '..file..' '..mod..args..SPC..tree..SEP..OPT..errors..spell..lsp..compiler..BAR..' '..position
endfunction

set statusline=%!MyStatusline()
set laststatus=2
