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
    let lig = get(a:opts, 'lig', 'none')
    let fg = get(a:opts, 'fg', 'none')
    let bg = get(a:opts, 'bg', 'none')
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

" Styles -> Colors {{{
"" Hues {{{
let  s:hues                =   {}
let  s:hues.nothing        =   {'lig':  'none',       'fg':   0,    'bg':  bg}
let  s:hues.Underlined     =   {'lig':  'underline',  'fg':  fg,    'bg':  bg}
let  s:hues.Contrasted     =   {'lig':  'inverse',    'fg':  fg,    'bg':  bg}
let  s:hues.Faded          =   {'lig':  'none',       'fg':   8,    'bg':  bg}
let  s:hues.Hidden         =   {'lig':  'none',       'fg':  fg,    'bg':  bg}
let  s:hues.Bold           =   {'lig':  'bold',       'fg':  fg,    'bg':  bg}
let  s:hues.Italic         =   {'lig':  'italic',     'fg':  fg,    'bg':  bg}
let  s:hues.Pop            =   {'lig':  'none',       'fg':  15,    'bg':  bg}
let  s:hues.StrongPop      =   {'lig':  'bold',       'fg':  15,    'bg':  bg}
"" }}}

"" Moods {{{
let  s:moods            =  {}
let  s:moods.Forceful   =  {'lig':  'none',  'fg':  1,   'bg':  bg}
let  s:moods.Calm       =  {'lig':  'none',  'fg':  2,   'bg':  bg}
let  s:moods.Busy       =  {'lig':  'none',  'fg':  3,   'bg':  bg}
let  s:moods.Proud      =  {'lig':  'none',  'fg':  4,   'bg':  bg}
let  s:moods.Happy      =  {'lig':  'none',  'fg':  5,   'bg':  bg}
let  s:moods.Peaceful   =  {'lig':  'none',  'fg':  6,   'bg':  bg}
let  s:moods.Quiet      =  {'lig':  'none',  'fg':  7,   'bg':  bg}
let  s:moods.Plain      =  {'lig':  'none',  'fg':  8,   'bg':  bg}
let  s:moods.Intense    =  {'lig':  'none',  'fg':  9,   'bg':  bg}
let  s:moods.Relaxed    =  {'lig':  'none',  'fg':  10,  'bg':  bg}
let  s:moods.Lively     =  {'lig':  'none',  'fg':  11,  'bg':  bg}
let  s:moods.Satisfied  =  {'lig':  'none',  'fg':  12,  'bg':  bg}
let  s:moods.Excited    =  {'lig':  'none',  'fg':  13,  'bg':  bg}
let  s:moods.Fresh      =  {'lig':  'none',  'fg':  14,  'bg':  bg}
let  s:moods.Shy        =  {'lig':  'none',  'fg':  15,  'bg':  bg}
"" }}}

