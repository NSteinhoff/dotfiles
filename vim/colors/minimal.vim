hi  clear
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

hi  Normal       cterm=none     ctermfg=Grey  ctermbg=Black

" Hues {{{
hi  Nothing             cterm=none               ctermfg=none      ctermbg=none
hi  LightlyContrasted   cterm=underline          ctermfg=none      ctermbg=none
hi  Contrasted          cterm=inverse            ctermfg=none      ctermbg=none
hi  StronglyContrasted  cterm=underline,inverse  ctermfg=none      ctermbg=none
hi  Faded               cterm=none               ctermfg=DarkGrey  ctermbg=none
hi  Hidden              cterm=none               ctermfg=bg        ctermbg=bg
hi  Linked              cterm=underline          ctermfg=fg        ctermbg=none
hi  Bold                cterm=bold               ctermfg=fg        ctermbg=none
hi  Italic              cterm=italic             ctermfg=fg        ctermbg=none
hi  Pop                 cterm=none               ctermfg=White     ctermbg=none
hi  StrongPop           cterm=bold               ctermfg=White     ctermbg=none
hi  UltraPop            cterm=bold,underline     ctermfg=White     ctermbg=none
"}}}

"" Colors {{{
hi  Hostile          cterm=none  ctermfg=Red          ctermbg=none
hi  VeryHostile      cterm=bold  ctermfg=Red          ctermbg=none
hi  Friendly         cterm=none  ctermfg=DarkCyan     ctermbg=none
hi  VeryFriendly     cterm=bold  ctermfg=DarkCyan     ctermbg=none
hi  Calm             cterm=none  ctermfg=DarkGreen    ctermbg=none
hi  VeryCalm         cterm=bold  ctermfg=DarkGreen    ctermbg=none
hi  Happy            cterm=none  ctermfg=DarkYellow   ctermbg=none
hi  VeryHappy        cterm=bold  ctermfg=DarkYellow   ctermbg=none
hi  Excited          cterm=none  ctermfg=Yellow       ctermbg=none
hi  VeryExcited      cterm=bold  ctermfg=Yellow       ctermbg=none
hi  Interesting      cterm=none  ctermfg=DarkBlue     ctermbg=none
hi  VeryInteresting  cterm=bold  ctermfg=DarkBlue     ctermbg=none
hi  Forceful         cterm=none  ctermfg=DarkRed      ctermbg=none
hi  VeryForceful     cterm=bold  ctermfg=DarkRed      ctermbg=none
hi  Shy              cterm=none  ctermfg=DarkMagenta  ctermbg=none
hi  NotSoShy         cterm=bold  ctermfg=DarkMagenta  ctermbg=none

""" Bars {{{
hi  FadedBar        cterm=underline  ctermfg=DarkGrey     ctermbg=none
hi  ShyBar          cterm=underline  ctermfg=DarkMagenta  ctermbg=none
hi  CalmBar         cterm=underline  ctermfg=DarkGreen    ctermbg=none
hi  HappyBar        cterm=underline  ctermfg=DarkYellow   ctermbg=none
hi  ExcitedBar      cterm=underline  ctermfg=Yellow       ctermbg=none
hi  InterestingBar  cterm=underline  ctermfg=Blue         ctermbg=none
hi  FriendlyBar     cterm=underline  ctermfg=DarkCyan     ctermbg=none
"}}}

""" Highlights {{{
hi  HighlightFaded     cterm=none  ctermfg=Grey   ctermbg=DarkGrey
hi  HighlightFriendly  cterm=none  ctermfg=Black  ctermbg=Cyan
hi  HighlightCalm      cterm=none  ctermfg=Black  ctermbg=Green
hi  HighlightForceful  cterm=none  ctermfg=Black  ctermbg=Red
hi  HighlightShy       cterm=none  ctermfg=Black  ctermbg=Magenta
hi  HighlightHappy     cterm=none  ctermfg=Black  ctermbg=Yellow
"}}}
"}}}
"}}}

" Basic Settings {{{
hi!  link  NormalNC     Normal
hi!  link  NonText      Hostile
hi!  link  Visual       Contrasted
hi!  link  EndOfBuffer  Hidden
"}}}

" Searching {{{
hi!  link Search      HighlightHappy
hi!  link IncSearch   HighlightShy
hi!  link Substitute  Search
"}}}

" Cursor {{{
hi!  link Cursor        Contrasted
hi!  link CursorIM      Cursor
hi!  link TermCursor    Cursor
hi!  link TermCursorNC  Cursor
"}}}

" UI Elements {{{
hi!     link  ColorColumn        HighlightFaded
hi!     link  CursorColumn       HighlightFaded
hi!     link  CursorLine         LightlyContrasted
hi!     link  CursorLineNr       Normal
hi!     link  FoldColumn         Faded
hi!     link  Folded             Faded
hi!     link  LineNr             Faded
hi!     link  MatchParen         Contrasted
hi!     link  Pmenu              Contrasted
hi!     link  PmenuSbar          Contrasted
hi!     link  PmenuSel           HighlightShy
hi!     link  PmenuThumb         Normal
hi!     link  SignColumn         Faded
hi!     link  StatusLine         FriendlyBar
hi!     link  StatusLineNC       FadedBar
hi!     link  StatusLineTerm     InterestingBar
hi!     link  StatusLineTermNC   FadedBar
hi!     link  TabLine            LightlyContrasted
hi!     link  TabLineFill        LightlyContrasted
hi!     link  TabLineSel         UltraPop
hi!     link  VertSplit          Faded
hi!     link  WildMenu           HighlightHappy
"}}}

" Other {{{
hi!     link  Conceal            Normal
hi!     link  Directory          Normal
hi!     link  DiffAdd            Calm
hi!     link  DiffChange         Excited
hi!     link  DiffDelete         Forceful
hi!     link  DiffText           HighlightShy
hi!     link  ErrorMsg           Hostile
hi!     link  ModeMsg            Normal
hi!     link  MsgSeparator       Normal
hi!     link  MoreMsg            Normal
hi!     link  Question           Normal
hi!     link  QuickFixLine       Normal
hi!     link  SpecialKey         Normal
hi!     link  SpellBad           Hostile
hi!     link  SpellCap           Normal
hi!     link  SpellLocal         Normal
hi!     link  SpellRare          Normal
hi!     link  Title              StrongPop
hi!     link  VisualNOS          Normal
hi!     link  WarningMsg         Normal
hi!     link  Whitespace         Hostile
hi!     link  The                Normal
hi!     link  For                Normal
hi!     link  scrollbars         Normal
hi!     link  Win32              Normal
hi!     link  and                Normal
hi!     link  Type               StrongPop
hi!     link  Error              Hostile
hi!     link  Identifier         Normal
hi!     link  Function           Pop
hi!     link  Comment            Faded
hi!     link  Constant           Interesting
hi!     link  String             Interesting
hi!     link  Number             Interesting
hi!     link  Special            Pop
hi!     link  Statement          Pop
hi!     link  Function           Pop
hi!     link  Operator           Pop
hi!     link  Keyword            Friendly
hi!     link  PreProc            StrongPop
hi!     link  Underlined         Linked
hi!     link  Ignore             Normal
hi!     link  Todo               Forceful
"}}}

" GUI {{{
hi!  link  Menu       Normal
hi!  link  Scrollbar  Normal
hi!  link  Tooltip    Normal
"}}}

" Neovim {{{
hi!  link  NvimInternalError  VeryHostile
"}}}

" Netrw {{{
hi!  link  netrwDir      Interesting
hi!  link  netrwSymLink  Shy
"}}}

" Markdown {{{
hi!  link  markdownCode       Interesting
hi!  link  markdownItalic     Pop
hi!  link  markdownBold       Pop
hi!  link  markdownCodeBlock  Interesting
"}}}

syntax enable

" vim: fdm=marker:sw=2:sts=2:et
