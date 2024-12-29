command -bang PackList call packer#printpacks(<bang>0)
command -nargs=1 -complete=customlist,packer#completenames PackOpen call packer#openpack(<f-args>)
