set define=^\\s*\\(def\\\|class\\)

let s:pipenv_location = trim(system('pipenv --venv'))
if v:shell_error == 0
    let s:lib_location = s:pipenv_location . '/lib'
    let s:packages_location =  finddir('python3.7', s:lib_location) . '/site-packages/'
else
    let s:packages_location = '/usr/lib/python3/dist-packages/'
endif
let &l:path.= ',' . s:packages_location
