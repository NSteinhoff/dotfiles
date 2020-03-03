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
if &background == 'dark'
    let bg='NONE'
    let fg='NONE'
else
    let bg=15
    let fg=8
endif

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
if &background == 'dark'
    "" Hues {{{
    let  s:hues             =  {}
    let  s:hues.nothing     =  {'lig':  'none',       'fg':  0,     'bg':  bg}
    let  s:hues.Underlined  =  {'lig':  'underline',  'fg':  fg,  'bg':  bg}
    let  s:hues.Contrasted  =  {'lig':  'inverse',    'fg':  fg,  'bg':  bg}
    let  s:hues.Faded       =  {'lig':  'none',       'fg':  8,     'bg':  bg}
    let  s:hues.Hidden      =  {'lig':  'none',       'fg':  fg,  'bg':  bg}
    let  s:hues.Bold        =  {'lig':  'bold',       'fg':  fg,  'bg':  bg}
    let  s:hues.Italic      =  {'lig':  'italic',     'fg':  fg,  'bg':  bg}
    let  s:hues.Pop         =  {'lig':  'none',       'fg':  15,    'bg':  bg}
    let  s:hues.StrongPop   =  {'lig':  'bold',       'fg':  15,    'bg':  bg}
    "" }}}
else
    "" Hues {{{
    let  s:hues             =  {}
    let  s:hues.nothing     =  {'lig':  'none',       'fg':  fg,  'bg':  bg}
    let  s:hues.Underlined  =  {'lig':  'underline',  'fg':  fg,  'bg':  bg}
    let  s:hues.Contrasted  =  {'lig':  'inverse',    'fg':  fg,  'bg':  bg}
    let  s:hues.Faded       =  {'lig':  'none',       'fg':  7,     'bg':  bg}
    let  s:hues.Hidden      =  {'lig':  'none',       'fg':  fg,  'bg':  bg}
    let  s:hues.Bold        =  {'lig':  'bold',       'fg':  fg,  'bg':  bg}
    let  s:hues.Italic      =  {'lig':  'bold',       'fg':  fg,  'bg':  bg}
    let  s:hues.Pop         =  {'lig':  'none',       'fg':  0,     'bg':  bg}
    let  s:hues.StrongPop   =  {'lig':  'bold',       'fg':  0,     'bg':  bg}
    "" }}}
endif

"" Moods {{{
    let  s:moods            =  {}
    let  s:moods.Proud      =  {'lig':  'none',  'fg':  4,   'bg':  bg}
    let  s:moods.Calm       =  {'lig':  'none',  'fg':  2,   'bg':  bg}
    let  s:moods.Peaceful   =  {'lig':  'none',  'fg':  6,   'bg':  bg}
    let  s:moods.Forceful   =  {'lig':  'none',  'fg':  1,   'bg':  bg}
    let  s:moods.Happy      =  {'lig':  'none',  'fg':  5,   'bg':  bg}
    let  s:moods.Busy       =  {'lig':  'none',  'fg':  3,   'bg':  bg}
    let  s:moods.Satisfied  =  {'lig':  'none',  'fg':  12,  'bg':  bg}
    let  s:moods.Relaxed    =  {'lig':  'none',  'fg':  10,  'bg':  bg}
    let  s:moods.Fresh      =  {'lig':  'none',  'fg':  14,  'bg':  bg}
    let  s:moods.Intense    =  {'lig':  'none',  'fg':  9,   'bg':  bg}
    let  s:moods.Excited    =  {'lig':  'none',  'fg':  13,  'bg':  bg}
    let  s:moods.Lively     =  {'lig':  'none',  'fg':  11,  'bg':  bg}
"" }}}

