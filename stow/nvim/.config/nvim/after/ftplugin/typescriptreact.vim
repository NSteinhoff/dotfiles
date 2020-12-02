source <sfile>:h/typescript.vim

if exists(':DD')
    setlocal keywordprg=:DD
endif

let reload=0

if !exists('*s:to_kebab') || reload
    function s:to_kebab(camel)
        return substitute(substitute(a:camel, '^\u', '\l\0', 'e'), '\(\u\)', '-\l\1', 'ge')
    endfunction
endif

if !exists('*s:new_component') || reload
    function s:new_component(name, range, line1, line2) abort
        let path = expand('%:h').'/'
        let name = a:name

        let lines = []
        call add(lines, "import React from 'react';")
        call add(lines, "")
        call add(lines, "export interface ".name."Props {}")
        call add(lines, "")
        call add(lines, "export function ".name."({}: ".name."Props): JSX.Element {")
        if a:range
            call add(lines, "    return (")
            call extend(lines, getbufline("%", a:line1, a:line2))
            call add(lines, "    );")
        endif
        call add(lines, "}")

        execute 'edit '.path.s:to_kebab(name).'.tsx'
        call append(0, lines)
        write
        edit
    endfunction
endif

command! -buffer -range -nargs=1 NewReactComponent call s:new_component(<q-args>, <range>, <line1>, <line2>)
