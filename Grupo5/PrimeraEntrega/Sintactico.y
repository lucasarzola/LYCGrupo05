%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
int insertarEnTS(char[],char[],char[],int,double);
%}

%union {
int int_val;
double float_val;
char *str_val;
}

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
          decision{printf("Decision\n");}
          |iteracion{printf("Iteracion\n");}
          |asignacion {printf("Asignacion\n");}
          |salida
          |entrada
          ;

decision: 
    	 IF P_A condicion P_C bloque ENDIF{printf("Termina if\n");}
	    |IF P_A condicion P_C bloque ELSE bloque ENDIF {printf("Termina if con ELSE\n");}	 
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
          |comparacion AND comparacion
          |comparacion OR comparacion
	      |NOT comparacion
		;

comparacion:
          expresion comparador expresion
	      |P_A expresion comparador expresion P_C
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
  FILE *archTabla = fopen("ts.txt","a");
  fprintf(archTabla,"%s\n","NOMBRE\t\tTIPODATO\tVALOR");
  fclose(archTabla);

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
	 

int insertarEnTS(char nombreToken[],char tipoToken[],char valorString[],int valorInteger, double valorFloat){
  
  FILE *tablaSimbolos = fopen("ts.txt","r");
  char simboloNuevo[200];
  int repetido = 0;
  int i = 0;

  char valor[20];
  char valorCte[20];
  char lineaComparada[20];
  char linea[200];
  
  //Si el tipo de símbolo no es ID
  if(strcmp(tipoToken,"ID") != 0){
    //Chequea si el tipo de simbolo es entero
    if(strcmp(tipoToken,"CTE_ENTERA") == 0){
      sprintf(valor,"%d",valorInteger);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);

      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,valor);
      strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,"Ent");
      strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,valor);
    }

    //Chequea si es real
    if(strcmp(tipoToken,"CTE_REAL") == 0){
      sprintf(valor,"%.3f",valorFloat);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);

      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,valor);
      strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,"Real");
      strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,valor);
    }

    //Chequea si es string
    if(strcmp(tipoToken,"CTE_STRING") == 0){
      sprintf(valor,"%s",nombreToken);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);

      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,nombreToken);
      strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,"String");
      strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,valorString);
    }
  }else{
    strcpy(simboloNuevo,nombreToken);
    strcat(simboloNuevo,"\t\t");
    strcat(simboloNuevo,tipoToken);
    strcat(simboloNuevo,"\t\t");
    strcat(simboloNuevo,valorString);
  }

  //Vuelve a posición 0
  rewind(tablaSimbolos);

  char *pos;
//Compara linea a linea si hay repetidos
  do {
	  pos = fgets(linea,200,tablaSimbolos);
	  strcpy(lineaComparada,simboloNuevo);
	  strcat(lineaComparada,"\n");
	  if(strcmp(lineaComparada,linea) == 0){
		  repetido = 1;
	  }
	  i++;
  }while(pos != NULL && repetido == 0);

  fclose(tablaSimbolos);

//Si no es un símbolo repetido, lo graba
  tablaSimbolos = fopen("ts.txt","a");
  if(repetido == 0){
    fprintf(tablaSimbolos,"%s\n",simboloNuevo);
  }

  fclose(tablaSimbolos);
}