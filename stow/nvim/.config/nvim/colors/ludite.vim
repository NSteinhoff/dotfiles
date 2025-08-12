" --- Intro
highlight clear
if exists("syntax_on")
    syntax reset
endif
set t_Co=16
set bg=dark
let g:colors_name="ludite"

" TODO: testing
"   SHADES
"   0 - base00 - Default Background
"   1 - base01 - Lighter Background (Used for status bars, line number and folding marks)
"   2 - base02 - Selection Background
"   3 - base03 - Comments, Invisibles, Line Highlighting
"   4 - base04 - Dark Foreground (Used for status bars)
"   5 - base05 - Default Foreground, Caret, Delimiters, Operators
"   6 - base06 - Light Foreground (Not often used)
"   7 - base07 - Light Background (Not often used)
"  ACCENTS:
"   8 - base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
"   9 - base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
"  10 - base0A - Classes, Markup Bold, Search Text Background
"  11 - base0B - Strings, Inherited Class, Markup Code, Diff Inserted
"  12 - base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
"  13 - base0D - Functions, Methods, Attribute IDs, Headings
"  14 - base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
"  15 - base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
"

" --- Colors
highlight Normal            cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight NormalNc          cterm=NONE              ctermfg=NONE        ctermbg=NONE

"{{{ Cursor
highlight Cursor            cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight lCursor           cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight CursorIM          cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight TermCursor        cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight Visual            cterm=NONE              ctermfg=Black       ctermbg=DarkBlue
"}}}
"{{{ Basic UI Elements
highlight Directory         cterm=NONE              ctermfg=DarkBlue    ctermbg=NONE
highlight EndOfBuffer       cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight ErrorMsg          cterm=NONE              ctermfg=DarkRed     ctermbg=NONE
highlight WarningMsg        cterm=NONE              ctermfg=LightRed    ctermbg=NONE
highlight MoreMsg           cterm=NONE              ctermfg=DarkBlue    ctermbg=NONE
highlight Folded            cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight LineNr            cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight Menu              cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Noise             cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight NonText           cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight Pmenu             cterm=NONE              ctermfg=NONE        ctermbg=DarkGray
highlight PmenuSbar         cterm=NONE              ctermfg=Black       ctermbg=LightGray
highlight PmenuSel          cterm=NONE              ctermfg=Black       ctermbg=DarkGreen
highlight PmenuThumb        cterm=NONE              ctermfg=Black       ctermbg=DarkGreen
highlight Question          cterm=italic            ctermfg=LightGray   ctermbg=NONE
highlight Scrollbar         cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight SpecialKey        cterm=bold              ctermfg=LightRed    ctermbg=NONE
highlight Title             cterm=bold              ctermfg=White       ctermbg=NONE
highlight Tooltip           cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight WildMenu          cterm=NONE              ctermfg=NONE        ctermbg=DarkGreen
"}}}
"{{{ UI Columns and Lines
highlight ColorColumn       cterm=NONE              ctermfg=NONE        ctermbg=DarkGray
highlight CursorColumn      cterm=NONE              ctermfg=Black       ctermbg=DarkBlue
highlight CursorLine        cterm=NONE              ctermfg=Black       ctermbg=DarkBlue
highlight CursorLineNr      cterm=NONE              ctermfg=NONE        ctermbg=NONE

highlight FoldColumn        cterm=bold              ctermfg=White       ctermbg=NONE
highlight SignColumn        cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight VertSplit         cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight QuickFixLine      cterm=underline,bold    ctermfg=NONE        ctermbg=NONE
"}}}
"{{{ Spelling
highlight SpellBad          cterm=underline         ctermfg=DarkRed     ctermbg=NONE
highlight SpellCap          cterm=underline         ctermfg=LightRed    ctermbg=NONE
highlight SpellLocal        cterm=underline         ctermfg=LightRed    ctermbg=NONE
highlight SpellRare         cterm=underline         ctermfg=LightRed    ctermbg=NONE
"}}}
"{{{ Diff
highlight Added             cterm=NONE              ctermfg=DarkGreen   ctermbg=NONE
highlight Changed           cterm=NONE              ctermfg=DarkYellow  ctermbg=NONE
highlight Removed           cterm=NONE              ctermfg=DarkRed     ctermbg=NONE

