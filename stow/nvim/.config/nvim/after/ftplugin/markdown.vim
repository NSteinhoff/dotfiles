setlocal textwidth=0
setlocal shiftwidth=2
setlocal formatoptions=tcroqlj
setlocal wrap
setlocal spell
setlocal suffixesadd=.md

setlocal keywordprg=:Search\ devdocs\ markdown

function! s:render_html(open)
    !pandoc --standalone --self-contained --from=markdown --to=html --output /tmp/%:t:r.html %
    if a:open
      Open /tmp/%:t:r.html
    endif
endfunction

if executable('pandoc')
    command -buffer -bang RenderHTML silent call s:render_html(<bang>0)
endif
