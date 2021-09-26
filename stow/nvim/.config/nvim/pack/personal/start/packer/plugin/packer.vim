set packpath+=~/dev/dotfiles/3rd

command -bang PackList call packer#printpacks(<bang>0)
command -nargs=1 -complete=customlist,packer#completenames PackLocate echo packer#locatepack(<f-args>)
command -nargs=1 -complete=customlist,packer#completenames PackOpen call packer#openpack(<f-args>)
command -nargs=1 -complete=customlist,packer#completefiles PackEdit edit <args>
command -nargs=1 -complete=customlist,packer#completefiles PackFind call packer#findfile(<f-args>)
