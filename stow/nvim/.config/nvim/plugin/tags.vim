" Set 'tags' option
function s:tags()
    set tags=
    " next to file
    set tags+=./tags
    " upwards from file
    set tags+=./tags;
    " in CWD
    set tags+=tags
    " in parent directories
    set tags+=tags;
endfunction

function s:lib_tags(remove)
    let cmd = 'set tags'..(a:remove ? '-' : '+')..'='
    execute cmd..'./tags.lib,./tags.lib;,tags.lib,tags.lib;'
endfunction

command -bang TagLibs call s:lib_tags(<bang>0)
command TagReset call s:tags()

command -bang -nargs=* TagToc call tags#toc(<bang>0, <f-args>)
command -bang -nargs=* Outline call tags#toc(<bang>0, <f-args>)

call abbrev#cmdline('out', 'Outline')
call abbrev#cmdline('tt', 'TagToc')
call abbrev#cmdline('ctags', 'Ctags')

" Activate
TagReset
