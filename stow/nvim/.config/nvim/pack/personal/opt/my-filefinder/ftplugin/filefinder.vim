setlocal buftype=nofile nobuflisted noswapfile
setlocal errorformat=%f

let b:selected = 0
let b:num_results = 0

command -buffer Cancel keepalt b#

nnoremap <buffer> <cr> <cmd>call filefinder#open()<cr>
vnoremap <buffer> <silent> <cr> :call filefinder#open()<cr>
nnoremap <buffer> I 1GI
nnoremap <buffer> A 1GA
nnoremap <buffer> <bs> <cmd>Cancel<cr>
inoremap <buffer> <c-c> <esc><cmd>Cancel<cr>

inoremap <buffer> <space> .*
inoremap <buffer> <cr> <esc><cmd>call filefinder#open_selected()<cr>
inoremap <buffer> <c-n> <cmd>call filefinder#move_selection(1)<cr>
inoremap <buffer> <c-p> <cmd>call filefinder#move_selection(-1)<cr>
