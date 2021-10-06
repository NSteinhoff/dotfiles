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

" I've set up a git hook that get's installed for all repositories that
" creates tags files on git actions that change the index (commits,
" checkouts, merges, etc.). This file lives in the .git/ directory.
set tags+=./.git/tags
set tags+=./.git/tags;
set tags+=.git/tags
set tags+=.git/tags;

function s:lib_tags(remove)
    let cmd = 'set tags'..(a:remove ? '-' : '+')..'='
    execute cmd..'./git/tags.lib'
    execute cmd..'./git/tags.lib;'
    execute cmd..'.git/tags.lib'
    execute cmd..'.git/tags.lib;'
endfunction

command -bang LibTags call s:lib_tags(<bang>0)

LibTags