"" Highlights {{{
let    s:highlights         =   {}
if &background == 'dark'
    let    s:highlights.HPop    =   {'lig':  'none',  'fg':  15,  'bg':  8}
    let    s:highlights.HFaded  =   {'lig':  'none',  'fg':  7,   'bg':  8}
else
    let    s:highlights.HPop    =   {'lig':  'none',  'fg':  0,   'bg':  7}
    let    s:highlights.HFaded  =   {'lig':  'none',  'fg':  8,   'bg':  7}
endif
let  s:highlights.HPeaceful      =  {'lig':  'none',     'fg':  15,  'bg':  6}
let  s:highlights.HProud         =  {'lig':  'none',     'fg':  15,  'bg':  4}
let  s:highlights.HCalm          =  {'lig':  'none',     'fg':  15,  'bg':  2}
let  s:highlights.HForceful      =  {'lig':  'none',     'fg':  15,  'bg':  1}
let  s:highlights.HHappy         =  {'lig':  'none',     'fg':  15,  'bg':  5}
let  s:highlights.HBusy          =  {'lig':  'none',     'fg':  0,   'bg':  3}
let  s:highlights.HExcited       =  {'lig':  'none',     'fg':  0,   'bg':  13}
let  s:highlights.HSatisfied     =  {'lig':  'none',     'fg':  0,   'bg':  12}
let  s:highlights.HLively        =  {'lig':  'none',     'fg':  0,   'bg':  11}
let  s:highlights.HLivelyInvert  =  {'lig':  'inverse',  'fg':  0,   'bg':  11}
let  s:highlights.HRelaxed       =  {'lig':  'none',     'fg':  0,   'bg':  10}
let  s:highlights.HFresh         =  {'lig':  'none',     'fg':  0,   'bg':  14}
let  s:highlights.HIntense       =  {'lig':  'none',     'fg':  0,   'bg':  9}
"" }}}
" }}}

" Elements -> Styles {{{
let s:ui_styles = {}
let s:diff_styles = {}
let s:syntax_styles = {}

"" UI Styles {{{{
let s:ui_styles.normal                = "Normal"
let s:ui_styles.title                 = "StrongPop"
let s:ui_styles.line                  = "Underlined"
let s:ui_styles.notice                = "Forceful"
let s:ui_styles.cursor                = "Contrasted"
let s:ui_styles.selection             = "Contrasted"
let s:ui_styles.hidden                = "Hidden"
let s:ui_styles.ignore                = "Faded"
let s:ui_styles.status_inactive       = "HFaded"
let s:ui_styles.status_active         = "HPop"
let s:ui_styles.status_term           = "HRelaxed"
let s:ui_styles.match                 = "HExcited"
let s:ui_styles.highlight             = "HLively"
let s:ui_styles.highlight_inverted    = "HLivelyInvert"
""}}}

"" Diff Styles {{{{
let s:diff_styles.add                 = "Calm"
let s:diff_styles.delete              = "Forceful"
let s:diff_styles.change              = "Busy"
let s:diff_styles.text                = "HExcited"
""}}}

"" Syntax Styles {{{{
let s:syntax_styles.error             = "Intense"
let s:syntax_styles.constant          = "Peaceful"
let s:syntax_styles.identifier        = "Normal"
let s:syntax_styles.statement         = "Calm"
let s:syntax_styles.operator          = "Lively"
let s:syntax_styles.type              = "StrongPop"
let s:syntax_styles.preproc           = "Lively"
let s:syntax_styles.trivial           = "Faded"
let s:syntax_styles.informative       = "Bold"
let s:syntax_styles.special           = "Proud"
let s:syntax_styles.underlined        = "Underlined"
let s:syntax_styles.emphasis          = "Bold"
let s:syntax_styles.strong            = "Pop"
let s:syntax_styles.heavy             = "StrongPop"
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
\    "MatchParen",
\ ]
let s:ui_groups.highlight = [
\    "Search",
\    "Substitute",
\ ]
let s:ui_groups.match = [
\    "IncSearch",
\    "PmenuSel",
\    "WildMenu",
\ ]
let s:ui_groups.ignore = [
\    "FoldColum",
\    "Folded",
\    "LineNr",
\    "SignColumn",
\    "VertSplit",
\ ]
let s:ui_groups.status_active = [
\    "StatusLine",
\ ]
let s:ui_groups.status_inactive = [
\    "ColorColumn",
\    "CursorColumn",
\    "StatusLineNC",
\    "StatusLineTermNC",
\ ]
let s:ui_groups.line = [
\    "TabLine",
\    "TabLineFill",
\ ]
let s:ui_groups.title = [
\    "TabLineSel",
\ ]
let s:ui_groups.status_term = [
\    "StatusLineTerm",
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
\ ]
let s:syntax_groups.constant = [
\    "Constant",
\    "Number",
\    "String",
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
\ ]
let s:syntax_groups.trivial = [
\    "Ignore",
\    "Conceal",
\    "Noise",
\    "LspDiagnosticsError",
\    "LspDiagnosticsHint",
\    "LspDiagnosticsInformation",
\    "LspDiagnosticsWarning",
\ ]
let s:syntax_groups.special = [
\    "Delimiter",
\    "Special",
\    "SpecialKey",
\    "SpellCap",
\    "SpellLocal",
\    "SpellRare",
\    "Title",
\    "Todo",
\    "netrwSymLink",
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
"}}}

" vim: foldmethod=marker
