"--- Mappable Keys{{{
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
"--- Basics{{{
" Move over visual lines unless a count is given
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Window resizing with the arrow keys
map  <left>   5<C-W><  "  decrease  width
map  <right>  5<C-W>>  "  increase  width
map  <up>     5<C-W>+  "  increase  height
map  <down>   5<C-W>-  "  decrease  height
"}}}
"--- Searching{{{
nnoremap <leader>rg :execute 'Rg '.expand('<cword>')<CR>
nnoremap <leader>ag :execute 'Ag '.expand('<cword>')<CR>
"}}}
"--- Execution{{{
" Run selected lines
vnoremap <CR> :Run<CR>
" Run whole file
nnoremap <BACKSPACE> :%Run<CR>
"}}}
"--- Scrolling{{{
" Scrolling the window with CTRL-HJKL
nnoremap <C-J> 3<C-E>
nnoremap <C-K> 3<C-Y>
nnoremap <C-H> 3zh
nnoremap <C-L> 3zl

" Faster scrolling
nnoremap <C-E> 3<C-E>
nnoremap <C-Y> 3<C-Y>
"}}}
"--- Comment / Uncomment{{{
" Mnemonic:
"   " -> Vim's comment string
"   <CR> -> line
"   => 'comment line'
nnoremap "<CR> :ToggleCommented<CR>
vnoremap "<CR> :ToggleCommented<CR>
"}}}
"--- Format{{{
" Mnemonic:
"   < and > change indentation
"   => 'indent all'
nnoremap <> :Format<CR>
"}}}
"--- Clear search highlights{{{
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
"}}}
"--- Make{{{
" m<SPACE> and m<CR> make the project
" Mnemonic:
"   (m)ake
"   <CR> louder than <SPACE>
nnoremap m<CR> :make!<CR>
nnoremap m<SPACE> :Make<CR>
"}}}
"--- REPL{{{
nmap s <Plug>ReplSend
vmap s <Plug>ReplSend
nmap ss <Plug>ReplSendLine
nmap <C-c><C-c> sap
"}}}
"--- Errors: Quickfix / Location Lists{{{
" Mnemonic:
"   (Q)uickfix
nnoremap Q :clist<CR>
nnoremap <C-Q> :cwindow<CR>
"}}}
"--- Preview{{{
" Preview word under cursor
nnoremap <C-SPACE> <C-W>}
" Preview selection
vnoremap <C-SPACE> y:ptag<C-R>"<CR>
" Close the preview window
nnoremap <C-W><SPACE> <C-W>z
nnoremap <C-W><C-SPACE> <C-W>z
" Complete tag
inoremap <C-SPACE> <C-X><C-]>
"}}}
"--- Cycling{{{
" Quickly cycling a list
" (currently Buffers)
nnoremap <C-P> :bprevious<CR>
nnoremap <C-N> :bnext<CR>
"}}}
"--- Toggle Settings{{{
" Exetending 'vim-unimpaired'
" T: s(T)atusbar
nnoremap <silent> [o_ :set ls=2<CR>
nnoremap <silent> ]o_ :set ls=0<CR>
nnoremap <expr> <silent> yo_ (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')
"}}}
"--- <LEADER>{{{
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
set wildcharm=<C-Z>

" Quick Keys
vnoremap <leader>= :Align<CR>
nnoremap <leader>! :!%:p<CR>
nnoremap <leader>x :Run<CR>
vnoremap <leader>x :Run<CR>
nnoremap <leader>X :%Run<CR>

" Switch buffers
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>
nnoremap <leader>t :tab sbuffer <C-Z>

" Edit Settings files
nnoremap <leader>ee :edit $MYVIMRC<CR>
nnoremap <leader>ef :EditFiletype<CR>
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
nnoremap d; :Dstatus<CR>
nnoremap d@ :Dremote<CR>
nnoremap d! :Dremote!<CR>
nnoremap du :Dupdate<CR>
nnoremap d< :Dprevious<CR>
nnoremap d> :Dnext<CR>
nnoremap d. :Dthis<CR>
nnoremap d, :Dpatch<CR>
nnoremap d~ :Dpatch!<CR>
nnoremap d" :Dcomment<CR>
nnoremap d& :Dcomment!<CR>
nnoremap dc :Dshowcomments<CR>
nnoremap dC :Dshowcomments!<CR>
"}}}

" vim:foldmethod=marker textwidth=0
