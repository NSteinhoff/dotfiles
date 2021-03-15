if exists("current_compiler")
  finish
endif
let current_compiler = "pandoc-letter"

set mp=pandoc\ --template\ $HOME/dev/dotfiles/3rd/pandoc-letter/letter.latex\ %\ -o\ %:r.pdf