"" Highlights {{{
let    s:highlights         =   {}
let s:highlights.HPop    =   {'lig':  'none',  'fg':  15,  'bg':  8}
let s:highlights.HFaded  =   {'lig':  'none',  'fg':  7,   'bg':  8}
let s:highlights.HPeaceful            =    {'lig':    'none',       'fg':    15,    'bg':    6}
let s:highlights.HProud               =    {'lig':    'none',       'fg':    15,    'bg':    4}
let s:highlights.HCalm                =    {'lig':    'none',       'fg':    15,    'bg':    2}
let s:highlights.HForceful            =    {'lig':    'none',       'fg':    15,    'bg':    1}
let s:highlights.HHappy               =    {'lig':    'none',       'fg':    15,    'bg':    5}
let s:highlights.HBusy                =    {'lig':    'none',       'fg':    15,    'bg':    3}
let s:highlights.HExcited             =    {'lig':    'none',       'fg':    15,    'bg':    13}
let s:highlights.HSatisfied           =    {'lig':    'none',       'fg':    15,    'bg':    12}
let s:highlights.HLively              =    {'lig':    'none',       'fg':    15,    'bg':    11}
let s:highlights.HRelaxed             =    {'lig':    'none',       'fg':    15,    'bg':    10}
let s:highlights.HFresh               =    {'lig':    'none',       'fg':    15,    'bg':    14}
let s:highlights.HIntense             =    {'lig':    'none',       'fg':    15,    'bg':    9}

let s:highlights.HPeacefulDark        =    {'lig':    'none',       'fg':    0,     'bg':    6}
let s:highlights.HProudDark           =    {'lig':    'none',       'fg':    0,     'bg':    4}
let s:highlights.HCalmDark            =    {'lig':    'none',       'fg':    0,     'bg':    2}
let s:highlights.HForcefulDark        =    {'lig':    'none',       'fg':    0,     'bg':    1}
let s:highlights.HHappyDark           =    {'lig':    'none',       'fg':    0,     'bg':    5}
let s:highlights.HBusyDark            =    {'lig':    'none',       'fg':    0,     'bg':    3}
let s:highlights.HExcitedDark         =    {'lig':    'none',       'fg':    0,     'bg':    13}
let s:highlights.HSatisfiedDark       =    {'lig':    'none',       'fg':    0,     'bg':    12}
let s:highlights.HLivelyDark          =    {'lig':    'none',       'fg':    0,     'bg':    11}
let s:highlights.HRelaxedDark         =    {'lig':    'none',       'fg':    0,     'bg':    10}
let s:highlights.HFreshDark           =    {'lig':    'none',       'fg':    0,     'bg':    14}
let s:highlights.HIntenseDark         =    {'lig':    'none',       'fg':    0,     'bg':    9}

let s:highlights.HPeacefulInverse     =    {'lig':    'inverse',    'fg':    15,    'bg':    6}
let s:highlights.HProudInverse        =    {'lig':    'inverse',    'fg':    15,    'bg':    4}
let s:highlights.HCalmInverse         =    {'lig':    'inverse',    'fg':    15,    'bg':    2}
let s:highlights.HForcefulInverse     =    {'lig':    'inverse',    'fg':    15,    'bg':    1}
let s:highlights.HHappyInverse        =    {'lig':    'inverse',    'fg':    15,    'bg':    5}
let s:highlights.HBusyInverse         =    {'lig':    'inverse',    'fg':    15,    'bg':    3}
let s:highlights.HExcitedInverse      =    {'lig':    'inverse',    'fg':    15,    'bg':    13}
let s:highlights.HSatisfiedInverse    =    {'lig':    'inverse',    'fg':    15,    'bg':    12}
let s:highlights.HLivelyInverse       =    {'lig':    'inverse',    'fg':    15,    'bg':    11}
let s:highlights.HRelaxedInverse      =    {'lig':    'inverse',    'fg':    15,    'bg':    10}
let s:highlights.HFreshInverse        =    {'lig':    'inverse',    'fg':    15,    'bg':    14}
let s:highlights.HIntenseInverse      =    {'lig':    'inverse',    'fg':    15,    'bg':    9}

let s:highlights.HPeacefulInverseFade     =    {'lig':    'inverse',    'fg':    8,    'bg':    6}
let s:highlights.HProudInverseFade        =    {'lig':    'inverse',    'fg':    8,    'bg':    4}
let s:highlights.HCalmInverseFade         =    {'lig':    'inverse',    'fg':    8,    'bg':    2}
let s:highlights.HForcefulInverseFade     =    {'lig':    'inverse',    'fg':    8,    'bg':    1}
let s:highlights.HHappyInverseFade        =    {'lig':    'inverse',    'fg':    8,    'bg':    5}
let s:highlights.HBusyInverseFade         =    {'lig':    'inverse',    'fg':    8,    'bg':    3}
let s:highlights.HExcitedInverseFade      =    {'lig':    'inverse',    'fg':    8,    'bg':    13}
let s:highlights.HSatisfiedInverseFade    =    {'lig':    'inverse',    'fg':    8,    'bg':    12}
let s:highlights.HLivelyInverseFade       =    {'lig':    'inverse',    'fg':    8,    'bg':    11}
let s:highlights.HRelaxedInverseFade      =    {'lig':    'inverse',    'fg':    8,    'bg':    10}
let s:highlights.HFreshInverseFade        =    {'lig':    'inverse',    'fg':    8,    'bg':    14}
let s:highlights.HIntenseInverseFade      =    {'lig':    'inverse',    'fg':    8,    'bg':    9}
"" }}}
" }}}

