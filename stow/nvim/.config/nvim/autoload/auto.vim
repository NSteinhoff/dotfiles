function auto#blink_crosshair(timer_id = -1)
    if (a:timer_id == -1)
        set cursorline cursorcolumn
        call timer_start(300, 'auto#blink_crosshair', {})
    else
        set cursorline& cursorcolumn&
    endif
endfunction
