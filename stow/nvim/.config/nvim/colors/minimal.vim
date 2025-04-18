" --- Intro
highlight clear
if exists("syntax_on")
    syntax reset
endif
set t_Co=16
set bg=dark
let g:colors_name="minimal"

" --- Colors
"{{{ Cursor
highlight Cursor                       cterm=inverse                ctermfg=NONE  ctermbg=NONE
highlight lCursor                      cterm=inverse                ctermfg=NONE  ctermbg=NONE
highlight CursorIM                     cterm=inverse                ctermfg=NONE  ctermbg=NONE
highlight TermCursor                   cterm=inverse                ctermfg=NONE  ctermbg=NONE
highlight Visual                       cterm=NONE                   ctermfg=0     ctermbg=2
"}}}
"{{{ Basic UI Elements
highlight Directory                    cterm=NONE                   ctermfg=3     ctermbg=NONE
highlight EndOfBuffer                  cterm=NONE                   ctermfg=8     ctermbg=NONE
highlight ErrorMsg                     cterm=NONE                   ctermfg=1     ctermbg=NONE
highlight WarningMsg                   cterm=NONE                   ctermfg=1     ctermbg=NONE
highlight MoreMsg                      cterm=NONE                   ctermfg=12    ctermbg=NONE
highlight Folded                       cterm=NONE                   ctermfg=8     ctermbg=NONE
highlight LineNr                       cterm=NONE                   ctermfg=8     ctermbg=NONE
highlight Menu                         cterm=NONE                   ctermfg=NONE  ctermbg=NONE
highlight Noise                        cterm=NONE                   ctermfg=8     ctermbg=NONE
highlight NonText                      cterm=NONE                   ctermfg=8     ctermbg=NONE
highlight NormalNc                     cterm=NONE                   ctermfg=NONE  ctermbg=NONE
highlight Pmenu                        cterm=NONE                   ctermfg=NONE  ctermbg=0
highlight PmenuSbar                    cterm=NONE                   ctermfg=NONE  ctermbg=15
highlight PmenuSel                     cterm=NONE                   ctermfg=0     ctermbg=6
highlight PmenuThumb                   cterm=NONE                   ctermfg=NONE  ctermbg=11
highlight Question                     cterm=italic                 ctermfg=7     ctermbg=NONE
highlight Scrollbar                    cterm=NONE                   ctermfg=NONE  ctermbg=NONE
highlight SpecialKey                   cterm=bold                   ctermfg=12    ctermbg=NONE
highlight Title                        cterm=NONE                   ctermfg=12    ctermbg=NONE
highlight Tooltip                      cterm=NONE                   ctermfg=NONE  ctermbg=NONE
highlight WildMenu                     cterm=NONE                   ctermfg=NONE  ctermbg=5
"}}}
"{{{ UI Columns and Lines
highlight ColorColumn                  cterm=NONE                   ctermfg=NONE  ctermbg=8
highlight CursorColumn                 cterm=NONE                   ctermfg=0     ctermbg=11
highlight CursorLine                   cterm=NONE                   ctermfg=0     ctermbg=11
highlight CursorLineNr                 cterm=NONE                   ctermfg=NONE  ctermbg=NONE

highlight FoldColumn                   cterm=bold                   ctermfg=15    ctermbg=NONE
highlight SignColumn                   cterm=NONE                   ctermfg=8     ctermbg=NONE
highlight VertSplit                    cterm=NONE                   ctermfg=8     ctermbg=NONE
"}}}
"{{{ Spelling
highlight SpellBad                     cterm=underline              ctermfg=1     ctermbg=NONE
highlight SpellCap                     cterm=underline              ctermfg=12    ctermbg=NONE
highlight SpellLocal                   cterm=underline              ctermfg=12    ctermbg=NONE
highlight SpellRare                    cterm=underline              ctermfg=12    ctermbg=NONE
"}}}
"{{{ Diff
highlight Added                        cterm=NONE                   ctermfg=2     ctermbg=NONE
highlight Changed                      cterm=NONE                   ctermfg=3     ctermbg=NONE
highlight Removed                      cterm=NONE                   ctermfg=1     ctermbg=NONE

