%{
#include <stdio.h>
#include <stdlib.h>

%}


DIGITO				[0-9]
ENTERO				{DIGITO}+
REAL				{ENTERO}\.{ENTERO}
LETRA				[a-zA-Z]
DELIM           	[ \t\r]
INI_COM				[\/\*{3}]
FIN_COM				[\*{3}\/]
COMENTARIO 			{INI_COM}{VALID_STRING}{FIN_COM}
CARACTER_ESPECIAL   [=|>|<|:|\+|-|\*|/|\?|¿|!|¡|\(|\)|@|%|#|&|°|´|\^|`|~|/|\\|-|_|\.|,|;|¬|\|]
PALABRA				({LETRA}|{DIGITO})+
VALID_STRING    	({PALABRA}|{DELIM}|{CARACTER_ESPECIAL})+




%%

{DIGITO} {printf("\nTOKEN = Digito ");ECHO;}
{ENTERO} {printf("\nTOKEN = Entero ");ECHO;}
{REAL} {printf("\nTOKEN = Real ");ECHO;}
{LETRA} {printf("\nTOKEN = Letra ");ECHO;}
{DELIM} {printf("\nTOKEN = Delim ");ECHO;}
{COMENTARIO} {printf("\nTOKEN = Comentario ");ECHO;}
{CARACTER_ESPECIAL} {printf("\nTOKEN = Caracter Especial ");ECHO;}
{PALABRA} {printf("\nTOKEN = Palabra ");ECHO;}
{VALID_STRING} {printf("\nTOKEN = Valid String ");ECHO;}



%%


main(){
	yylex();
	printf("\nFinalizo el analisis\n");
}
