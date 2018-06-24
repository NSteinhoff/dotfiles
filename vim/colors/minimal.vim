hi  clear
syntax reset
let g:colors_name="minimal"

hi  Normal       cterm=none     ctermfg=Grey  ctermbg=Black

" Templates
"----------
hi  Nothing             cterm=none               ctermfg=none       ctermbg=none
hi  LightlyContrasted   cterm=underline          ctermfg=none       ctermbg=none
hi  Contrasted          cterm=inverse            ctermfg=none       ctermbg=none
hi  StronglyContrasted  cterm=underline,inverse  ctermfg=none       ctermbg=none
hi  Faded               cterm=none               ctermfg=DarkGrey   ctermbg=none
hi  FadedBar            cterm=underline          ctermfg=DarkGrey   ctermbg=none
hi  Hidden              cterm=none               ctermfg=bg         ctermbg=none
hi  Linked              cterm=underline          ctermfg=none       ctermbg=none
hi  SubtlePop           cterm=none               ctermfg=LightGrey  ctermbg=none
hi  LightPop            cterm=bold               ctermfg=LightGrey  ctermbg=none
hi  Pop                 cterm=none               ctermfg=White      ctermbg=none
hi  StrongPop           cterm=bold               ctermfg=White      ctermbg=none
hi  ExtremePop          cterm=bold,underline     ctermfg=White      ctermbg=none

" Colored
hi  Hostile            cterm=none       ctermfg=DarkRed      ctermbg=none
hi  VeryHostile        cterm=bold       ctermfg=DarkRed      ctermbg=none
hi  Friendly           cterm=none       ctermfg=LightGreen   ctermbg=none
hi  VeryFriendly       cterm=bold       ctermfg=LightGreen   ctermbg=none
hi  Happy              cterm=none       ctermfg=Yellow       ctermbg=none
hi  VeryHappy          cterm=bold       ctermfg=Yellow       ctermbg=none
hi  MildlyInteresting  cterm=none       ctermfg=LightBlue    ctermbg=none
hi  Interesting        cterm=bold       ctermfg=LightBlue    ctermbg=none
hi  VeryInteresting    cterm=bold       ctermfg=Blue         ctermbg=none
hi  Forceful           cterm=none       ctermfg=Red          ctermbg=none
hi  VeryForceful       cterm=bold       ctermfg=Red          ctermbg=none
hi  Shy                cterm=none       ctermfg=DarkMagenta  ctermbg=none
hi  ShyBar             cterm=underline  ctermfg=DarkMagenta  ctermbg=none

hi  HighlightFriendly  cterm=none       ctermfg=Black        ctermbg=LightGreen
hi  HighlightHappy     cterm=none       ctermfg=Black        ctermbg=LightYellow
hi  HighlightShy       cterm=none       ctermfg=Black        ctermbg=Magenta
hi  HighlightForceful  cterm=none       ctermfg=Black        ctermbg=Red


" Basic Settings
hi!  link  NormalNC     Normal
hi!  link  NonText      Hostile
hi!  link  Visual       Contrasted
hi!  link  EndOfBuffer  Hidden


" Searching
hi!  link Search      Contrasted
hi!  link IncSearch   Contrasted
hi!  link Substitute  Contrasted


" Cursor
hi!  link Cursor        Contrasted
hi!  link CursorIM      Contrasted
hi!  link TermCursor    Contrasted
hi!  link TermCursorNC  Contrasted


" UI Elements
hi!     link  ColorColumn        Contrasted
hi!     link  CursorColumn       Contrasted
hi!     link  CursorLine         LightlyContrasted
hi!     link  CursorLineNr       Normal
hi!     link  FoldColumn         Faded
hi!     link  Folded             Faded
hi!     link  LineNr             Faded
hi!     link  MatchParen         Contrasted
hi!     link  Pmenu              Contrasted
hi!     link  PmenuSbar          Contrasted
hi!     link  PmenuSel           Normal
hi!     link  PmenuThumb         Normal
hi!     link  SignColumn         Faded
hi!     link  StatusLine         ShyBar
hi!     link  StatusLineNC       FadedBar
hi!     link  TabLine            LightlyContrasted
hi!     link  TabLineFill        LightlyContrasted
hi!     link  TabLineSel         ExtremePop
hi!     link  VertSplit          Faded
hi!     link  WildMenu           Normal

" Other
hi!     link  Conceal            Normal
hi!     link  Directory          Normal
hi!     link  DiffAdd            HighlightFriendly
hi!     link  DiffChange         HighlightHappy
hi!     link  DiffDelete         HighlightForceful
hi!     link  DiffText           HighlightShy
hi!     link  ErrorMsg           VeryHostile
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
hi!     link  Title              ExtremePop
hi!     link  VisualNOS          Normal
hi!     link  WarningMsg         Normal
hi!     link  Whitespace         Hostile
hi!     link  The                Normal
hi!     link  For                Normal
hi!     link  scrollbars         Normal
hi!     link  Win32              Normal
hi!     link  and                Normal
hi!     link  Type               StrongPop
hi!     link  Error              VeryHostile
hi!     link  Identifier         Normal
hi!     link  Function           SubtlePop
hi!     link  Comment            Friendly
hi!     link  Constant           MildlyInteresting
hi!     link  String             MildlyInteresting
hi!     link  Number             VeryInteresting
hi!     link  Special            Forceful
hi!     link  Statement          LightPop
hi!     link  Operator           Pop
hi!     link  Keyword            Pop
hi!     link  PreProc            Normal
hi!     link  Underlined         Linked
hi!     link  Ignore             Normal
hi!     link  Todo               VeryForceful

" GUI
hi!  link  Menu       Normal
hi!  link  Scrollbar  Normal
hi!  link  Tooltip    Normal

" Neovim
hi!     link  NvimInternalError  VeryHostile

syntax enable

" vim: fdm=marker:sw=2:sts=2:et