" Elements -> Styles {{{
let s:ui_styles = {}
let s:diff_styles = {}
let s:syntax_styles = {}

"" UI Styles {{{
let s:ui_styles.normal                   =  "Normal"
let s:ui_styles.title                    =  "StrongPop"
let s:ui_styles.line                     =  "Underlined"
let s:ui_styles.notice                   =  "Forceful"
let s:ui_styles.cursor                   =  "Contrasted"
let s:ui_styles.selection                =  "Contrasted"
let s:ui_styles.hidden                   =  "Hidden"
let s:ui_styles.ignore                   =  "Faded"
let s:ui_styles.status_inactive          =  "HFreshInverseFade"
let s:ui_styles.status_active            =  "HFresh"
let s:ui_styles.status_term              =  "HRelaxed"
let s:ui_styles.status_focus             =  "HFreshInverse"
let s:ui_styles.match                    =  "HExcited"
let s:ui_styles.highlight                =  "HPop"
let s:ui_styles.highlight_dark           =  "HLivelyDark"
let s:ui_styles.highlight_inverted       =  "HLivelyInverse"
""}}}

"" Diff Styles {{{
let s:diff_styles.add                 = "Calm"
let s:diff_styles.delete              = "Forceful"
let s:diff_styles.change              = "Lively"
let s:diff_styles.text                = "HLivelyDark"
""}}}_COLOR

