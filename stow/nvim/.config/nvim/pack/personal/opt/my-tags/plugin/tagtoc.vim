command -bang TagToc call tags#toc(<bang>0)
cnoreabbrev <expr> tt    (getcmdtype() ==# ':' && getcmdline() ==# 'tt') ? 'TagToc' : 'tt'
