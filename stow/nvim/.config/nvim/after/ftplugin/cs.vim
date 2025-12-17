let b:interpreter = 'dotnet run %'

if findfile('Makefile') == ""
    compiler dotnet
endif

iabbrev <buffer> //// //////////////////////////////////////////////////<NL>
