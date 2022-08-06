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
highlight Cursor                       cterm=inverse                ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight lCursor                      cterm=inverse                ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight CursorIM                     cterm=inverse                ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight TermCursor                   cterm=inverse                ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight TermCursorNC                 cterm=inverse                ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight Visual                       cterm=NONE                   ctermfg=0     ctermbg=2     guifg=Black         guibg=Green
"}}}

"{{{ Basic UI Elements
highlight Directory                    cterm=NONE                   ctermfg=3     ctermbg=NONE  guifg=Cyan          guibg=NONE
highlight EndOfBuffer                  cterm=NONE                   ctermfg=0     ctermbg=NONE  guifg=Black         guibg=NONE
highlight ErrorMsg                     cterm=NONE                   ctermfg=1     ctermbg=NONE  guifg=Blue          guibg=NONE
highlight Folded                       cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight LineNr                       cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight Menu                         cterm=NONE                   ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight Noise                        cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight NonText                      cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight NormalNc                     cterm=NONE                   ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight Pmenu                        cterm=NONE                   ctermfg=15    ctermbg=8     guifg=NONE          guibg=DarkGray
highlight PmenuSbar                    cterm=NONE                   ctermfg=NONE  ctermbg=15    guifg=NONE          guibg=DarkGray
highlight PmenuSel                     cterm=NONE                   ctermfg=NONE  ctermbg=5     guifg=NONE          guibg=Magenta
highlight PmenuThumb                   cterm=NONE                   ctermfg=NONE  ctermbg=11    guifg=NONE          guibg=NONE
highlight Question                     cterm=italic                 ctermfg=7     ctermbg=NONE  guifg=LightGray     guibg=NONE
highlight Scrollbar                    cterm=NONE                   ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight SpecialKey                   cterm=bold                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight Title                        cterm=NONE                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight Tooltip                      cterm=NONE                   ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight WildMenu                     cterm=NONE                   ctermfg=NONE  ctermbg=5     guifg=NONE          guibg=Magenta
"}}}

"{{{ UI Columns and Lines
highlight ColorColumn                  cterm=NONE                   ctermfg=11    ctermbg=8     guifg=LightCyan     guibg=DarkGray
highlight CursorColumn                 cterm=NONE                   ctermfg=0     ctermbg=11    guifg=Black         guibg=LightCyan
highlight CursorLine                   cterm=NONE                   ctermfg=0     ctermbg=11    guifg=Black         guibg=LightCyan
highlight CursorLineNr                 cterm=NONE                   ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight FoldColumn                   cterm=bold                   ctermfg=15    ctermbg=NONE  guifg=White         guibg=NONE
highlight SignColumn                   cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight VertSplit                    cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
"}}}

"{{{ Spelling
highlight SpellBad                     cterm=NONE                   ctermfg=1     ctermbg=NONE  guifg=Blue          guibg=NONE
highlight SpellCap                     cterm=NONE                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight SpellLocal                   cterm=NONE                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight SpellRare                    cterm=NONE                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
"}}}

"{{{ Diff
highlight DiffAdd                      cterm=underline              ctermfg=2     ctermbg=NONE  guifg=Green         guibg=NONE
highlight DiffChange                   cterm=underline              ctermfg=3     ctermbg=NONE  guifg=Cyan          guibg=NONE
highlight DiffDelete                   cterm=NONE                   ctermfg=1     ctermbg=NONE  guifg=Blue          guibg=NONE
highlight DiffText                     cterm=underline              ctermfg=13    ctermbg=NONE  guifg=LightMagenta  guibg=NONE
"}}}

