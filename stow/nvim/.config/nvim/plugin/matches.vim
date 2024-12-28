command! -bang -nargs=? Match if <bang>0 |match |else|execute 'match  Error /'..(empty(<q-args>) ? '\<'..expand('<cword>')..'\>' : escape(<q-args>, '/')).'/'|endif
command! -bang -nargs=? Match2 if <bang>0|2match|else|execute '2match Todo  /'..(empty(<q-args>) ? '\<'..expand('<cword>')..'\>' : escape(<q-args>, '/')).'/'|endif
command! MatchOff match | 2match
