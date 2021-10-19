" Upward search from current file, then 'tags' in the working directory
" -> files dir (./xyz)
" -> upwards from file (./xyz;)
" -> cwd (xyz)
" -> upwards from cwd (xyz;)
" plain tags -> .git/tags
set tags =./tags
set tags+=./tags;
set tags+=tags
set tags+=tags;

function s:lib_tags(remove)
    let cmd = 'set tags'..(a:remove ? '-' : '+')..'='
    execute cmd..'./tags.lib'
    execute cmd..'./tags.lib;'
    execute cmd..'tags.lib'
    execute cmd..'tags.lib;'
endfunction

command -bang LibTags call s:lib_tags(<bang>0)

LibTags
