" Cool help screens:
" - group-name
" - highlight-groups
" - cterm-colors

highlight clear
if exists("syntax_on")
    syntax reset
endif
set t_Co=16

set bg=dark
let g:colors_name="minimal"
let bg='NONE'
let fg='NONE'

" execute 'highlight Normal cterm=none ctermfg='.fg.' ctermbg='.bg
highlight clear Normal

" Helper functions {{{

" Create styles that can be used to link groups to
function! s:init_styles(styles)
    for [name, opts] in items(a:styles)
        call s:create_group(name, opts)
    endfor
endfunction

" Apply a syntax highlight style based on a dicationary of options.
function! s:create_group(name, opts)
    let n = a:name
    let lig = get(a:opts, 'lig', 'NONE')
    let fg = get(a:opts, 'fg', 'NONE')
    let bg = get(a:opts, 'bg', 'NONE')
    exec "highlight " . n . " cterm=" . lig . " ctermfg=" . fg . " ctermbg=" . bg
endfunction

" Highligh all items in a group with the configured style
function! s:link_groups(groups, styles)
    for [group, style] in items(a:styles)
        let items = a:groups[group]
        call s:link_items_to_style(items, style)
    endfor
endfunction

" Highlight items as a certain style by linking
function! s:link_items_to_style(items, style)
    for item in a:items
        exec "highlight! link " . item . " " . a:style
    endfor
endfunction
" }}}