"" Syntax Styles {{{
let s:syntax_styles.error             = "Forceful"
let s:syntax_styles.constant          = "Calm"
let s:syntax_styles.literal           = "Busy"
let s:syntax_styles.identifier        = "Normal"
let s:syntax_styles.statement         = "Bold"
let s:syntax_styles.operator          = "Happy"
let s:syntax_styles.type              = "Peaceful"
let s:syntax_styles.preproc           = "Lively"
let s:syntax_styles.trivial           = "Faded"
let s:syntax_styles.informative       = "Fresh"
let s:syntax_styles.special           = "Proud"
let s:syntax_styles.underlined        = "Underlined"
let s:syntax_styles.emphasis          = "Italic"
let s:syntax_styles.strong            = "Pop"
let s:syntax_styles.heavy             = "StrongPop"
let s:syntax_styles.fixme             = "HForcefulInverse"
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
\ ]
let s:ui_groups.hidden = [
\    "EndOfBuffer",
\ ]
let s:ui_groups.selection = [
\    "Visual",
\    "Pmenu",
\    "PmenuSbar",
\ ]
let s:ui_groups.highlight_inverted = [
\    "ColorColumn",
\ ]
let s:ui_groups.highlight_dark = [
\    "CursorLine",
\    "CursorColumn",
\ ]
let s:ui_groups.highlight = [
\    "Search",
\ ]
let s:ui_groups.match = [
\    "Substitute",
\    "IncSearch",
\    "PmenuSel",
\    "WildMenu",
\    "MatchParen",
\ ]
let s:ui_groups.ignore = [
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
\    "TabLine",
\    "TabLineFill",
\ ]
let s:ui_groups.title = [
\    "FoldColumn",
\    "TabLineSel",
\ ]
let s:ui_groups.status_term = [
\    "StatusLineTerm",
\ ]
let s:ui_groups.status_focus = [
\   "StatusLineFocus",
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
let s:syntax_groups.literal = [
\    "String",
\ ]
let s:syntax_groups.constant = [
\    "Constant",
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
let s:syntax_groups.informative = [
\    "Comment",
\    "Question",
\    "LspReferenceText",
\    "LspReferenceRead",
\    "LspReferenceWrite",
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
let s:syntax_groups.special = [
\    "Delimiter",
\    "Special",
\    "SpecialKey",
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
call s:init_styles(s:hues)
call s:init_styles(s:moods)
call s:init_styles(s:highlights)

" Now we link the individual elements in *_groups to their respective
" style group as defined in the *_styles.
call s:link_groups(s:ui_groups, s:ui_styles)
call s:link_groups(s:diff_groups, s:diff_styles)
call s:link_groups(s:syntax_groups, s:syntax_styles)

syntax enable

syntax keyword nothing nothing
syntax keyword Underlined Underlined
syntax keyword Contrasted Contrasted
syntax keyword Faded Faded
syntax keyword Hidden Hidden
syntax keyword Bold Bold
syntax keyword Italic Italic
syntax keyword Pop Pop
syntax keyword StrongPop StrongPop

syntax keyword Proud Proud
syntax keyword Calm Calm
syntax keyword Peaceful Peaceful
syntax keyword Quiet Quiet
syntax keyword Plain Plain
syntax keyword Forceful Forceful
syntax keyword Happy Happy
syntax keyword Busy Busy
syntax keyword Satisfied Satisfied
syntax keyword Relaxed Relaxed
syntax keyword Fresh Fresh
syntax keyword Intense Intense
syntax keyword Excited Excited
syntax keyword Lively Lively
syntax keyword Shy Shy

syntax keyword HPop HPop
syntax keyword HFaded HFaded
syntax keyword HPeaceful HPeaceful
syntax keyword HProud HProud
syntax keyword HCalm HCalm
syntax keyword HForceful HForceful
syntax keyword HHappy HHappy
syntax keyword HBusy HBusy
syntax keyword HExcited HExcited
syntax keyword HSatisfied HSatisfied
syntax keyword HLively HLively
syntax keyword HRelaxed HRelaxed
syntax keyword HFresh HFresh
syntax keyword HIntense HIntense

syntax keyword HPopDark HPopDark
syntax keyword HFadedDark HFadedDark
syntax keyword HPeacefulDark HPeacefulDark
syntax keyword HProudDark HProudDark
syntax keyword HCalmDark HCalmDark
syntax keyword HForcefulDark HForcefulDark
syntax keyword HHappyDark HHappyDark
syntax keyword HBusyDark HBusyDark
syntax keyword HExcitedDark HExcitedDark
syntax keyword HSatisfiedDark HSatisfiedDark
syntax keyword HLivelyDark HLivelyDark
syntax keyword HRelaxedDark HRelaxedDark
syntax keyword HFreshDark HFreshDark
syntax keyword HIntenseDark HIntenseDark

syntax keyword HPopInverse HPopInverse
syntax keyword HFadedInverse HFadedInverse
syntax keyword HPeacefulInverse HPeacefulInverse
syntax keyword HProudInverse HProudInverse
syntax keyword HCalmInverse HCalmInverse
syntax keyword HForcefulInverse HForcefulInverse
syntax keyword HHappyInverse HHappyInverse
syntax keyword HBusyInverse HBusyInverse
syntax keyword HExcitedInverse HExcitedInverse
syntax keyword HSatisfiedInverse HSatisfiedInverse
syntax keyword HLivelyInverse HLivelyInverse
syntax keyword HRelaxedInverse HRelaxedInverse
syntax keyword HFreshInverse HFreshInverse
syntax keyword HIntenseInverse HIntenseInverse

syntax keyword HPopInverseFade HPopInverseFade
syntax keyword HFadedInverseFade HFadedInverseFade
syntax keyword HPeacefulInverseFade HPeacefulInverseFade
syntax keyword HProudInverseFade HProudInverseFade
syntax keyword HCalmInverseFade HCalmInverseFade
syntax keyword HForcefulInverseFade HForcefulInverseFade
syntax keyword HHappyInverseFade HHappyInverseFade
syntax keyword HBusyInverseFade HBusyInverseFade
syntax keyword HExcitedInverseFade HExcitedInverseFade
syntax keyword HSatisfiedInverseFade HSatisfiedInverseFade
syntax keyword HLivelyInverseFade HLivelyInverseFade
syntax keyword HRelaxedInverseFade HRelaxedInverseFade
syntax keyword HFreshInverseFade HFreshInverseFade
syntax keyword HIntenseInverseFade HIntenseInverseFade
"}}}

" vim: foldmethod=marker
