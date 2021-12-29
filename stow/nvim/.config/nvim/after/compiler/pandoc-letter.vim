if exists("current_compiler")
  finish
endif
let current_compiler = "pandoc-letter"

set makeprg=pandoc\ --template\ $HOME/dotfiles/3rd/pandoc-letter/letter.latex\ %\ -o\ %:r.pdf