if !get(g:, 'minimal_test_colors')
    function! s:test_colors(split)
        syntax clear
        let l:styles = sort(keys(copy(s:styles)))
        if a:split
            let l:colors = filter(copy(l:styles), {_, v -> v !~# 'H\u'})

            let l:highlights = filter(copy(l:styles), {_, v -> v =~# 'H\u'})
            let l:normal = filter(copy(l:highlights), {_, v -> v !~# 'Light' && v !~# 'Dark' && v !~# 'Fade'})
            let l:light = filter(copy(l:highlights), {_, v -> v =~# 'Light'})
            let l:dark = filter(copy(l:highlights), {_, v -> v =~# 'Dark'})
            let l:fade = filter(copy(l:highlights), {_, v -> v =~# 'Fade'})

            vertical new
            set buftype=nofile
            call append('$',  l:colors + l:normal + l:light + l:dark + l:fade)
            0delete
        endif
        for style in l:styles
            execute 'syntax match '.style.' /"\?'.style.'"\?/'
        endfor
        setlocal completefunc=CompleteStyles
    endfunction

    function! CompleteStyles(findstart, base)
        if a:findstart
            " locate the start of the word
            let line = getline('.')
            let start = col('.') - 1
            while start > 0 && line[start - 1] =~ '\a'
                let start -= 1
            endwhile
            return start
        else
            return filter(keys(s:styles), {_, v -> v =~ '^'.a:base})
        endif
    endfunction
    command! -buffer -bang Test let g:minimal_test_colors=1|call s:test_colors(<bang>0)|unlet g:minimal_test_colors
endif

" Styles -> Colors {{{
let    s:styles               =    {}
let    s:styles.Normal        =    {'lig':    'NONE',    'fg':   fg,     'bg':    bg}
let    s:styles.Hidden        =    {'lig':    'NONE',    'fg':    0,     'bg':    bg}
let    s:styles.Forceful      =    {'lig':    'NONE',    'fg':    1,     'bg':    bg}
let    s:styles.Calm          =    {'lig':    'NONE',    'fg':    2,     'bg':    bg}
let    s:styles.Busy          =    {'lig':    'NONE',    'fg':    3,     'bg':    bg}
let    s:styles.Proud         =    {'lig':    'NONE',    'fg':    4,     'bg':    bg}
let    s:styles.Excited       =    {'lig':    'NONE',    'fg':    5,     'bg':    bg}
let    s:styles.Peaceful      =    {'lig':    'NONE',    'fg':    6,     'bg':    bg}
let    s:styles.Quiet         =    {'lig':    'NONE',    'fg':    7,     'bg':    bg}

" Bright
let    s:styles.Faded         =    {'lig':    'NONE',    'fg':    8,     'bg':    bg}
let    s:styles.Intense       =    {'lig':    'NONE',    'fg':    9,     'bg':    bg}
let    s:styles.Relaxed       =    {'lig':    'NONE',    'fg':    10,    'bg':    bg}
let    s:styles.Lively        =    {'lig':    'NONE',    'fg':    11,    'bg':    bg}
let    s:styles.Satisfied     =    {'lig':    'NONE',    'fg':    12,    'bg':    bg}
let    s:styles.Happy         =    {'lig':    'NONE',    'fg':    13,    'bg':    bg}
let    s:styles.Fresh         =    {'lig':    'NONE',    'fg':    14,    'bg':    bg}
let    s:styles.Pop           =    {'lig':    'NONE',    'fg':    15,    'bg':    bg}

for [k, v] in items(s:styles)
    let s:styles[k..'Italic']                  =  extend(copy(v), {'lig': 'italic'})
    let s:styles[k..'Bold']                    =  extend(copy(v), {'lig': 'bold'})
    let s:styles[k..'Underlined']              =  extend(copy(v), {'lig': 'underline'})
    let s:styles[k..'ItalicUnderlined']        =  extend(copy(v), {'lig': 'italic,underline'})
    let s:styles[k..'BoldUnderlined']          =  extend(copy(v), {'lig': 'bold,underline'})
    let s:styles[k..'ItalicBoldUnderlined']    =  extend(copy(v), {'lig': 'italic,bold,underline'})
    let s:styles[k..'Inverse']                 =  extend(copy(v), {'lig': 'inverse'})
    let s:styles[k..'BoldInverse']             =  extend(copy(v), {'lig': 'bold,inverse'})

endfor

for [k, v] in items(s:styles)
    if v['lig'] =~? 'inverse'|continue|endif
    let s:styles['H'..k]                          =   extend(copy(v), {'fg': fg, 'bg': v['fg']})
    let s:styles['HLight'..k]                     =   extend(copy(v), {'fg': v['fg'], 'bg': 15})
    let s:styles['HDark'..k]                      =   extend(copy(v), {'fg': 0, 'bg': v['fg']})
    let s:styles['HFade'..k]                      =   extend(copy(v), {'fg': v['fg'], 'bg': 8})
endfor
"" }}}

" Elements -> Styles {{{
let s:ui_styles = {}
let s:diff_styles = {}
let s:syntax_styles = {}

"" UI Styles {{{
let s:ui_styles.normal                   =  "Normal"
let s:ui_styles.title                    =  "PopBoldUnderlined"
let s:ui_styles.line                     =  "NormalUnderlined"
let s:ui_styles.notice                   =  "Forceful"
let s:ui_styles.cursor                   =  "NormalInverse"
let s:ui_styles.selection                =  "NormalBoldInverse"
let s:ui_styles.hidden                   =  "Hidden"
let s:ui_styles.ignore                   =  "Faded"
let s:ui_styles.status_inactive          =  "HFadeProud"
let s:ui_styles.status_active            =  "HDarkProud"
let s:ui_styles.status_focus             =  "HLightProud"
let s:ui_styles.status_term              =  "HDarkHappy"
let s:ui_styles.tabline_active           =  "PopBoldUnderlined"
let s:ui_styles.tabline_inactive         =  "FadedUnderlined"
let s:ui_styles.tabline_fill             =  "FadedUnderlined"
let s:ui_styles.tabline_focus            =  "ProudUnderlined"
let s:ui_styles.match                    =  "HExcited"
let s:ui_styles.highlight                =  "HDarkPop"
let s:ui_styles.highlight_dark           =  "HDarkLively"
let s:ui_styles.highlight_fade           =  "HFadeLively"
let s:ui_styles.menu                     =  "HFaded"
""}}}

"" Some more text
"" Diff Styles {{{
let s:diff_styles.add                 = "Calm"
let s:diff_styles.delete              = "Forceful"
let s:diff_styles.change              = "Busy"
let s:diff_styles.text                = "LivelyBoldUnderlined"
""}}}

"" Syntax Styles {{{
let s:syntax_styles.comment           = "Quiet"
let s:syntax_styles.identifier        = "Normal"
let s:syntax_styles.constant          = "Pop"
let s:syntax_styles.statement         = "Pop"
let s:syntax_styles.operator          = "PopBold"
let s:syntax_styles.preproc           = "Excited"
let s:syntax_styles.type              = "Peaceful"
let s:syntax_styles.special           = "Proud"
let s:syntax_styles.specialchar       = "ProudBold"
let s:syntax_styles.underlined        = "NormalUnderlined"
let s:syntax_styles.fixme             = "HLightForceful"
let s:syntax_styles.error             = "Forceful"
let s:syntax_styles.ignore            = "Faded"

let s:syntax_styles.trivial           = "Faded"
let s:syntax_styles.emphasis          = "Pop"
let s:syntax_styles.strong            = "NormalBold"
let s:syntax_styles.heavy             = "PopBold"
""}}}
"}}}

" Elements -> Groups {{{
let s:ui_groups = {}
let s:diff_groups = {}
let s:syntax_groups = {}

"" UI {{{
let s:ui_groups.normal = [
\    "NormalNc",
\    "CursorLineNr",
\    "Menu",
\    "PmenuThumb",
\    "Scrollbar",
\    "Tooltip",
\ ]
let s:ui_groups.notice = [
\    "NonText",
\ ]
let s:ui_groups.cursor = [
\    "Cursor",
\    "lCursor",
\    "CursorIM",
\    "TermCursor",
\    "TermCursorNC",
\    "MatchParen",
\ ]
let s:ui_groups.hidden = [
\    "EndOfBuffer",
\ ]
let s:ui_groups.selection = [
\    "Visual",
\ ]
let s:ui_groups.highlight_fade = [
\    "ColorColumn",
\ ]
let s:ui_groups.highlight_dark = [
\    "CursorLine",
\    "CursorColumn",
\ ]
let s:ui_groups.menu = [
\    "Pmenu",
\    "PmenuSbar",
\ ]
let s:ui_groups.highlight = [
\    "Search",
\ ]
let s:ui_groups.match = [
\    "Substitute",
\    "IncSearch",
\    "PmenuSel",
\    "WildMenu",
\ ]
let s:ui_groups.ignore = [
\    "Ignore",
\    "Folded",
\    "LineNr",
\    "SignColumn",
\    "VertSplit",
\ ]
let s:ui_groups.status_active = [
\    "StatusLine",
\ ]
let s:ui_groups.status_inactive = [
\    "StatusLineNC",
\    "StatusLineTermNC",
\ ]
let s:ui_groups.line = [
\ ]
let s:ui_groups.title = [
\    "FoldColumn",
\ ]
let s:ui_groups.status_term = [
\    "StatusLineTerm",
\ ]
let s:ui_groups.status_focus = [
\   "StatusLineFocus",
\ ]
let s:ui_groups.tabline_active = [
\    "TabLineSel",
\ ]
let s:ui_groups.tabline_inactive = [
\    "TabLine",
\ ]
let s:ui_groups.tabline_fill = [
\    "TabLineFill",
\ ]
let s:ui_groups.tabline_focus = [
\    "TabLineFocus",
\ ]
""}}}

"" Diff {{{
let s:diff_groups.add = [
\    "DiffAdd",
\    "diffAdded",
\ ]
let s:diff_groups.change = [
\    "DiffChange",
\    "diffChanged",
\ ]
let s:diff_groups.delete = [
\    "DiffDelete",
\    "diffRemoved",
\ ]
let s:diff_groups.text = [
\    "DiffText",
\ ]
""}}}

"" Syntax {{{
let s:syntax_groups.error = [
\    "Error",
\    "ErrorMsg",
\    "SpellBad",
\    "NvimInternalError",
\    "TelescopeMatching",
\    "LspDiagnosticsDefaultError",
\    "LspDiagnosticsSignError",
\ ]
let s:syntax_groups.fixme = [
\    "Todo",
\ ]
let s:syntax_groups.constant = [
\    "Constant",
\    "String",
\    "Number",
\    "Directory",
\    "markdownCode",
\    "markdownCodeBlock",
\ ]
let s:syntax_groups.identifier = [
\    "Identifier",
\    "Function",
\ ]
let s:syntax_groups.statement = [
\    "Statement",
\    "Keyword",
\ ]
let s:syntax_groups.operator = [
\    "Operator",
\    "Exception",
\ ]
let s:syntax_groups.type = [
\    "Type",
\ ]
let s:syntax_groups.preproc = [
\    "PreProc",
\ ]
let s:syntax_groups.comment = [
\    "Comment",
\    "Question",
\    "LspDiagnosticsDefaultInformation",
\    "LspDiagnosticsSignInformation",
\ ]
let s:syntax_groups.trivial = [
\    "Ignore",
\    "Conceal",
\    "Noise",
\    "LspDiagnosticsDefaultHint",
\    "LspDiagnosticsSignHint",
\ ]
let s:syntax_groups.specialchar = [
\    "SpecialChar",
\    "SpecialKey",
\    "Delimiter",
\ ]
let s:syntax_groups.special = [
\    "Special",
\    "SpecialComment",
\    "SpellCap",
\    "SpellLocal",
\    "SpellRare",
\    "Title",
\    "netrwSymLink",
\    "TelescopeSelection",
\ ]
let s:syntax_groups.underlined = [
\    "Underlined",
\    "LspDiagnosticsUnderline",
\    "LspDiagnosticsUnderlineError",
\    "LspDiagnosticsUnderlineHint",
\    "LspDiagnosticsUnderlineInformation",
\    "LspDiagnosticsUnderlineWarning",
\    "LspReferenceText",
\    "LspReferenceRead",
\    "LspReferenceWrite",
\ ]
let s:syntax_groups.ignore = [
\    "Ignore",
\ ]
let s:syntax_groups.emphasis = [
\    "markdownItalic",
\    "mkdItalic",
\    "mkdLineBreak",
\    "htmlItalic",
\    "htmlUnderlineItalic",
\    "LspDiagnosticsDefaultWarning",
\    "LspDiagnosticsSignWarning",
\ ]
let s:syntax_groups.strong = [
\   "markdownBold",
\   "markdownBoldItalic",
\   "mkdBold",
\   "mkdBoldItalic",
\   "htmlBold",
\   "htmlBoldItalic",
\ ]
let s:syntax_groups.heavy = [
\   "htmlUnderlineBold",
\   "htmlBoldUnderlineItalic",
\ ]
""}}}
"}}}

" First we create the new highlight groups that everything
" else links to.
call s:init_styles(s:styles)

" Now we link the individual elements in *_groups to their respective
" style group as defined in the *_styles.
call s:link_groups(s:ui_groups, s:ui_styles)
call s:link_groups(s:diff_groups, s:diff_styles)
call s:link_groups(s:syntax_groups, s:syntax_styles)

syntax enable
"}}}
" vim: foldmethod=marker
