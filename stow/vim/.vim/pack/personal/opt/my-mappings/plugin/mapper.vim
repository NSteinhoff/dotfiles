" --- Mappable Keys{{{
" Non-conflicting mappable keys and sequences. There are tons more.
"
" <BACKSPACE>
"   -> very convenient adhoc execution mapping
"   e.g.  :nnoremap <BACKSPACE> :!python %<CR>
"
" Function keys:
"   <F2>
"   ...
"   <F12>
"
"
"  .            !     c    d       y         <       >        m             z             `             '             @             "             <PLACEHOLDER>
"  ---          ---   ---  ---     ---       ---     ---      ---           ---           ---           ---           ---           ---          
"  MNEMONIC     'do'  .    'diff'  'toggle'  'left'  'right'  'make'        .             .             .             'at'          'comment'     .
"  ---          ---   ---  ---     ---       ---     ---      ---           ---           ---           ---           ---           ---          
"  c            !c    .    dc      yc        <c      >c       .             .             .             .             .             .             .
"  d            !d    cd   .       yd        <d      >d       .             .             .             .             .             .             .
"  y            !y    cy   dy      .         <y      >y       .             .             .             .             .             .             .
"  p            !p    cp   dp      yp        <p      >p       .             .             .             .             .             .             .
"  u            !u    cu   du      yu        <u      >u       .             .             .             .             .             .             .
"  C            !C    .    dC      yC        <C      >C       .             .             .             .             .             .             .
"  D            !D    cD   .       yD        <D      >D       .             .             .             .             .             .             .
"  Y            !Y    cY   dY      .         <Y      >Y       .             .             .             .             .             .             .
"  P            !P    cP   dP      yP        <P      >P       .             .             .             .             .             .             .
"  U            !U    cU   dU      yU        <U      >U       .             .             .             .             .             .             .
"  "            !"    c"   d"      y"        <"      >"       .             z"            .             .             .             ""            .
"  .            !.    c.   d.      y.        <.      >.       .             .             .             .             .             .             .
"  <            !<    c<   d<      y<        .       ><       .             z<            .             .             @<            "<            .
"  >            !>    c>   d>      y>        <>      .        .             z>            .             .             @>            ">            .
"  !            .     c!   d!      y!        <!      >!       m!            z!            `!            '!            @!            "!            .
"  @            !@    c@   d@      y@        <@      >@       m@            z@            `@            '@            ..            ..            .
"  &            !&    c&   d&      y&        <&      >&       m&            z&            `&            '&            @&            "&            .
"  =            !=    c=   d=      y=        <=      >=       m=            .             `=            '=            .             .             .
"  ;            !;    c;   d;      y;        <;      >;       m;            z;            `;            ';            .             .             .
"  ,            !,    c,   d,      y,        <,      >,       m,            z,            `,            ',            @,            ",            .
"  `            .     .    .       .         .       .        .             z`            .             .             @`            "`            .
"  .            .     .    .       .         .       .        z             .             .             .             .             .
"  '            .     .    .       .         .       .        .             .             .             .             @'            "'            .
"  [            .     .    .       .         .       .        .             z[            .             .             @[            "[            .
"  ]            .     .    .       .         .       .        .             z]            .             .             @]            "]            .
"  }            .     .    .       .         .       .        m}            z{            `}            '}            @}            "}            .
"  {            .     .    .       .         .       .        m{            z}            `{            '{            @{            "{            .
"  <SPACE>      .     .    .       .         .       .        m<SPACE>      z<SPACE>      `<SPACE>      '<SPACE>      @<SPACE>      "<SPACE>      .
"  <BACKSPACE>  .     .    .       .         .       .        m<BACKSPACE>  z<BACKSPACE>  `<BACKSPACE>  '<BACKSPACE>  @<BACKSPACE>  "<BACKSPACE>  .
"  <CR>         .     .    .       .         .       .        m<CR>         .             `<CR>         '<CR>         @<CR>         "<CR>         .
"  ?            .     .    .       .         .       .        .             .             .             .             @?            "?            .
"  .            .     .    .       .         .       .        .             .             .             .             .             .             .
"
"}}}

" --- Basics{{{
" Move over visual lines unless a count is given
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Window resizing with the arrow keys
map  <left>   5<C-W><  "  decrease  width
map  <right>  5<C-W>>  "  increase  width
map  <up>     5<C-W>+  "  increase  height
map  <down>   5<C-W>-  "  decrease  height

" Terminal
tmap <c-w>] <c-\><c-n>
tmap <c-w><c-]> <c-\><c-n>
"}}}

" --- Searching{{{
nnoremap <silent> <leader>rg :execute 'Rg '.expand('<cword>')<CR>
nnoremap <silent> <leader>ag :execute 'Ag '.expand('<cword>')<CR>
"}}}

" --- Execution{{{
" Run selected lines
" vnoremap <silent> <CR> :Run<CR>
" Run whole file
" nnoremap <silent> <BACKSPACE> :%Run<CR>
"}}}

