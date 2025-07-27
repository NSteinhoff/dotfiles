" --- Intro
highlight clear
if exists("syntax_on")
    syntax reset
endif
set t_Co=16
set bg=dark
let g:colors_name="ludite"

" --- Colors
highlight Normal            cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight NormalNc          cterm=NONE              ctermfg=NONE        ctermbg=NONE

"{{{ Cursor
highlight Cursor            cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight lCursor           cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight CursorIM          cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight TermCursor        cterm=inverse           ctermfg=NONE        ctermbg=NONE
highlight Visual            cterm=NONE              ctermfg=Black       ctermbg=DarkGreen
"}}}
"{{{ Basic UI Elements
highlight Directory         cterm=NONE              ctermfg=DarkCyan    ctermbg=NONE
highlight EndOfBuffer       cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight ErrorMsg          cterm=NONE              ctermfg=DarkBlue    ctermbg=NONE
highlight WarningMsg        cterm=NONE              ctermfg=DarkBlue    ctermbg=NONE
highlight MoreMsg           cterm=NONE              ctermfg=LightRed    ctermbg=NONE
highlight Folded            cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight LineNr            cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight Menu              cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Noise             cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight NonText           cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight Pmenu             cterm=NONE              ctermfg=NONE        ctermbg=Black
highlight PmenuSbar         cterm=NONE              ctermfg=NONE        ctermbg=White
highlight PmenuSel          cterm=NONE              ctermfg=Black       ctermbg=DarkYellow
highlight PmenuThumb        cterm=NONE              ctermfg=NONE        ctermbg=LightCyan
highlight Question          cterm=italic            ctermfg=LightGray   ctermbg=NONE
highlight Scrollbar         cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight SpecialKey        cterm=bold              ctermfg=LightRed    ctermbg=NONE
highlight Title             cterm=NONE              ctermfg=LightRed    ctermbg=NONE
highlight Tooltip           cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight WildMenu          cterm=NONE              ctermfg=NONE        ctermbg=DarkMagenta
"}}}
"{{{ UI Columns and Lines
highlight ColorColumn       cterm=NONE              ctermfg=NONE        ctermbg=DarkGray
highlight CursorColumn      cterm=NONE              ctermfg=Black       ctermbg=LightCyan
highlight CursorLine        cterm=NONE              ctermfg=Black       ctermbg=LightCyan
highlight CursorLineNr      cterm=NONE              ctermfg=NONE        ctermbg=NONE

highlight FoldColumn        cterm=bold              ctermfg=White       ctermbg=NONE
highlight SignColumn        cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
highlight VertSplit         cterm=NONE              ctermfg=DarkGray    ctermbg=NONE
"}}}
"{{{ Spelling
highlight SpellBad          cterm=underline         ctermfg=DarkBlue    ctermbg=NONE
highlight SpellCap          cterm=underline         ctermfg=LightRed    ctermbg=NONE
highlight SpellLocal        cterm=underline         ctermfg=LightRed    ctermbg=NONE
highlight SpellRare         cterm=underline         ctermfg=LightRed    ctermbg=NONE
"}}}
"{{{ Diff
highlight Added             cterm=NONE              ctermfg=DarkGreen   ctermbg=NONE
highlight Changed           cterm=NONE              ctermfg=DarkCyan    ctermbg=NONE
highlight Removed           cterm=NONE              ctermfg=DarkBlue    ctermbg=NONE

highlight DiffAdd           cterm=NONE              ctermfg=DarkGreen   ctermbg=NONE
highlight DiffChange        cterm=NONE              ctermfg=DarkCyan    ctermbg=NONE
highlight DiffDelete        cterm=NONE              ctermfg=DarkBlue    ctermbg=NONE
highlight DiffText          cterm=NONE              ctermfg=DarkMagenta ctermbg=NONE
"}}}
"{{{ Status line
highlight StatusLine        cterm=NONE              ctermfg=Black       ctermbg=DarkBlue
highlight StatusLineNC      cterm=NONE              ctermfg=NONE        ctermbg=DarkGray
highlight StatusLineFocus   cterm=NONE              ctermfg=NONE        ctermbg=White
highlight StatusLineTerm    cterm=NONE              ctermfg=NONE        ctermbg=LightMagenta
highlight StatusLineTermNC  cterm=NONE              ctermfg=NONE        ctermbg=DarkGray
"}}}
"{{{ Tab line
highlight TabLine           cterm=underline         ctermfg=NONE        ctermbg=NONE
highlight TabLineDirectory  cterm=underline         ctermfg=LightRed    ctermbg=NONE
highlight TabLineContext    cterm=bold,underline    ctermfg=DarkGreen   ctermbg=NONE
highlight TabLineFill       cterm=underline         ctermfg=DarkGray    ctermbg=NONE
highlight TabLineFocus      cterm=underline         ctermfg=DarkCyan    ctermbg=NONE
highlight TabLineNotice     cterm=underline         ctermfg=DarkBlue    ctermbg=NONE
highlight TabLineSel        cterm=bold,underline    ctermfg=White       ctermbg=NONE
"}}}
"{{{ Searching/Matches
highlight Search            cterm=bold,underline    ctermfg=NONE        ctermbg=NONE
highlight IncSearch         cterm=NONE              ctermfg=NONE        ctermbg=DarkMagenta
highlight CurSearch         cterm=NONE              ctermfg=NONE        ctermbg=DarkMagenta
highlight MatchParen        cterm=NONE              ctermfg=LightRed    ctermbg=NONE
"}}}
"{{{ Floating Window
highlight NormalFloat       cterm=NONE              ctermfg=NONE        ctermbg=DarkGray
highlight FloatBorder       cterm=NONE              ctermfg=White       ctermbg=DarkRed
highlight FloatTitle        cterm=NONE              ctermfg=White       ctermbg=DarkRed
highlight FloatFooter       cterm=NONE              ctermfg=White       ctermbg=DarkRed
"}}}
"{{{ Syntax
highlight Comment           cterm=NONE              ctermfg=DarkYellow  ctermbg=NONE
highlight Constant          cterm=NONE              ctermfg=White       ctermbg=NONE
highlight Define            cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Delimiter         cterm=NONE              ctermfg=DarkGreen   ctermbg=NONE
highlight Error             cterm=bold              ctermfg=DarkBlue    ctermbg=NONE
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
highlight SpecialComment    cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight Statement         cterm=NONE              ctermfg=NONE        ctermbg=NONE
highlight String            cterm=NONE              ctermfg=White       ctermbg=NONE
highlight Todo              cterm=bold              ctermfg=NONE        ctermbg=DarkGray
highlight Type              cterm=bold              ctermfg=NONE        ctermbg=NONE
highlight Underlined        cterm=underline         ctermfg=NONE        ctermbg=NONE
"}}}
" --- Neovim specific stuff
"{{{ Win bar
highlight WinBar            cterm=NONE              ctermfg=Black       ctermbg=DarkRed
highlight WinBarNC          cterm=NONE              ctermfg=DarkRed     ctermbg=DarkGray
"}}}
"{{{ Links
highlight link LspSignatureActiveParameter      Search
highlight link DiagnosticFloatingError          Normal
highlight link DiagnosticFloatingWarn           Normal
highlight link DiagnosticFloatingInfo           Normal
highlight link DiagnosticFloatingHint           Normal
"}}}

" --- Outro
syntax enable

" vim: foldmethod=marker
