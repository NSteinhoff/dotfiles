source <sfile>:h/typescript.vim

function s:is_start_of_line()
    let line = getline('.')
    return line =~ '^\w\+\s\?$'
endfunction

function s:props()
    if !s:is_start_of_line()
        return 'expr'
    else
        return 'export interface '.(s:component_name()).'Props {}'
    endif
endfunction

function s:component_name()
    let lines = getline('.', '$')
    let component = 0
    for line in lines
        let component = matchstr(line, '^export\sfunction\s\zs\u\w\+\ze():')
        if component != ''
            return component
        endif
    endfor
    return 'MyComponent'
endfunction

iabbrev <buffer> excp export function SomeComponent(): JSX.Element {}
iabbrev <buffer> <expr> expr <sid>props()

nnoremap <buffer> gO <cmd>TagToc ! C<cr>
