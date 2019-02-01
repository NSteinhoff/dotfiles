" Helper functions {{{

" Activate the colorscheme
function! s:ApplyTheme(groups, dark, light)
  if &background == "dark"
    call s:HighlightGroups(a:groups, a:dark)
  else
    " No light theme! ¯\_(ツ)_/¯
    call s:HighlightGroups(a:groups, a:dark)
  endif
endfunction

" Highligh all items in a group with the configured style
function! s:HighlightGroups(groups, styles)
  for [l:group, l:style] in items(a:styles)
    let l:items = a:groups[l:group]
    call s:HighlightItems(l:items, l:style)
  endfor
endfunction

" Highlight items as a certain style by linking
function! s:HighlightItems(items, style)
  for l:item in a:items
    exec "highlight! link " . l:item . " " . a:style
  endfor
endfunction

" Create styles that can be used to link groups to
function! s:SetStyles(styles)
  for [name, options] in items(a:styles)
    call s:ApplyStyle(name, options)
  endfor
endfunction

" Apply a syntax highlight style based on a dicationary of options.
function! s:ApplyStyle(name, options)
  let n = a:name
  let lig = s:get_or_else(a:options, 'lig', 'none')
  let fg = s:get_or_else(a:options, 'fg', 'none')
  let bg = s:get_or_else(a:options, 'bg', 'none')
  exec "highlight " . n . " cterm=" . lig . " ctermfg=" . fg . " ctermbg=" . bg
endfunction

" Get key from dictionary or fall back to default.
function! s:get_or_else(dict, key, default)
  if has_key(a:dict, a:key)
    return a:dict[a:key]
  else
    return a:default
  endif
endfunction
" }}}

" Styles {{{
"" Hues {{{
let  s:hues             = {}
let  s:hues.nothing     = {'lig': 'none',           'fg': 'none',     'bg': 'none'}
let  s:hues.Underlined  = {'lig': 'underline',      'fg': 'none',     'bg': 'none'}
let  s:hues.Contrasted  = {'lig': 'inverse',        'fg': 'none',     'bg': 'none'}
let  s:hues.Faded       = {'lig': 'none',           'fg': 'DarkGrey', 'bg': 'none'}
let  s:hues.Hidden      = {'lig': 'none',           'fg': 'bg',       'bg': 'bg'}
let  s:hues.Bold        = {'lig': 'bold',           'fg': 'fg',       'bg': 'none'}
let  s:hues.Italic      = {'lig': 'bold',           'fg': 'fg',       'bg': 'none'}
let  s:hues.Pop         = {'lig': 'none',           'fg': 'White',    'bg': 'none'}
let  s:hues.StrongPop   = {'lig': 'bold,underline', 'fg': 'White',    'bg': 'none'}
"" }}}

"" Moods {{{
let  s:moods            = {}
let  s:moods.Proud      = {'lig': 'none',  'fg': 'DarkBlue',     'bg': 'none'}
let  s:moods.Calm       = {'lig': 'none',  'fg': 'DarkGreen',    'bg': 'none'}
let  s:moods.Peaceful   = {'lig': 'none',  'fg': 'DarkCyan',     'bg': 'none'}
let  s:moods.Forceful   = {'lig': 'none',  'fg': 'DarkRed',      'bg': 'none'}
let  s:moods.Happy      = {'lig': 'none',  'fg': 'DarkMagenta',  'bg': 'none'}
let  s:moods.Busy       = {'lig': 'none',  'fg': 'DarkYellow',   'bg': 'none'}
let  s:moods.Satisfied  = {'lig': 'none',  'fg': 'Blue',         'bg': 'none'}
let  s:moods.Relaxed    = {'lig': 'none',  'fg': 'Green',        'bg': 'none'}
let  s:moods.Fresh      = {'lig': 'none',  'fg': 'Cyan',         'bg': 'none'}
let  s:moods.Intense    = {'lig': 'none',  'fg': 'Red',          'bg': 'none'}
let  s:moods.Excited    = {'lig': 'none',  'fg': 'Magenta',      'bg': 'none'}
let  s:moods.Lively     = {'lig': 'none',  'fg': 'Yellow',       'bg': 'none'}
"" }}}