" --- Scrolling{{{
" Scrolling the window with CTRL-HJKL
nnoremap <C-J> 3<C-E>
nnoremap <C-K> 3<C-Y>
nnoremap <C-H> 3zh
nnoremap <C-L> 3zl

" Faster scrolling
nnoremap <C-E> 3<C-E>
nnoremap <C-Y> 3<C-Y>
"}}}

" --- Comment / Uncomment{{{
" Mnemonic:
"   " -> Vim's comment string
"   <CR> -> line
"   => 'comment line'
nnoremap <silent> "<CR> :ToggleCommented<CR>
vnoremap <silent> "<CR> :ToggleCommented<CR>
"}}}

" --- Format{{{
" Mnemonic:
"   < and > change indentation
"   => 'indent all'
nnoremap <silent> <> :Format<CR>
"}}}

" --- Clear search highlights{{{
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
"}}}

" --- Make{{{
" m<SPACE> and m<CR> make the project
" Mnemonic:
"   (m)ake
"   <CR> louder than <SPACE>
nnoremap <silent> m<SPACE> :Make<CR>
nnoremap <silent> m<CR> :make!<CR>
nnoremap <silent> <F5> :Make<CR>
nnoremap <silent> <S-F5> :make!<CR>
"}}}

" --- REPL{{{
map s <Plug>ReplSendSelection
nmap s! <Plug>ReplStart
nmap s? <Plug>ReplStatus
nmap ss <Plug>ReplSendLine
nmap sS <Plug>ReplSendFile
nmap s< <Plug>ReplSendAbove
nmap s> <Plug>ReplSendBelow
nmap s: <Plug>ReplSendCmd
nmap s<SPACE> <Plug>ReplSendBlock
nmap s<CR> <Plug>ReplSendBlockGoToNext
"}}}

" --- Errors: Quickfix / Location Lists{{{
" Mnemonic:
"   (Q)uickfix
nnoremap <silent> Q :clist<CR>
nnoremap <silent> <C-Q> :cwindow<CR>
"}}}

" --- Preview{{{
" Preview word under cursor
nnoremap <C-SPACE> <C-W>}
" Preview selection
vnoremap <silent> <C-SPACE> y:ptag<C-R>"<CR>
" Close the preview window
nnoremap <C-W><SPACE> <C-W>z
nnoremap <C-W><C-SPACE> <C-W>z
" Complete tag
inoremap <C-SPACE> <C-X><C-]>
"}}}

" --- Cycling{{{
" Quickly cycling a list
" (currently Buffers)
nnoremap <silent> <C-P> :bprevious<CR>
nnoremap <silent> <C-N> :bnext<CR>
"}}}

" --- Toggle Settings{{{
" Exetending 'vim-unimpaired'
" T: s(T)atusbar
nnoremap <silent> [o_ :set ls=2<CR>
nnoremap <silent> ]o_ :set ls=0<CR>
nnoremap <expr> <silent> yo_ (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')
"}}}

" --- <LEADER>{{{
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
let maplocalleader = '\'
set wildcharm=<C-Z>

" Quick Keys
vnoremap <leader>= :Align<CR>
nnoremap <leader>! :!%:p<CR>
nnoremap <leader>x :Run<CR>
vnoremap <leader>x :Run<CR>
nnoremap <leader>X :%Run<CR>
nnoremap <leader>o :BufOnly<CR>
nnoremap <leader>f :F<CR>

" Switch buffers
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>
nnoremap <leader>t :tab sbuffer <C-Z>
" Edit Settings files
nnoremap <leader>ee :edit $MYVIMRC<CR>
nnoremap <leader>ef :EditFtplugin<CR>
nnoremap <leader>ed :EditFtdetect<CR>
nnoremap <leader>ec :EditCompiler<CR>
nnoremap <leader>es :EditSyntax<CR>
nnoremap <leader>ei :EditIndent<CR>
nnoremap <leader>eo :EditColorscheme<CR>

" File Explorer
nnoremap <leader>E :Explore<CR>
nnoremap <leader>V :Vexplore<CR>
nnoremap <leader>T :Texplore<CR>
"}}}

" --- differ/vim-igitt{{{
nnoremap <silent> d; :Dstatus<CR>
nnoremap <silent> d@ :Dremote<CR>
nnoremap <silent> d! :Dremote!<CR>
nnoremap <silent> du :Dupdate<CR>
nnoremap <silent> d< :Dprevious<CR>
nnoremap <silent> d> :Dnext<CR>
nnoremap <silent> d. :Dthis<CR>
nnoremap <silent> d, :Dpatch<CR>
nnoremap <silent> d~ :Dpatch!<CR>
nnoremap <silent> d" :Dcomment<CR>
nnoremap <silent> d& :Dcomment!<CR>
nnoremap <silent> dc :Dshowcomments<CR>
nnoremap <silent> dC :Dshowcomments!<CR>
"}}}

" vim:foldmethod=marker textwidth=0
