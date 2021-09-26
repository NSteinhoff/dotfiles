function Errors()
    if winwidth(0) < 50
        return ''
    endif

    let nq = len(filter(getqflist(), 'v:val.valid == 1'))
    let nl = len(filter(getloclist(0), 'v:val.valid == 1'))
    let iq = getqflist({'idx': 0}).idx
    let il = getloclist(0, {'idx': 0}).idx
    let q = nq ? iq..':'..nq : '-'
    let l = nl ? il..':'..nl : '-'

    return nl || nq ? '['..q..'|'..l..']' : ''
endfunction

function Compiler()
    let compiler = compiler#which()
    if compiler == 'NONE'|return ''|endif
    if winwidth(0) >= 100
        return '[ '..compiler..']'
    else
        return ''
    endif
endfunction

function Interpreter()
    let interpreter = get(b:, 'interpreter', 'NONE')
    let interpreter = matchstr(interpreter, '\w\+')
    if interpreter == 'NONE'|return ''|endif
    if winwidth(0) >= 100
        return '[ '..interpreter..']'
    else
        return ''
    endif
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
        let status = luaeval('require("my_lsp.status").'..(small ? 'tiny' : 'long')..'()')
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

function GitDiffTarget()
    if tabpagenr('$') > 1 && &showtabline == 1 || &showtabline > 1|return ''|endif
    let revision = get(t:, 'diff_target', '')
    return empty(revision) ? '' : ' ( '..revision..')'
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
        let file = empty(expand('%')) ? '' : ' '..(winwidth(0) < 100 ? pathshorten(expand('%:.')) : expand('%:.'))
    endif

    return file
endfunction


function MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#Normal#'
    let CLR         = '%#Normal#'
    let SPC         = '%#Special#'
    let WRN         = '%#Todo#'
    let SEP         = '%='
    let FOC         = '%#StatusLineFocus#'

    let args        = '%a'
    let ft          = '%y'
    let pre         = '%w'
    let file        = '%{CurrentFile()}'
    let branch      = '%{GitBranch()}'
    let review      = '%{GitDiffTarget()}'
    let mod         = '%m'
    let spell       = '%{Spell()}'
    let compiler    = '%{Compiler()}'
    let interpreter = '%{Interpreter()}'
    let errors      = '%{Errors()}'
    let position    = '☰ %l:%c | %p%%'
    let lsp         = '%{LspStatus()}'
    let tree        = '%{Tree()}'

    let stl  = pre
    let stl .= ft
    let stl .= branch
    let stl .= WRN
    let stl .= review
    let stl .= OPT
    let stl .= ' '
    let stl .= file
    let stl .= ' '
    let stl .= mod
    let stl .= args
    let stl .= SPC
    let stl .= SEP
    let stl .= OPT
    let stl .= errors
    let stl .= spell
    let stl .= lsp
    let stl .= compiler
    let stl .= interpreter
    let stl .= BAR
    let stl .= ' '
    let stl .= position

    return stl
endfunction

set statusline=%!MyStatusline()
set laststatus=2
