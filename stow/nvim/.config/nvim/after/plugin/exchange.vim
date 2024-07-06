" one two three
let s:ns = nvim_create_namespace("my-exchange")

function s:save()
    let [b, l, c, o] = getpos("'[")
    let [bb, ll, cc, oo] = getpos("']")
    let [c1, c2] = c < cc ? [c-1, cc-1] : [cc-1, c-1]
    let opts = {'id': 1, 'end_col': c2}
    call nvim_buf_set_extmark(0, s:ns, l - 1, c1, opts)
endfunction

function s:apply()
    let [l, c, details] = nvim_buf_get_extmark_by_id(0, s:ns, 1, {'details': v:true})
    let [l, c1, c2] = [l + 1, c + 1, details.end_col + 1]
    call setpos("'<", [0, l, c1, 0])
    call setpos("'>", [0, l, c2, 0])
    normal gv
endfunction

function s:exchange()
    call s:save()
    normal p
    call s:apply()
    normal p
endfunction

vnoremap <plug>(exchange) <cmd>call <SID>exchange()<cr>