"" Highlights {{{
let  s:highlights                     = {}
let  s:highlights.HFaded              = {'lig': 'none',  'fg': 'Grey',   'bg': 'DarkGrey'}
let  s:highlights.HPeaceful           = {'lig': 'none',  'fg': 'White',  'bg': 'DarkCyan'}
let  s:highlights.HProud              = {'lig': 'none',  'fg': 'White',  'bg': 'DarkBlue'}
let  s:highlights.HCalm               = {'lig': 'none',  'fg': 'White',  'bg': 'DarkGreen'}
let  s:highlights.HForceful           = {'lig': 'none',  'fg': 'White',  'bg': 'DarkRed'}
let  s:highlights.HHappy              = {'lig': 'none',  'fg': 'White',  'bg': 'DarkMagenta'}
let  s:highlights.HBusy               = {'lig': 'none',  'fg': 'Black',  'bg': 'DarkYellow'}
let  s:highlights.HExcited            = {'lig': 'none',  'fg': 'Black',  'bg': 'Magenta'}
let  s:highlights.HSatisfied          = {'lig': 'none',  'fg': 'Black',  'bg': 'Blue'}
let  s:highlights.HLively             = {'lig': 'none',  'fg': 'Black',  'bg': 'Yellow'}
let  s:highlights.HLivelyInvert       = {'lig': 'inverse',  'fg': 'Black',  'bg': 'Yellow'}
let  s:highlights.HRelaxed            = {'lig': 'none',  'fg': 'Black',  'bg': 'Green'}
let  s:highlights.HFresh              = {'lig': 'none',  'fg': 'Black',  'bg': 'Cyan'}
let  s:highlights.HIntense            = {'lig': 'none',  'fg': 'Black',  'bg': 'Red'}
"" }}}
" }}}

" Element Styles {{{
let s:ui_styles = {}
let s:diff_styles = {}
let s:syntax_styles = {}

