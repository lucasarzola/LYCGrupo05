%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
%}

%token PROGRAM
%token ENDPROGRAM
%token COMA
%token MAY
%token MIN
%token FLOAT
%token INT
%token STRING
%token DEFVAR
%token ENDDEF
%token FACT
%token COMB
%token IF
%token ELSEIF
%token ENDIF
%token AND
%token OR
%token WHILE               
%token ENDWHILE          
%token OPSUM                 
%token OPRES              
%token OPMUL               
%token OPDIV               
%token ASIGN                 
%token DIGITO                
%token ENTERO              
%token LETRA                 
%token DELIM                 
%token ID                    
%token CARACTER_ESPECIAL             
%token CTE_STRING          
%token CTE_REAL
%token MAYEQ
%token MINEQ
%token EQUAL
%token OPTER
%token THEN

%%
programa:  	   
	PROGRAM {printf(" Inicia COMPILADOR\n");} est_declaracion {printf(" Fin COMPILADOR ok\n");}
    ;

est_declaracion:
	DEFVAR {printf("     DECLARACIONES\n");} expresion ENDDEF {printf(" Fin de las Declaraciones\n");}
        ;

declaraciones:         	        	
             declaracion
             |declaraciones declaracion
    	     ;

declaracion:
            FLOAT lista_var
            |STRING lista_var
            |INT lista_var
            ;

lista_var:
          ID
          |ID COMA lista_var
          ;

expresion: 
          expresion OPTER expresion THEN expresion
          |expresion ASIGN condicion
          |condicion
          |expresion OPSUM termino 
          |expresion OPRES termino 
          |termino
          ;
condicion:
          comparacion
          |condicion AND comparacion
          |condicion OR comparacion
;
comparacion:
            expresion comparador expresion
        ;
        
comparador:
          ASIGN
          |MAYEQ
          |MINEQ
          |MIN
          |MAY
          |EQUAL
      ;

termino: termino OPMUL factor
        |termino OPDIV factor
        |factor
        ;

factor: expresion
        |ID
        |DIGITO
        ;

%%
int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }


