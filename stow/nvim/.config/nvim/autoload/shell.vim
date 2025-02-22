function! shell#create_range_edit_command(name, cmd, require_range = v:false)
    let cmd = a:name

    if a:require_range
        let cmd .= printf(" if <range> < 2 || <line1> == <line2> | echo 'Command :%s needs a range. Abort!' | else | ", a:name)
    endif

    let cmd .= printf(" execute '<line1>,<line2>w !xargs '..(<bang>0 ? 'echo ' : ' ')..'%s <args>'", a:cmd)

    if a:require_range
        let cmd .= " | endif"
    endif

    execute "command! -buffer -range -bang -nargs=* "..cmd

    call abbrev#cmdline(tolower(a:name), a:name, {'buffer': v:true, 'range': v:true})
endfunction

function! shell#create_commands()
    call shell#create_range_edit_command('Mv',    'mv', v:true)
    call shell#create_range_edit_command('Cp',    'cp', v:true)
    call shell#create_range_edit_command('Rm',    'rm')
    call shell#create_range_edit_command('Mkdir', 'mkdir')
    call shell#create_range_edit_command('Touch', 'touch')

    command! -buffer -nargs=+ -range Xargs <line1>,<line2>w !xargs <args>
    call abbrev#cmdline('xargs', 'Xargs', {'buffer': v:true, 'range': v:true})
endfunction