"" UI Styles {{{{
let  s:ui_styles.normal               = "Normal"
let  s:ui_styles.title                = "StrongPop"
let  s:ui_styles.line                 = "Underlined"
let  s:ui_styles.notice               = "Forceful"
let  s:ui_styles.cursor               = "Contrasted"
let  s:ui_styles.selection            = "Contrasted"
let  s:ui_styles.hidden               = "Hidden"
let  s:ui_styles.ignore               = "Faded"
let  s:ui_styles.status_inactive      = "HFaded"
let  s:ui_styles.status_active        = "HFresh"
let  s:ui_styles.status_term          = "HRelaxed"
let  s:ui_styles.match                = "HExcited"
let  s:ui_styles.highlight            = "HLively"
let  s:ui_styles.highlight_inverted   = "HLivelyInvert"
""}}}

"" Diff Styles {{{{
let  s:diff_styles.add     = "Calm"
let  s:diff_styles.delete  = "Forceful"
let  s:diff_styles.change  = "Busy"
let  s:diff_styles.text    = "HExcited"
""}}}

"" Syntax Styles {{{{
let  s:syntax_styles.error       = "Forceful"
let  s:syntax_styles.constant    = "Proud"
let  s:syntax_styles.identifier  = "Normal"
let  s:syntax_styles.statement   = "Pop"
let  s:syntax_styles.operator    = "Pop"
let  s:syntax_styles.type        = "Peaceful"
let  s:syntax_styles.global      = "Calm"
let  s:syntax_styles.trivial     = "Faded"
let  s:syntax_styles.special     = "Happy"
let  s:syntax_styles.emphasis    = "Bold"
let  s:syntax_styles.strong      = "Pop"
let  s:syntax_styles.heavy       = "StrongPop"
""}}}
"}}}

" Element Groups {{{
let s:ui_groups = {}
let s:diff_groups = {}
let s:syntax_groups = {}

"" UI {{{
let s:ui_groups.normal = [
\ "NormalNc",
\ "CursorLineNr",
\ "Menu",
\ "PmenuThumb",
\ "Scrollbar",
\ "Tooltip",
\ ]
let s:ui_groups.notice = [
\ "NonText",
\ ]
let s:ui_groups.cursor = [
\ "Cursor",
\ "CursorIM",
\ "TermCursor",
\ "TermCursorNC",
\ ]
let s:ui_groups.hidden = [
\ "EndOfBuffer",
\ ]
let s:ui_groups.selection = [
\ "Visual",
\ "Pmenu",
\ "PmenuSbar",
\ ]
let s:ui_groups.highlight_inverted = [
\ "MatchParen",
\ ]
let s:ui_groups.highlight = [
\ "Search",
\ "Substitute",
\ ]
let s:ui_groups.match = [
\ "IncSearch",
\ "PmenuSel",
\ "WildMenu",
\ ]
let s:ui_groups.ignore = [
\ "FoldColum",
\ "Folded",
\ "LineNr",
\ "SignColumn",
\ "VertSplit",
\ ]
let s:ui_groups.status_active = [
\ "StatusLine",
\ ]
let s:ui_groups.status_inactive = [
\ "ColorColumn",
\ "CursorColumn",
\ "StatusLineNC",
\ "StatusLineTermNC",
\ ]
let s:ui_groups.line = [
\ "CursorLine",
\ "TabLine",
\ "TabLineFill",
\ ]
let s:ui_groups.title = [
\ "TabLineSel",
\ ]
let s:ui_groups.status_term = [
\ "StatusLineTerm",
\ ]
""}}}

"" Diff {{{
let s:diff_groups.add = [
\ "DiffAdd",
\ ]
let s:diff_groups.change = [
\ "DiffChange",
\ ]
let s:diff_groups.delete = [
\ "DiffDelete",
\ ]
let s:diff_groups.text = [
\ "DiffText",
\ ]
""}}}

"" Syntax {{{
let s:syntax_groups.error = [
\ "Error",
\ "ErrorMsg",
\ "SpellBad",
\ "NvimInternalError",
\ ]
let s:syntax_groups.constant = [
\ "Constant",
\ "Number",
\ "String",
\ "Directory",
\ "markdownCode",
\ "markdownCodeBlock",
\ ]
let s:syntax_groups.identifier = [
\ "Identifier",
\ ]
let s:syntax_groups.statement = [
\ "Statement",
\ ]
let s:syntax_groups.operator = [
\ "Operator",
\ "Function",
\ ]
let s:syntax_groups.type = [
\ "Type",
\ ]
let s:syntax_groups.global = [
\ "PreProc",
\ "Keyword",
\ ]
let s:syntax_groups.trivial = [
\ "Comment",
\ "Ignore",
\ "Conceal",
\ "Noise",
\ ]
let s:syntax_groups.special = [
\ "Special",
\ "SpecialKey",
\ "SpellCap",
\ "SpellLocal",
\ "SpellRare",
\ "Title",
\ "Todo",
\ "netrwSymLink",
\ ]
let s:syntax_groups.emphasis = [
\ "Underlined",
\ "markdownItalic",
\ "mkdItalic",
\ "mkdLineBreak",
\ "htmlItalic",
\ "htmlUnderlineItalic",
\ ]
let s:syntax_groups.strong = [
\ "markdownBold",
\ "markdownBoldItalic",
\ "mkdBold",
\ "mkdBoldItalic",
\ "htmlBold",
\ "htmlBoldItalic",
\ ]
let s:syntax_groups.heavy = [
\ "htmlUnderlineBold",
\ "htmlBoldUnderlineItalic",
\ ]
""}}}
"}}}

" Theme Activation {{{
highlight clear
syntax reset
set t_Co=16

let g:colors_name="minimal"

highlight Normal cterm=none ctermfg=Grey ctermbg=Black

call s:SetStyles(s:hues)
call s:SetStyles(s:moods)
call s:SetStyles(s:highlights)

call s:ApplyTheme(s:ui_groups, s:ui_styles, '')
call s:ApplyTheme(s:diff_groups, s:diff_styles, '')
call s:ApplyTheme(s:syntax_groups, s:syntax_styles, '')

syntax enable
"}}}

" vim: fdm=marker:sw=2:sts=2:et
