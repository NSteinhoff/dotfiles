function s:edit_settings(type, selected, mods, after = v:false)
    let defaults = {
    \   'compiler': get(b:, 'current_compiler', get(g:, 'current_compiler', '')),
    \   'colors': get(g:, 'colors_name'),
    \   'plugin': '',
    \}
    let selected = empty(a:selected) ? get(defaults, a:type, &ft) : a:selected
    let selected = empty(selected) ? selected : selected..'.vim'
    let basepath = ' $HOME/.config/nvim/'..(a:after ? 'after/' : '')..a:type..'/'

    exe a:mods..(a:mods =~ 'vert\|tab' ? ' split' : ' edit')..basepath..selected
endfunction

command! -nargs=? -complete=compiler EditCompiler call s:edit_settings('compiler', <q-args>, <q-mods>, v:true)
command! -nargs=? -complete=filetype EditFtplugin call s:edit_settings('ftplugin', <q-args>, <q-mods>, v:true)
command! -nargs=? -complete=filetype EditSyntax call s:edit_settings('syntax', <q-args>, <q-mods>, v:true)
command! -nargs=? -complete=filetype EditIndent call s:edit_settings('indent', <q-args>, <q-mods>, v:true)
command! -nargs=? -complete=color EditColorscheme call s:edit_settings('colors', <q-args>, <q-mods>)
command! -nargs=? -complete=customlist,editsettings#complete_plugins EditPlugin call s:edit_settings('plugin', <q-args>, <q-mods>)
command! -nargs=? -complete=customlist,editsettings#complete_plugins EditAutoload call s:edit_settings('autoload', <q-args>, <q-mods>)
