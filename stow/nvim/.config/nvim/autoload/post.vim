" Read curl request from buffer and place output below.
"
" Examples:
"
" // Comments an leading empty lines get ignored
" // 
"
" -XGET http://some-host/some-path?param1=one&param2=two
" -H 'Accept: application/json'
"
" ---
"
" -XGET https://some-host.org/path
"  ?param1=one
"  &param2=two
" -H 'Accept: application/json'
"
" ---
"
" -XPOST https://some-host.org/path
" -d '{"one": 1, "two": 2}'
" -H 'Accept: application/json'
"
function post#post()
    let buf = bufname()
    echo "Posting from buffer "..buf

    let lnum = 1
    while getline(lnum) =~ "^// " | let lnum += 1 | endwhile
    while getline(lnum) =~ "^$" | let lnum += 1 | endwhile
    let req_start = lnum
    while getline(lnum) !~ "^$" | let lnum += 1 | endwhile
    let req_end  = lnum

    if (req_end == req_start)
        echo "No request found in "..buf
        return
    endif

    let request = getline(req_start, req_end - 1)
    let request = filter(request, 'v:val !~ "^// "')
    let request = map(request, 'trim(v:val)')
    let request = join(request, " ")
    let request = substitute(request, '\s\([&?=]\)', '\1', 'g')                   " Remove whitespace between URL segments
    let request = substitute(request, '\s\(http.\{-}\)\(\s\|$\)', ' ''\1'' ', '') " Wrap URL in single quotes

    if request !~ '^curl'
        let request = 'curl --silent --fail-with-body --show-error '..request
    endif

    let is_json = request =~ 'Accept: application/json'
    echo printf("Request%s:\n%s", is_json ? "(JSON)" : "", request)

    let separator_lines = ["", "---", ""]
    call deletebufline(buf, req_end, '$')
    call append(req_end - 1, separator_lines)
    let response_start = req_end + len(separator_lines) - 1

    let response = systemlist(request)
    if v:shell_error || !is_json
        call append(response_start, response)
        return
    endif

    echo "Formatting JSON Response"
    let jq_command = printf("jq --monochrome-output --indent %d %s", shiftwidth(), "'.'")
    let formatted = systemlist(jq_command, response)
    if v:shell_error
        call extend(formatted, ["", "---", ""])
        call extend(formatted, response)
    endif

    call append(response_start, formatted)
endfunction
