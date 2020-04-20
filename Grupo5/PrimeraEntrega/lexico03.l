%{
#include <stdio.h>
#include <stdlib.h>
%}

FLOAT               "FLOAT"|"float"
INT                 "INT"|"int"
STRING              "STRING"|"string"
MIN                 "<"
MAY                 ">"

FACT                "FACT"
COMB                "COMB"
DEFVAR              "DEFVAR"
ENDDEF              "ENDDEF"
IF                  "IF"|"if"
OR                  "OR"|"or"
WHILE               "WHILE"|"while"
ELSE                "ELSE"|"else"
ELSEIF              "ELSEIF"|"elseif"
ENDIF               "ENDIF"|"endif"
ASIGN               ":="
OPSUM               "+"
OPRES               "-"
OPMUL               [\*]
OPDIV               [\/]
DIGITO              [0-9]
ENTERO              {DIGITO}+
LETRA               [a-zA-Z]
ID                  {LETRA}({LETRA}|{DIGITO}|_)*
DELIM               [ \t\r]

CARACTER_ESPECIAL   [=|>|<|:|\+|-|\*|/|\?|¿|!|¡|\(|\)|@|%|#|&|°|´|\^|`|~|/|\\|-|_|\.|,|;|¬|\|]
PALABRA             ({LETRA}|{DIGITO})+
INI_COM             [\*]{3}[\/]
FIN_COM             [\/][\*]{3}
COMENTARIO          {INI_COM}{VALID_STRING}{FIN_COM}

VALID_STRING        ({PALABRA}|{DELIM}|{CARACTER_ESPECIAL})+
CTE_STRING          \"{VALID_STRING}\"
CTE_REAL            ([0-9]*\.[0-9]+)|([0-9]+\.[0-9]*)




%%
{MAY}               {printf("\nTOKEN = May ");ECHO;}
{MIN}               {printf("\nTOKEN = Min ");ECHO;}
{FLOAT}             {printf("\nTOKEN = Float ");ECHO;}
{INT}               {printf("\nTOKEN = Int ");ECHO;}
{STRING}            {printf("\nTOKEN = String ");ECHO;}
{DEFVAR}            {printf("\nTOKEN = End var ");ECHO;}
{ENDDEF}            {printf("\nTOKEN = End Def ");ECHO;}
{FACT}              {printf("\nTOKEN = Fact ");ECHO;}
{COMB}              {printf("\nTOKEN = COMB ");ECHO;}
{IF}                {printf("\nTOKEN = If ");ECHO;}
{OR}                {printf("\nTOKEN = Or ");ECHO;}
{WHILE}             {printf("\nTOKEN = While ");ECHO;}
{OPSUM}             {printf("\nTOKEN = Op Suma ");ECHO;}
{OPRES}             {printf("\nTOKEN = Op Resta ");ECHO;}
{OPMUL}             {printf("\nTOKEN = Op Multiplicacion ");ECHO;}
{OPDIV}             {printf("\nTOKEN = Op DIvision ");ECHO;}
{ASIGN}             {printf("\nTOKEN = Op Asignacion ");ECHO;}
{DIGITO}            {printf("\nTOKEN = Digito ");ECHO;}
{ENTERO}            {printf("\nTOKEN = Entero ");ECHO;}
{LETRA}             {printf("\nTOKEN = Letra ");ECHO;}
{DELIM}             {printf("\nTOKEN = Delim ");ECHO;}
{ID}                {printf("\nTOKEN = Id ");ECHO;}
{CARACTER_ESPECIAL} {printf("\nTOKEN = Carac esp ");ECHO;}
{COMENTARIO}        {printf("\nTOKEN = Comentario ");ECHO;}
{CTE_STRING}        {printf("\nTOKEN = Cte String ");ECHO;}
{CTE_REAL}          {printf("\nTOKEN = Real ");ECHO;}
%%

main(){
    yylex();
    printf("\nFinalizo el analisis\n");
}