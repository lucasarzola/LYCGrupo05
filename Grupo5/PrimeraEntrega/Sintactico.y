%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
%}

%token COLON
%token DISPLAY
%token GET
%token SEMICOLON
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
%token ELSE
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
%token ID                    
%token CTE_STRING          
%token CTE_REAL
%token P_A
%token P_C
%token MINEQ
%token MAYEQ
%token EQUAL

%%
programa:  	   
	PROGRAM {printf("Inicia COMPILADOR\n");} est_declaracion bloque condicion{printf(" Fin COMPILADOR ok\n");} 
    ;

est_declaracion:
	DEFVAR {printf("DECLARACIONES\n");} declaraciones ENDDEF {printf(" Fin de las Declaraciones\n");}
        ;

declaraciones:
            declaracion
            |declaracion declaraciones
      ;
declaracion:
            FLOAT COLON lista_var{printf("Float\n");}
            |STRING COLON lista_var{printf("String\n");}
            |INT COLON lista_var{printf("Int\n");}
            ;

lista_var:
          ID
          |ID SEMICOLON lista_var
          ;

bloque:
          sentencia
          |bloque sentencia
          ;
sentencia:
          decision {printf("Decision\n");}
          |iteracion{printf("Iteracion\n");}
          |asignacion {printf("Asignacion\n");}
          |salida
          |entrada
          ;

decision: 
    	 IF P_A P_C bloque ENDIF{printf("     IF\n");}
	    | IF P_A P_C bloque ELSE bloque ENDIF {printf("     IF con ELSE\n");}	 
;

iteracion:
          WHILE {printf("Comienza while\n");} P_A P_C bloque ENDWHILE {printf("Termina while\n");}
        ;

asignacion:
        ID ASIGN ID
        |ID ASIGN CTE_STRING
        |ID ASIGN CTE_REAL
        ;

salida:
        DISPLAY ID{printf("Display id\n");}
        |DISPLAY CTE_STRING{printf("Display cte_string\n");}
        ;

entrada:
      GET ID{printf("Get ID\n");}
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
          MAYEQ
          |MINEQ
          |MIN
          |MAY
          |EQUAL
      ;

expresion:
         termino
	 |expresion OPSUM termino
         |expresion OPRES termino
 	 ;

termino: 
       factor
       |termino OPDIV factor
       |termino OPMUL factor
       ;

factor: 
      ID 
      ;
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