"{{{ Statusline
highlight StatusLine                   cterm=NONE                   ctermfg=0     ctermbg=4     guifg=Black         guibg=Red
highlight StatusLineFocus              cterm=NONE                   ctermfg=4     ctermbg=15    guifg=Red           guibg=White
highlight StatusLineNC                 cterm=NONE                   ctermfg=4     ctermbg=8     guifg=Red           guibg=DarkGray
highlight StatusLineTerm               cterm=NONE                   ctermfg=0     ctermbg=13    guifg=Black         guibg=LightMagenta
highlight StatusLineTermNC             cterm=NONE                   ctermfg=4     ctermbg=8     guifg=Red           guibg=DarkGray
"}}}

"{{{ Tabline
highlight TabLine                      cterm=underline              ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
highlight TabLineDirectory             cterm=underline              ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight TabLineFill                  cterm=underline              ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight TabLineFocus                 cterm=underline              ctermfg=4     ctermbg=NONE  guifg=Red           guibg=NONE
highlight TabLineNotice                cterm=underline              ctermfg=1     ctermbg=NONE  guifg=Blue          guibg=NONE
highlight TabLineSel                   cterm=italic,bold,underline  ctermfg=15    ctermbg=NONE  guifg=White         guibg=NONE
"}}}

"{{{ Searching/Matches
highlight IncSearch                    cterm=NONE                   ctermfg=NONE  ctermbg=5     guifg=NONE          guibg=Magenta
highlight MatchParen                   cterm=NONE                   ctermfg=5     ctermbg=NONE  guifg=Magenta       guibg=NONE
highlight Search                       cterm=bold,underline         ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
"}}}

"{{{ Syntax
highlight Comment                      cterm=italic                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight Constant                     cterm=NONE                   ctermfg=3     ctermbg=NONE  guifg=Cyan          guibg=NONE
highlight Define                       cterm=NONE                   ctermfg=9     ctermbg=NONE  guifg=LightBlue     guibg=NONE
highlight Delimiter                    cterm=bold                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight Error                        cterm=NONE                   ctermfg=1     ctermbg=NONE  guifg=Blue          guibg=NONE
highlight Exception                    cterm=bold                   ctermfg=15    ctermbg=NONE  guifg=White         guibg=NONE
highlight Function                     cterm=NONE                   ctermfg=2     ctermbg=NONE  guifg=Green         guibg=NONE
highlight Identifier                   cterm=NONE                   ctermfg=2     ctermbg=NONE  guifg=Green         guibg=NONE
highlight Conceal                      cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight Ignore                       cterm=NONE                   ctermfg=8     ctermbg=NONE  guifg=DarkGray      guibg=NONE
highlight Keyword                      cterm=NONE                   ctermfg=15    ctermbg=NONE  guifg=White         guibg=NONE
highlight Macro                        cterm=NONE                   ctermfg=9     ctermbg=NONE  guifg=LightBlue     guibg=NONE
highlight Number                       cterm=NONE                   ctermfg=3     ctermbg=NONE  guifg=Cyan          guibg=NONE
highlight Operator                     cterm=bold                   ctermfg=15    ctermbg=NONE  guifg=White         guibg=NONE
highlight PreProc                      cterm=NONE                   ctermfg=13    ctermbg=NONE  guifg=LightMagenta  guibg=NONE
highlight Special                      cterm=NONE                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight SpecialChar                  cterm=bold                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight SpecialComment               cterm=NONE                   ctermfg=12    ctermbg=NONE  guifg=LightRed      guibg=NONE
highlight Statement                    cterm=NONE                   ctermfg=15    ctermbg=NONE  guifg=White         guibg=NONE
highlight String                       cterm=NONE                   ctermfg=3     ctermbg=NONE  guifg=Cyan          guibg=NONE
highlight Todo                         cterm=NONE                   ctermfg=1     ctermbg=15    guifg=Blue          guibg=White
highlight Type                         cterm=NONE                   ctermfg=6     ctermbg=NONE  guifg=Yellow        guibg=NONE
highlight Underlined                   cterm=underline              ctermfg=NONE  ctermbg=NONE  guifg=NONE          guibg=NONE
"}}}

" --- Outro
syntax enable

" vim: foldmethod=marker
