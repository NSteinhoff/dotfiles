function surround#change(before, after)
    execute 'normal di'..a:before
    normal vhPgv
    execute 'normal c'..a:after..a:after
    normal P
endfunction

nnoremap <Plug>(surround-change-s2d) <cmd>call surround#change("'", '"')<cr>
nnoremap <Plug>(surround-change-s2b) <cmd>call surround#change("'", '`')<cr>
nnoremap <Plug>(surround-change-d2s) <cmd>call surround#change('"', "'")<cr>
nnoremap <Plug>(surround-change-d2b) <cmd>call surround#change('"', '`')<cr>
nnoremap <Plug>(surround-change-b2s) <cmd>call surround#change('`', "'")<cr>
nnoremap <Plug>(surround-change-b2d) <cmd>call surround#change('`', '"')<cr>
