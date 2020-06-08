%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#define TOPE_ENTERO 65536
#define TOPE_REAL 4294967296
FILE  *yyin;  
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
COLON               ":"
MAY                 ">"
MIN                 "<"
MAYEQ               ">="
MINEQ               "<="
EQUAL               "=="
NOTEQUAL			"!="
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
NOT					"NOT"|"not"
ELSE                "ELSE"|"else"
ELSEIF              "ELSEIF"|"elseif"
ENDIF               "ENDIF"|"endif"
ASIGN               "="
OPSUM               "+"
OPRES               "-"
OPMUL               [\*]
OPDIV               [\/]
DIGITO              [0-9]
LETRA               [a-zA-Z]
ID                  {LETRA}({LETRA}|{DIGITO}|_)*
DELIM               [ \t\r]

CARACTER_ESPECIAL   [=|>|<|:|\+|-|\*|/|\?|¿|!|¡|\(|\)|@|%|#|&|°|´|\^|`|~|/|\\|-|_|\.|,|;|¬|\|á|é|í|ó|ú|ü|\']
PALABRA             ({LETRA}|{DIGITO})+
INI_COM             [\*]{3}[\/]
FIN_COM             [\/][\*]{3}
COMENTARIO          {INI_COM}({VALID_STRING}|\")*{FIN_COM}

VALID_STRING        ({PALABRA}|{DELIM}|{CARACTER_ESPECIAL})+
CTE_STRING          \"{VALID_STRING}\"
CTE_REAL            ([0-9]*\.[0-9]+)|([0-9]+\.[0-9]*)
CTE_ENTERA          {DIGITO}+
CUALQUIER_DIGITO    ({CARACTER_ESPECIAL})*|({LETRA}|{DIGITO})*


%%
{COMENTARIO}
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
{NOTEQUAL}			{return NOTEQUAL;}
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
{NOT}				{return NOT;}
{WHILE}             {return WHILE;}
{ENDWHILE}	        {return ENDWHILE;}
{OPSUM}             {return OPSUM;}
{OPRES}             {return OPRES;}
{OPMUL}             {return OPMUL;}
{OPDIV}             {return OPDIV;}
{ASIGN}             {return ASIGN;}

{ID}                {yylval.str_val = yytext; 
									char *nombreId = (char*) malloc(sizeof(yytext)+1);
									sprintf(nombreId,"_%s",yylval.str_val);

									if(existeEnTS(yytext)==0)
									insertarEnNuevaTS(nombreId,"","","");

									return ID;
									}       
{CTE_STRING}        { 			yylval.str_val = strdup(yytext);
								if(strlen(yytext) <= 30) {
									char *longitudString = (char*) malloc(sizeof(yytext)+1);
									char *nombreString = (char*) malloc(sizeof(yytext)+1);
  									sprintf(nombreString,"_%s",yytext);
									sprintf(longitudString,"%d",strlen(yytext));
									if(existeEnTS(yytext)==0)
  									insertarEnNuevaTS(nombreString,"Cte_String",yylval.str_val,longitudString); 
									
									printf("Texto capturado: %s",yytext);

										return CTE_STRING;
								} else {
										printf("ERROR - Constante string muy larga. Maximo 30 caracteres\n");
										system ("Pause");
										exit(3);
								}
                    }	
{CTE_REAL}          { 			yylval.float_val = atof(yytext);
								if(atof(yytext) <= TOPE_REAL){

									char *valorReal = (char*) malloc(sizeof(yytext));
  									char *nombreReal = (char*) malloc(sizeof(yytext)+1);
 									sprintf(valorReal,"%f",atof(yytext));
  									sprintf(nombreReal,"_%s",valorReal);

									if(existeEnTS(yytext)==0)
  									insertarEnNuevaTS(nombreReal,"Cte_Real",valorReal,""); 


									return CTE_REAL; 
								}else{
									printf("ERROR - Float fuera de rango.\n");
									system ("Pause");
									exit(2);
							}
						}
{CTE_ENTERA}        {  yylval.int_val = atoi(yytext);
							if(atoi(yytext) <= TOPE_ENTERO){
								  char *valorEntero = (char*) malloc(sizeof(yytext));
  									char *nombreEntero = (char*) malloc(sizeof(yytext)+1);
 									 sprintf(valorEntero,"%d",atoi(yytext));
  									sprintf(nombreEntero,"_%s",valorEntero);

									if(existeEnTS(yytext)==0)
  									insertarEnNuevaTS(nombreEntero,"Cte_Entera",valorEntero,""); 
									
									return CTE_ENTERA; 
							}else{
									printf("ERROR - Int fuera de rango.\n");
									system ("Pause");
									exit(1);
							}}
{CUALQUIER_DIGITO}			{printf("Se detecto un digito erroneo: %s", yytext);
									system ("Pause");
									exit(1);
									};
%%
