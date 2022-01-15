if !get(g:, 'neovide', 0) | finish | endif
set guifont=Iosevka\ Nerd\ Font\ Mono:h16

" Fullscreen seeems to cause neovide to hang on startup
" let g:neovide_fullscreen=v:true
let g:neovide_hide_mouse_when_typing=v:true

packadd tokyonight.nvim
colorscheme tokyonight

packadd nvim-scrollview
let g:scrollview_winblend=75
let g:scrollview_current_only=1

nnoremap <leader>F <cmd>let g:neovide_fullscreen = !g:neovide_fullscreen<cr>
