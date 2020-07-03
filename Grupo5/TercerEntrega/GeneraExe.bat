c:\GnuWin32\bin\flex Lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Grupo5.exe
pause
Grupo5.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h

pause
