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
        return v:lua.my_lsp.status()
    catch
        return ''
    endtry
endfunction

function TSStatus()
    try
        let s:tree = nvim_treesitter#statusline()
        return s:tree != 'null' && s:tree != '' ? ' @ '.s:tree : ''
    catch
        return ''
    endtry
endfunction

function! MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#Question#'
    let SEP         = '%='

    let args        = '%a'
    let ft          = '%y'
    if &ft == 'dirvish'
        let file        = '%f'
    else
        let file        = '%t'
    endif
    let tree        = '%{TSStatus()}'
    let tags        = ' %m %h %w %q '
    let spell       = '%{Spell()}'
    let compiler    = '%{Compiler()}'
    let errors      = '%{Errors()}'
    let lsp         = '%{LspStatus()}'
    let pomodoro    = '%{Pomodoro()}'
    let position    = ' ☰ %l:%c | %p%% '

    return ft.OPT.args.tags.SEP.file.tree.SEP.pomodoro.errors.lsp.compiler.spell.BAR.position
endfunction

set statusline=%!MyStatusline()
set laststatus=2
