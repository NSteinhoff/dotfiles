function options#toggle(name, on = 1, off = 0)
    let on = s:to_string(a:on)
    let off = s:to_string(a:off)
    execute printf('let &%s = &%s == %s ? %s : %s', a:name, a:name, off, on, off)
    execute 'set '..a:name..'?'
endfunction

function s:to_string(v)
    if type(a:v) == v:t_string 
        return printf("'%s'", a:v) 
    elseif type(a:v) == v:t_number
        return printf("%d", a:v)
    elseif type(a:v) == v:t_list
        return printf("'%s'", join(a:v, ','))
    else
        return printf("%s", a:v)
    endif
endfunction
