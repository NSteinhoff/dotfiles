" Prefer Omni-completion over tag completion
inoremap <buffer> <C-SPACE> <C-X><C-O>

if exists(':DD')
    setlocal keywordprg=:DD
endif
