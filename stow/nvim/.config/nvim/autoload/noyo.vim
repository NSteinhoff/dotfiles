let s:noyo_on = 0
let s:save_opts = {}

let s:set_opts = {}
let s:set_opts.number = 0
let s:set_opts.laststatus = 0
let s:set_opts.showtabline = 0
let s:set_opts.signcolumn = "no"
let s:set_opts.showcmd = 0
let s:set_opts.ruler = 0
let s:set_opts.list = 0

function noyo#toggle(bang)
    if a:bang && !s:noyo_on|return|endif

    for [opt, value] in items(s:set_opts)
        if s:noyo_on
            let newvalue = s:save_opts[opt]
        else
            let s:save_opts[opt] = eval('&'..opt)
            let newvalue = value
        endif
        execute printf("let &%s='%s'", opt, newvalue)
    endfor
    let s:noyo_on = !s:noyo_on
    if s:noyo_on
        echo "  noyo"
    else
        echo "nonoyo"
    endif
endfunction
