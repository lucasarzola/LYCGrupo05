%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
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
%token IF
%token ELSE
%token ELSEIF
%token ENDIF
%token AND
%token OR
%token NOT
%token WHILE               
%token ENDWHILE          
%token OPSUM                 
%token OPRES              
%token OPMUL               
%token OPDIV               
%token ASIGN                 
%token ENTERO              
%token LETRA                 
%token ID                    
%token CTE_STRING          
%token CTE_REAL
%token CTE_ENTERA                
%token P_A
%token P_C
%token MINEQ
%token MAYEQ
%token EQUAL
%token NOTEQUAL
%token FACT
%token COMB
%token ASIGNID

%%
programa:  	   
	PROGRAM {printf("Inicia COMPILADOR\n");} est_declaracion bloque{printf(" Fin COMPILADOR ok\n");} 
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
          decision
          |iteracion{printf("Iteracion\n");}
          |asignacion {printf("Asignacion\n");}
          |salida
          |entrada
          ;

decision: 
    	 IF P_A condicion P_C bloque ENDIF{printf("Termina if\n");}
	    | IF P_A condicion P_C bloque ELSE bloque ENDIF {printf("Termina if con ELSE\n");}	 
;

iteracion:
          WHILE {printf("Comienza while\n");} P_A condicion P_C bloque ENDWHILE {printf("Termina while\n");}
        ;

asignacion:
            ID ASIGN expresion
        ;

ifunario:
        IF P_A condicion COMA expresion COMA expresion P_C {printf(" If Unario\n");}
        ;

salida:
        DISPLAY ID{printf("Display id\n");}
        |DISPLAY CTE_STRING{printf("Display cte_string\n");}
        ;

entrada:
      GET ID{printf("Get ID\n");}
      ;

condicion:
          comparacion{printf(" Comparacion\n");}
          |condicion AND comparacion
          |condicion OR comparacion
	  |NOT comparacion
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
		  |NOTEQUAL
      ;

expresion:
         termino
	   |expresion OPSUM termino
         |expresion OPRES termino
         |factorial
         |combinatoria
         |ifunario
 	 ;

termino: 
       factor
       |termino OPDIV factor
       |termino OPMUL factor
       ;

factor: 
      ID 
      | CTE_ENTERA 
      | CTE_REAL 
      | CTE_STRING 
      ;

factorial:
      FACT P_A expresion P_C {printf(" Factorial\n");}
      ;

combinatoria:
      COMB P_A expresion COMA expresion P_C {printf(" Combinatoria\n");}
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
	 

int insertarEnTS(char nombreSimbolo[],char tipoSimbolo[],char valorString[],int valorInteger, double valorFloat){
  FILE *archTS2 = fopen("ts.txt","r");
  char simboloTS[100];
  char valor[20];
  char valorCte[20];
  char valorBuscado[20];
  char linea[100];
  char separador[] = "\t\t\t";
  char *pos;
  int longitud;
  int band = 0;
  int i = 0;
  if(strcmp(tipoSimbolo,"ID") != 0){
    if(strcmp(tipoSimbolo,"CTE_ENTERA") == 0){
      sprintf(valor,"%d",valorInteger);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);

      strcpy(simboloTS,"_");
      strcat(simboloTS,valor);
      strcat(simboloTS,"\t\t\t");
      strcat(simboloTS,"CteInt");
      strcat(simboloTS,"\t\t\t");
      strcat(simboloTS,valor);
    }
    if(strcmp(tipoSimbolo,"CTE_REAL") == 0){
      sprintf(valor,"%.3f",valorFloat);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);

      strcpy(simboloTS,"_");
      strcat(simboloTS,valor);
      strcat(simboloTS,"\t\t\t");
      strcat(simboloTS,"CteReal");
      strcat(simboloTS,"\t\t\t");
      strcat(simboloTS,valor);
    }
    if(strcmp(tipoSimbolo,"CTE_STRING") == 0){
      sprintf(valor,"%s",nombreSimbolo);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);

      strcpy(simboloTS,"_");
      strcat(simboloTS,nombreSimbolo);
      strcat(simboloTS,"\t\t\t");
      strcat(simboloTS,"CteStr");
      strcat(simboloTS,"\t\t");
      strcat(simboloTS,valorString);
    }
  }else{
    strcpy(simboloTS,nombreSimbolo);
    strcat(simboloTS,"\t\t\t");
    strcat(simboloTS,tipoSimbolo);
    strcat(simboloTS,"\t\t\t");
    strcat(simboloTS,valorString);
  }
  strcat(simboloTS,"\t\t\t");
  strcat(simboloTS,"--");

  //Lee línea a línea y escribe en pantalla hasta el fin de fichero
  rewind(archTS2);
  do {
	  pos = fgets(linea,100,archTS2);
	  strcpy(valorBuscado,simboloTS);
	  strcat(valorBuscado,"\n");
	  if(strcmp(valorBuscado,linea) == 0){
		  band = 1;
	  }
	  i++;
  }while(pos != NULL && band == 0);
  fclose(archTS2);
  archTS2 = fopen("ts.txt","a");
  if(band == 0){
    fprintf(archTS2,"%s\n",simboloTS);
  }
  fclose(archTS2);
}