highlight DiffAdd           cterm=NONE              ctermfg=DarkGreen   ctermbg=NONE
highlight DiffChange        cterm=NONE              ctermfg=DarkYellow  ctermbg=NONE
highlight DiffDelete        cterm=NONE              ctermfg=DarkRed     ctermbg=NONE
highlight DiffText          cterm=NONE              ctermfg=DarkMagenta ctermbg=NONE
"}}}
"{{{ Status line
highlight StatusLine        cterm=NONE              ctermfg=Black       ctermbg=DarkBlue
highlight StatusLineNC      cterm=NONE              ctermfg=None        ctermbg=DarkGray
highlight StatusLineFocus   cterm=NONE              ctermfg=NONE        ctermbg=White
highlight StatusLineTerm    cterm=NONE              ctermfg=Black       ctermbg=DarkGreen
highlight StatusLineTermNC  cterm=NONE              ctermfg=DarkGreen   ctermbg=DarkGray
"}}}
"{{{ Tab line
highlight TabLine           cterm=underline         ctermfg=NONE        ctermbg=NONE
highlight TabLineDirectory  cterm=underline         ctermfg=LightRed    ctermbg=NONE
highlight TabLineContext    cterm=bold,underline    ctermfg=DarkGreen   ctermbg=NONE
highlight TabLineFill       cterm=underline         ctermfg=DarkGray    ctermbg=NONE
highlight TabLineFocus      cterm=underline         ctermfg=DarkBlue    ctermbg=NONE
highlight TabLineNotice     cterm=underline         ctermfg=LightBlue   ctermbg=NONE
highlight TabLineSel        cterm=bold,underline    ctermfg=White       ctermbg=NONE
"}}}
"{{{ Searching/Matches
highlight Search            cterm=bold,underline    ctermfg=NONE        ctermbg=NONE
highlight IncSearch         cterm=NONE              ctermfg=NONE        ctermbg=DarkGreen
highlight CurSearch         cterm=NONE              ctermfg=NONE        ctermbg=DarkGreen
highlight MatchParen        cterm=NONE              ctermfg=LightRed    ctermbg=NONE
"}}}
"{{{ Floating Window
highlight NormalFloat       cterm=NONE              ctermfg=NONE        ctermbg=DarkGray
highlight FloatBorder       cterm=NONE              ctermfg=White       ctermbg=DarkBlue
highlight FloatTitle        cterm=NONE              ctermfg=White       ctermbg=DarkBlue
highlight FloatFooter       cterm=NONE              ctermfg=White       ctermbg=DarkBlue
"}}}
"{{{ Syntax
highlight Comment           cterm=NONE              ctermfg=DarkBlue    ctermbg=NONE
highlight Constant          cterm=NONE              ctermfg=White       ctermbg=NONE
highlight Define            cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Delimiter         cterm=NONE              ctermfg=LightBlue   ctermbg=NONE
highlight Error             cterm=bold              ctermfg=DarkRed     ctermbg=NONE
highlight Exception         cterm=bold              ctermfg=White       ctermbg=NONE
highlight Function          cterm=bold              ctermfg=NONE        ctermbg=NONE
highlight Identifier        cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Conceal           cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight Ignore            cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight Keyword           cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Macro             cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Number            cterm=NONE              ctermfg=White       ctermbg=NONE
highlight Operator          cterm=bold              ctermfg=White       ctermbg=NONE
highlight PreProc           cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Special           cterm=bold              ctermfg=NONE        ctermbg=NONE
highlight SpecialChar       cterm=bold              ctermfg=NONE        ctermbg=NONE
highlight SpecialComment    cterm=bold              ctermfg=NONE        ctermbg=NONE
highlight Statement         cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight String            cterm=NONE              ctermfg=White       ctermbg=NONE
highlight CommentNote       cterm=bold              ctermfg=Black       ctermbg=DarkBlue
highlight Todo              cterm=bold              ctermfg=Black       ctermbg=LightMagenta
highlight Type              cterm=bold              ctermfg=NONE        ctermbg=NONE
highlight Underlined        cterm=underline         ctermfg=NONE        ctermbg=NONE
"}}}
" --- Neovim specific stuff
"{{{ Win bar
highlight WinBar            cterm=NONE              ctermfg=Black       ctermbg=DarkMagenta
highlight WinBarNC          cterm=NONE              ctermfg=DarkMagenta ctermbg=DarkGray
"}}}
"{{{ Links
highlight! link LspSignatureActiveParameter      Search
highlight! link DiagnosticInfo                   CommentNote
highlight! link DiagnosticWarn                   WarningMsg
highlight! link DiagnosticError                  ErrorMsg
highlight! link DiagnosticFloatingError          Normal
highlight! link DiagnosticFloatingWarn           Normal
highlight! link DiagnosticFloatingInfo           Normal
highlight! link DiagnosticFloatingHint           Normal
"}}}

" --- Outro
syntax enable

" vim: foldmethod=marker
