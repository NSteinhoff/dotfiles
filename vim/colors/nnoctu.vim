" nnoctu.vim - Vim color scheme for 16-color terminals
" --------------------------------------------------------------
" Author:   Niko Steinhoff
" based on 'noctu.vim' by Noah Frederick (http://noahfrederick.com/)
" Version:  0.1.0
" --------------------------------------------------------------

" Scheme setup {{{
set background=dark
hi! clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "nnoctu"

"}}}
" Vim UI {{{
hi Normal              ctermfg=7
hi Cursor              ctermfg=7     ctermbg=1
hi CursorLine          ctermbg=0     cterm=NONE
hi MatchParen          ctermfg=7     ctermbg=NONE  cterm=underline
hi Pmenu               ctermfg=15    ctermbg=0
hi PmenuThumb          ctermbg=7
hi PmenuSBar           ctermbg=8
hi PmenuSel            ctermfg=0     ctermbg=4
hi ColorColumn         ctermbg=0
hi SpellBad            ctermfg=1     ctermbg=NONE  cterm=underline
hi SpellCap            ctermfg=10    ctermbg=NONE  cterm=underline
hi SpellRare           ctermfg=11    ctermbg=NONE  cterm=underline
hi SpellLocal          ctermfg=13    ctermbg=NONE  cterm=underline
hi NonText             ctermfg=8
hi LineNr              ctermfg=8     ctermbg=NONE
hi CursorLineNr        ctermfg=11    ctermbg=0
hi Visual              ctermfg=0     ctermbg=12
hi IncSearch           ctermfg=0     ctermbg=13    cterm=NONE
hi Search              ctermfg=0     ctermbg=10
hi StatusLine          ctermfg=7     ctermbg=0     cterm=bold
hi StatusLineNC        ctermfg=8     ctermbg=0     cterm=bold
hi VertSplit           ctermfg=0     ctermbg=0     cterm=NONE
hi TabLine             ctermfg=8     ctermbg=0     cterm=NONE
hi TabLineSel          ctermfg=7     ctermbg=0
hi Folded              ctermfg=6     ctermbg=0     cterm=bold
hi Conceal             ctermfg=6     ctermbg=NONE
hi Directory           ctermfg=12
hi Title               ctermfg=3     cterm=bold
hi ErrorMsg            ctermfg=15    ctermbg=1
hi DiffAdd             ctermfg=0     ctermbg=2
hi DiffChange          ctermfg=0     ctermbg=3
hi DiffDelete          ctermfg=0     ctermbg=1
hi DiffText            ctermfg=0     ctermbg=11    cterm=bold
hi User1               ctermfg=1     ctermbg=0
hi User2               ctermfg=4     ctermbg=0
hi User3               ctermfg=2     ctermbg=0
hi User4               ctermfg=3     ctermbg=0
hi User5               ctermfg=5     ctermbg=0
hi User6               ctermfg=6     ctermbg=0
hi User7               ctermfg=7     ctermbg=0
hi User8               ctermfg=8     ctermbg=0
hi User9               ctermfg=15    ctermbg=5
hi! link CursorColumn  CursorLine
hi! link SignColumn    LineNr
hi! link WildMenu      Visual
hi! link FoldColumn    SignColumn
hi! link WarningMsg    ErrorMsg
hi! link MoreMsg       Title
hi! link Question      MoreMsg
hi! link ModeMsg       MoreMsg
hi! link TabLineFill   StatusLineNC
hi! link SpecialKey    NonText

"}}}
" Generic syntax {{{
hi Delimiter       ctermfg=7
hi Comment         ctermfg=8
hi Underlined      ctermfg=4   cterm=underline
hi Type            ctermfg=4
hi String          ctermfg=11
hi Keyword         ctermfg=2
hi Todo            ctermfg=15  ctermbg=NONE     cterm=bold,underline
hi Function        ctermfg=4
hi Identifier      ctermfg=7   cterm=NONE
hi Statement       ctermfg=2   cterm=bold
hi Constant        ctermfg=13
hi Number          ctermfg=12
hi Boolean         ctermfg=4
hi Special         ctermfg=13
hi Ignore          ctermfg=0
hi PreProc         ctermfg=8   cterm=bold
hi! link Operator  Delimiter
hi! link Error     ErrorMsg

"}}}
" Help {{{
hi! link helpExample         String
hi! link helpHeadline        Title
hi! link helpSectionDelim    Comment
hi! link helpHyperTextEntry  Statement
hi! link helpHyperTextJump   Underlined
hi! link helpURL             Underlined

"}}}
" Netrw {{{
hi netrwExe       ctermfg=9
hi netrwClassify  ctermfg=8  cterm=bold

"}}}
" Shell {{{
hi shDerefSimple     ctermfg=11
hi! link shDerefVar  shDerefSimple

"}}}
" Git {{{
hi gitCommitBranch               ctermfg=3
hi gitCommitSelectedType         ctermfg=10
hi gitCommitSelectedFile         ctermfg=2
hi gitCommitUnmergedType         ctermfg=9
hi gitCommitUnmergedFile         ctermfg=1
hi! link gitCommitFile           Directory
hi! link gitCommitUntrackedFile  gitCommitUnmergedFile
hi! link gitCommitDiscardedType  gitCommitUnmergedType
hi! link gitCommitDiscardedFile  gitCommitUnmergedFile

"}}}
" Diff {{{
hi diffAdded  ctermfg=2
hi diffRemoved  ctermfg=1
hi! link diffFile  PreProc
hi! link diffLine  Title

"}}}
" Vim {{{
hi! link vimSetSep    Delimiter
hi! link vimContinue  Delimiter
hi! link vimHiAttrib  Constant

"}}}
" LESS {{{
hi lessVariable             ctermfg=11
hi! link lessVariableValue  Normal

"}}}
" Markdown {{{
hi! link markdownHeadingRule        NonText
hi! link markdownHeadingDelimiter   markdownHeadingRule
hi! link markdownLinkDelimiter      Delimiter
hi! link markdownURLDelimiter       Delimiter
hi! link markdownCodeDelimiter      NonText
hi! link markdownLinkTextDelimiter  markdownLinkDelimiter
hi! link markdownUrl                markdownLinkText
hi! link markdownAutomaticLink      markdownLinkText
hi! link markdownCodeBlock          String
hi markdownCode                     cterm=bold
hi markdownBold                     cterm=bold
hi markdownItalic                   cterm=underline

"}}}

" vim: fdm=marker:sw=2:sts=2:et
