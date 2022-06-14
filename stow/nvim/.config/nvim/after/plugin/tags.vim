" Upward search from current file, then 'tags' in the working directory
" -> files dir (./xyz)
" -> upwards from file (./xyz;)
" -> cwd (xyz)
" -> upwards from cwd (xyz;)
" plain tags -> .git/tags
function s:tags()
    set tags =./tags,./tags;,tags,tags;
endfunction

function s:lib_tags(remove)
    let cmd = 'set tags'..(a:remove ? '-' : '+')..'='
    execute cmd..'./tags.lib,./tags.lib;,tags.lib,tags.lib;'
endfunction

command -bang TagLibs call s:lib_tags(<bang>0)
command TagReset call s:tags()

command -bang TagToc call tags#toc(<bang>0)
cnoreabbrev <expr> tt    (getcmdtype() ==# ':' && getcmdline() ==# 'tt') ? 'TagToc' : 'tt'

" Activate
TagReset
