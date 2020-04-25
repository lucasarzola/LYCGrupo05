%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
FILE  *yyin;
int yylval;
%}
%option noyywrap  
%option yylineno 


DISPLAY             "DISPLAY"
GET                 "GET"
SEMICOLON           ";"
PROGRAM             "PROGRAM"
ENDPROGRAM          "ENDPROGRAM"
FLOAT               "FLOAT"|"float"
INT                 "INT"|"int"
STRING              "STRING"|"string"
OPTER               "?"
P_A                 "("
P_C                 ")"
COLON                ":"
MAY                 ">"
MIN                 "<"
MAYEQ               ">="
MINEQ               "<="
EQUAL               "=="
COMA		        ","
FACT                "FACT"
COMB                "COMB"
DEFVAR              "DEFVAR"
ENDDEF              "ENDDEF"
IF                  "IF"|"if"
OR                  "OR"|"or"
WHILE               "WHILE"|"while"
ENDWHILE	        "ENDWHILE"|"endwhile"
AND		            "AND"|"and"
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
CTE_ENTERA          {DIGITO}+



%%
{P_A}               {return P_A;}
{P_C}               {return P_C;}
{SEMICOLON}         {return SEMICOLON;}
{COLON}             {return COLON;}
{DISPLAY}           {return DISPLAY;}
{GET}               {return GET;}
{PROGRAM}           {return PROGRAM;}
{ENDPROGRAM}        {return ENDPROGRAM;}
{COMA}		        {return COMA;}
{MAYEQ}             {return MAYEQ;}
{MINEQ}             {return MINEQ;}
{EQUAL}             {return EQUAL;}
{MAY}               {return MAY;}
{MIN}               {return MIN;}
{FLOAT}             {return FLOAT;}
{INT}               {return INT;}
{STRING}            {return STRING;}
{DEFVAR}            {return DEFVAR;}
{ENDDEF}            {return ENDDEF;}
{FACT}              {return FACT;}
{COMB}              {return COMB;}
{IF}                {return IF;}
{ELSE}              {return ELSE;}
{ELSEIF}	        {return ELSEIF;}
{ENDIF}		        {return ENDIF;}
{AND}		        {return AND;}
{OR}                {return OR;}
{WHILE}             {return WHILE;}
{ENDWHILE}	        {return ENDWHILE;}
{OPSUM}             {return OPSUM;}
{OPRES}             {return OPRES;}
{OPMUL}             {return OPMUL;}
{OPDIV}             {return OPDIV;}
{ASIGN}             {return ASIGN;}
{ENTERO}            {return ENTERO;}
{LETRA}             {return LETRA;}
{ID}                {return ID;}
{COMENTARIO}        {ECHO;}
{CTE_STRING}        {return CTE_STRING;}
{CTE_REAL}          {return CTE_REAL;}
{CTE_ENTERA}        {return CTE_ENTERA;}
%%
