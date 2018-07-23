highlight  clear
syntax reset
let g:colors_name="minimal"

set t_Co=256
set background=dark

" Templates {{{
"----------
"        NR-16   NR-8    COLOR NAME
"        0       0       Black
"        1       4       DarkBlue
"        2       2       DarkGreen
"        3       6       DarkCyan
"        4       1       DarkRed
"        5       5       DarkMagenta
"        6       3       Brown, DarkYellow
"        7       7       LightGray, LightGrey, Gray, Grey
"        8       0*      DarkGray, DarkGrey
"        9       4*      Blue, LightBlue
"        10      2*      Green, LightGreen
"        11      6*      Cyan, LightCyan
"        12      1*      Red, LightRed
"        13      5*      Magenta, LightMagenta
"        14      3*      Yellow, LightYellow
"        15      7*      White


highlight  Normal       cterm=none     ctermfg=Grey  ctermbg=Black

" Hues {{{
highlight  Nothing             cterm=none               ctermfg=none      ctermbg=none
highlight  LightlyContrasted   cterm=underline          ctermfg=none      ctermbg=none
highlight  Contrasted          cterm=inverse            ctermfg=none      ctermbg=none
highlight  StronglyContrasted  cterm=underline,inverse  ctermfg=none      ctermbg=none
highlight  Faded               cterm=none               ctermfg=DarkGrey  ctermbg=none
highlight  Hidden              cterm=none               ctermfg=bg        ctermbg=bg
highlight  Linked              cterm=underline          ctermfg=fg        ctermbg=none
highlight  Bold                cterm=bold               ctermfg=fg        ctermbg=none
highlight  Italic              cterm=italic             ctermfg=fg        ctermbg=none
highlight  Pop                 cterm=none               ctermfg=White     ctermbg=none
highlight  StrongPop           cterm=bold               ctermfg=White     ctermbg=none
highlight  UltraPop            cterm=bold,underline     ctermfg=White     ctermbg=none
"}}}

"" Moods {{{
highlight  Proud      cterm=none  ctermfg=DarkBlue     ctermbg=none
highlight  Calm       cterm=none  ctermfg=DarkGreen    ctermbg=none
highlight  Peaceful   cterm=none  ctermfg=DarkCyan     ctermbg=none
highlight  Forceful   cterm=none  ctermfg=DarkRed      ctermbg=none
highlight  Happy      cterm=none  ctermfg=DarkMagenta  ctermbg=none
highlight  Busy       cterm=none  ctermfg=DarkYellow   ctermbg=none
highlight  Satisfied  cterm=none  ctermfg=Blue         ctermbg=none
highlight  Relaxed    cterm=none  ctermfg=Green        ctermbg=none
highlight  Fresh      cterm=none  ctermfg=Cyan         ctermbg=none
highlight  Intense    cterm=none  ctermfg=Red          ctermbg=none
highlight  Excited    cterm=none  ctermfg=Magenta      ctermbg=none
highlight  Lively     cterm=none  ctermfg=Yellow       ctermbg=none

""" Highlights {{{
hi  HighlightFaded      cterm=none  ctermfg=Grey   ctermbg=DarkGrey
hi  HighlightExcited    cterm=none  ctermfg=Black  ctermbg=Magenta
hi  HighlightSatisfied  cterm=none  ctermfg=White  ctermbg=Blue
hi  HighlightLively     cterm=none  ctermfg=Black  ctermbg=Yellow
hi  HighlightPeaceful   cterm=none  ctermfg=White  ctermbg=DarkCyan
"}}}
"}}}
"}}}

" Basic Settings {{{
hi!  link  NormalNC     Normal
hi!  link  NonText      Forceful
hi!  link  Visual       Contrasted
hi!  link  EndOfBuffer  Hidden
"}}}

" Searching {{{
hi!  link Search      HighlightLively
hi!  link IncSearch   HighlightExcited
hi!  link Substitute  Search
"}}}

" Cursor {{{
hi!  link Cursor        Contrasted
hi!  link CursorIM      Cursor
hi!  link TermCursor    Cursor
hi!  link TermCursorNC  Cursor
"}}}

" UI Elements {{{
hi!  link  ColorColumn       HighlightFaded
hi!  link  CursorColumn      HighlightFaded
hi!  link  CursorLine        LightlyContrasted
hi!  link  CursorLineNr      Normal
hi!  link  FoldColumn        Faded
hi!  link  Folded            Faded
hi!  link  LineNr            Faded
hi!  link  MatchParen        Contrasted
hi!  link  Menu              Normal
hi!  link  Pmenu             Contrasted
hi!  link  PmenuSbar         Contrasted
hi!  link  PmenuSel          HighlightExcited
hi!  link  PmenuThumb        Normal
hi!  link  Scrollbar         Normal
hi!  link  SignColumn        Faded
hi!  link  StatusLine        HighlightPeaceful
hi!  link  StatusLineNC      HighlightFaded
hi!  link  StatusLineTerm    HighlightSatisfied
hi!  link  StatusLineTermNC  HighlightFaded
hi!  link  TabLine           LightlyContrasted
hi!  link  TabLineFill       LightlyContrasted
hi!  link  TabLineSel        UltraPop
hi!  link  Tooltip           Normal
hi!  link  VertSplit         Faded
hi!  link  WildMenu          HighlightLively
"}}}

" Diffs {{{
hi!     link  DiffAdd            Calm
hi!     link  DiffChange         Excited
hi!     link  DiffDelete         Forceful
hi!     link  DiffText           HighlightExcited
"}}}

let s:syntax_groups = {
\ "error":       "Forceful",
\ "constant":    "Proud",
\ "identifier":  "Normal",
\ "statement":   "Pop",
\ "operator":    "Pop",
\ "type":        "Peaceful",
\ "global":      "Calm",
\ "trivial":     "Faded",
\ "special":     "Happy",
\ "emphasis":    "Pop"
\}

let s:syntax_items = {
\ "error": [
\   "Error",
\   "ErrorMsg",
\   "SpellBad",
\   "NvimInternalError",
\   ],
\ "constant": [
\   "Constant",
\   "Number",
\   "String",
\   "Directory",
\   "markdownCode",
\   "markdownCodeBlock",
\   ],
\ "identifier": [
\   "Identifier",
\   ],
\ "statement": [
\   "Statement",
\   ],
\ "operator": [
\   "Operator",
\   "Function",
\   ],
\ "type": [
\   "Type",
\   ],
\ "global": [
\   "PreProc",
\   "Keyword",
\   ],
\ "trivial": [
\   "Comment",
\   "Ignore",
\   "Conceal",
\   "Noise",
\   ],
\ "special": [
\   "Special",
\   "SpecialKey",
\   "SpellCap",
\   "SpellLocal",
\   "SpellRare",
\   "Title",
\   "Todo",
\   "netrwSymLink",
\   ],
\ "emphasis": [
\   "Underlined",
\   "markdownItalic",
\   "markdownBold",
\   "markdownBoldItalic",
\   ],
\}

function! s:highlight_groups()
  for [l:group, l:color] in items(s:syntax_groups)
    let l:items = s:syntax_items[l:group]
    " echo "Highlighting group " . l:group . " with color " . l:color
    call s:highlight_items(l:items, l:color)
  endfor
endfunction

function! s:highlight_items(items, color)
  for l:item in a:items
    exec "highlight! link " . l:item . " " . a:color
  endfor
endfunction

call s:highlight_groups()

syntax enable

" vim: fdm=marker:sw=2:sts=2:et