highlight DiffAdd                      cterm=NONE                   ctermfg=2     ctermbg=NONE
highlight DiffChange                   cterm=NONE                   ctermfg=3     ctermbg=NONE
highlight DiffDelete                   cterm=NONE                   ctermfg=1     ctermbg=NONE
highlight DiffText                     cterm=NONE                   ctermfg=5     ctermbg=NONE
"}}}
"{{{ Status line
highlight StatusLine                   cterm=NONE                   ctermfg=0     ctermbg=4
highlight StatusLineNC                 cterm=NONE                   ctermfg=NONE  ctermbg=8
highlight StatusLineFocus              cterm=NONE                   ctermfg=NONE  ctermbg=15
highlight StatusLineTerm               cterm=NONE                   ctermfg=NONE  ctermbg=13
highlight StatusLineTermNC             cterm=NONE                   ctermfg=NONE  ctermbg=8
"}}}
"{{{ Tab line
highlight TabLine                      cterm=underline              ctermfg=NONE  ctermbg=NONE
highlight TabLineDirectory             cterm=underline              ctermfg=12    ctermbg=NONE
highlight TabLineContext               cterm=bold,underline         ctermfg=2     ctermbg=NONE
highlight TabLineFill                  cterm=underline              ctermfg=8     ctermbg=NONE
highlight TabLineFocus                 cterm=underline              ctermfg=3     ctermbg=NONE
highlight TabLineNotice                cterm=underline              ctermfg=1     ctermbg=NONE
highlight TabLineSel                   cterm=bold,underline         ctermfg=15    ctermbg=NONE
"}}}
"{{{ Searching/Matches
highlight Search                       cterm=bold,underline         ctermfg=NONE  ctermbg=NONE
highlight IncSearch                    cterm=NONE                   ctermfg=NONE  ctermbg=5
highlight CurSearch                    cterm=NONE                   ctermfg=NONE  ctermbg=5
highlight MatchParen                   cterm=NONE                   ctermfg=12    ctermbg=NONE
"}}}
"{{{ Floating Window
highlight NormalFloat                  cterm=NONE                   ctermfg=NONE  ctermbg=8
highlight FloatBorder                  cterm=NONE                   ctermfg=15    ctermbg=4
highlight FloatTitle                   cterm=NONE                   ctermfg=15    ctermbg=4
highlight FloatFooter                  cterm=NONE                   ctermfg=15    ctermbg=4
"}}}
"{{{ Syntax
highlight Comment                      cterm=NONE                   ctermfg=6     ctermbg=NONE
highlight Constant                     cterm=NONE                   ctermfg=3     ctermbg=NONE
highlight Define                       cterm=NONE                   ctermfg=15    ctermbg=NONE
highlight Delimiter                    cterm=bold                   ctermfg=12    ctermbg=NONE
highlight Error                        cterm=NONE                   ctermfg=1     ctermbg=NONE
highlight Exception                    cterm=bold                   ctermfg=15    ctermbg=NONE
highlight Function                     cterm=bold                   ctermfg=NONE  ctermbg=NONE
highlight Identifier                   cterm=NONE                   ctermfg=NONE  ctermbg=NONE
highlight Conceal                      cterm=NONE                   ctermfg=8     ctermbg=NONE
highlight Ignore                       cterm=NONE                   ctermfg=0     ctermbg=NONE
highlight Keyword                      cterm=NONE                   ctermfg=15    ctermbg=NONE
highlight Macro                        cterm=NONE                   ctermfg=15    ctermbg=NONE
highlight Number                       cterm=NONE                   ctermfg=3     ctermbg=NONE
highlight Operator                     cterm=bold                   ctermfg=15    ctermbg=NONE
highlight PreProc                      cterm=NONE                   ctermfg=13    ctermbg=NONE
highlight Special                      cterm=NONE                   ctermfg=6     ctermbg=NONE
highlight SpecialChar                  cterm=bold                   ctermfg=6     ctermbg=NONE
highlight SpecialComment               cterm=NONE                   ctermfg=6     ctermbg=NONE
highlight Statement                    cterm=NONE                   ctermfg=15    ctermbg=NONE
highlight String                       cterm=NONE                   ctermfg=3     ctermbg=NONE
highlight Todo                         cterm=bold                   ctermfg=2     ctermbg=8
highlight Type                         cterm=NONE                   ctermfg=6     ctermbg=NONE
highlight Underlined                   cterm=underline              ctermfg=NONE  ctermbg=NONE
"}}}
" --- Neovim specific stuff
"{{{ Win bar
highlight WinBar                       cterm=NONE                   ctermfg=0     ctermbg=4
highlight WinBarNC                     cterm=NONE                   ctermfg=4     ctermbg=8
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
