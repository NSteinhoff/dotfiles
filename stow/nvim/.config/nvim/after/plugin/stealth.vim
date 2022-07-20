command! Stealth call stealth#on()
command! NoStealth call stealth#off()
command! StealthToggle call stealth#toggle()

augroup stealth
    autocmd!
    " Update the match for the current buffer's commentstring
    autocmd BufEnter * call stealth#update()
augroup END
