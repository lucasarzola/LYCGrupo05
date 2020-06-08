%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

	#define ERROR -1
	#define OK 1
  #define MAXINT 50
  #define MAXCAD 50

/* Tabla de simbolos */

struct datoTS {
	char *nombre;
	char *tipoDato;
	char *valor;
	char *longitud;
};

struct datoTS tablaDeSimbolos[100];
int cantFilasTS = 0;

//------------------ESTRUCUTURAS ----------------------------//
//Pila
	typedef struct
	{
    char* cadena;
		int nro;
	}t_info;

	typedef struct s_nodoPila{
    	t_info info;
    	struct s_nodoPila* sig;
	}t_nodoPila;

	typedef t_nodoPila *t_pila;

//Polaca
	typedef struct
	{
		char cadena[MAXINT];
		int nro;
	}t_infoPolaca;
  
  typedef struct s_nodoPolaca{
    	t_infoPolaca info;
    	struct s_nodoPolaca* psig;
	}t_nodoPolaca;

	typedef t_nodoPolaca *t_polaca;
	


//-----------------------------DEFINICION DE FUNCIONES-----------------------------------------//
	//Definición funciones de polaca
	int guardarPolaca(t_polaca*);
	int ponerEnPolacaPosicion(t_polaca*,int, char *);
	int ponerEnPolaca(t_polaca*, char *);
	void crearPolaca(t_polaca*);

  	//Definición funciones de pilas
	int vaciarPila(t_pila*);
	t_info* desapilar(t_pila*);
	void desapilar_str(t_pila*, char*);
  int desapilar_nro(t_pila *);
	void crearPila(t_pila*);
	int apilar(t_pila*,t_info*);
	t_info* verTopeDePila(t_pila*);
	int pilaVacia (const t_pila*);
	

	//internas del compilador
  void insertarTipoDatoEnTS(char*, char*);
	int insertarEnNuevaTS(char*,char*,char*,char*);
  int existeEnTS(char *);
  void guardarTS();
  int validarTipoDatoEnTS(char*, char*); 
  int ponerValorEnTS(char*, char*);
  void invertirComparador(char *);


	//Contadores
	int contIf=0;
	int contWhile=0;
  int contVar =0;
	//Posicion en polaca
	int posicionPolaca=0;
	char posPolaca[MAXCAD];

	//Notacion intermedia
	t_polaca polaca;
	t_pila pilaIf;
	t_pila pilaWhile;
  t_pila pilaIds;
  t_pila pilaFactorial;
  t_pila pilaCMP;
  t_pila pilaIfUnario;
  t_pila pilaIdsAsig;
  char tipoComparador[4];
  int contadorComparaciones = 0;
%}

%union {
int int_val;
double float_val;
char *str_val;
}


%type <str_val> id
%type <str_val> expresion
%type <str_val> termino
%type <str_val> factor
%type <str_val> sentencia
%type <str_val> GET
%type <str_val> DISPLAY
%type <str_val> asignacion
%type <str_val> lista_var
%type <int_val> cte_Entera
%type <str_val> cte_String
%type <float_val> cte_Real


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
               
%token <str_val>    ID                  
%token <str_val>    CTE_STRING          
%token <float_val>  CTE_REAL
%token <int_val>    CTE_ENTERA                
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
	PROGRAM est_declaracion bloque {printf(" 1\n");}
    ;

est_declaracion:
	DEFVAR declaraciones ENDDEF {printf(" 2\n");}
        ;

declaraciones:
            declaracion {printf(" 3\n");}
            |declaracion declaraciones  {}
      ;
declaracion:
            FLOAT COLON lista_var{
              
              t_info* tInfoADesapilar;

            printf("Cantidad de variables hasta FLOAT:  %d\n", contVar);

              int value =0;
              for(value;value<contVar;value++){
                     char floatIds[MAXCAD];
                     desapilar_str(&pilaIds,floatIds);
                    insertarTipoDatoEnTS(floatIds,"FLOAT");

                    printf("FLOAT %s\n",floatIds);
                  }

    contVar=0;
    }
            |STRING COLON lista_var{

              t_info* tInfoADesapilar;

            printf("Cantidad de variables hasta STRING:  %d\n", contVar);

              int value =0;
              for(value;value<contVar;value++){
                      char stringIds[MAXCAD];
                     desapilar_str(&pilaIds,stringIds);
                     insertarTipoDatoEnTS(stringIds,"STRING");

                      printf("STRING %s\n",stringIds);
                  }
              contVar=0;
    }
            |INT COLON lista_var
            {
              t_info* tInfoADesapilar;

            printf("Cantidad de variables hasta INT:  %d\n", contVar);

              int value =0;
              for(value;value<contVar;value++){
                     char intIds[MAXCAD];
                     desapilar_str(&pilaIds,intIds);
                     insertarTipoDatoEnTS(intIds,"INT");
                      printf("INT %s\n",intIds);
                  }

              contVar=0;
    }
            ;

lista_var:
          id              { 
                            contVar++;
                            }
          |id SEMICOLON lista_var {
                                      contVar++;}
          ;

bloque:
          sentencia   {printf(" 10\n");}
          |bloque sentencia {printf(" 11\n");}
          ;
sentencia:
          decision{printf("12\n");}
          |iteracion{printf("13\n");}
          |asignacion {printf("14\n");}
          |salida {printf(" 15\n");}
          |entrada {printf(" 16\n");}
          ;

decision: 
    	 IF P_A condicion P_C bloque ENDIF 
        { 
          printf("17\n");
          printf("llego hasta esta regla");
          int i;
          for(i=0; i<contadorComparaciones; i++)
          {
            int nro = desapilar_nro(&pilaCMP);
            printf("Valor de la pila %d",nro); 
            
            //char posPolaca[MAXCAD];
            //creo variable global para evitar escribirlo en todos lados
            sprintf(posPolaca,"%d",posicionPolaca+1);
            ponerEnPolacaPosicion(&polaca,nro,posPolaca);
          }
          contadorComparaciones = 0;
          printf("pase bloque");
        }

     |IF P_A condicion P_C bloque ELSE 
     {
        int i;
        for(i=0; i<contadorComparaciones; i++)
        {
          int nro = desapilar_nro(&pilaCMP);
          printf("Valor de la pila %d",nro); 
          
          //char posPolaca[MAXCAD];
          //creo variable global para evitar escribirlo en todos lados
          sprintf(posPolaca,"%d",posicionPolaca+2);
          ponerEnPolacaPosicion(&polaca,nro,posPolaca);
        }
        contadorComparaciones = 0;
        ponerEnPolaca(&polaca,"BI");
           t_info *tInfoIf=(t_info*) malloc(sizeof(t_info));
        if(!tInfoIf)
        {
          return;
        }
        tInfoIf->nro = posicionPolaca;
        apilar(&pilaIf,tInfoIf);
        ponerEnPolaca(&polaca,"");
        } 
     bloque {
        int nro = desapilar_nro(&pilaIf);
        printf("Valor de la pila %d",nro);   
        //char posPolaca[MAXCAD];
        //creo variable global para evitar escribirlo en todos lados
        sprintf(posPolaca,"%d",posicionPolaca);
        ponerEnPolacaPosicion(&polaca,nro,posPolaca);
      }
      ENDIF {printf("18\n");}	 
;

iteracion:
          WHILE{
            printf("WHILE\n");
            t_info info;
            info.cadena=(char*)malloc(sizeof(char)*MAXCAD);
            info.nro=contWhile++;
            sprintf(info.cadena,"#while_%d",info.nro);
            ponerEnPolaca(&polaca,info.cadena);
            sprintf(info.cadena,"#while_%d",info.nro);
            apilar(&pilaWhile,&info);
            //apilo la primer posicion
            t_info *tInfoWhile=(t_info*) malloc(sizeof(t_info));
            if(!tInfoWhile)
            {
                return;
            }
            tInfoWhile->nro = posicionPolaca;
            apilar(&pilaWhile,tInfoWhile);
          }
          P_A condicion P_C{
            //apilo la posicion actual, avanzo
            ponerEnPolaca(&polaca,"CMP");
            char ComparadorWhile[MAXCAD];
            desapilar_str(&pilaCMP,ComparadorWhile);
            ponerEnPolaca(&polaca,ComparadorWhile);
            
            t_info *tInfoWhile=(t_info*) malloc(sizeof(t_info));
            if(!tInfoWhile)
            {
                return;
            }
            tInfoWhile->nro = posicionPolaca;
            apilar(&pilaWhile,tInfoWhile);
            ponerEnPolaca(&polaca,"");
          }
          bloque{
            ponerEnPolaca(&polaca,"BI");
            int nro = desapilar_nro(&pilaWhile);
                 printf("Valor de la pila %d\n",nro); 
        
            char* posPolaca;
            sprintf(posPolaca,"%d",posicionPolaca+1);
            ponerEnPolacaPosicion(&polaca,nro,posPolaca);

            nro = desapilar_nro(&pilaWhile);

            char* posIteracion;
            sprintf(posIteracion,"%d",nro);
            ponerEnPolaca(&polaca,posIteracion);
           } ENDWHILE {printf("ENDWHILE     19\n");}
        ;

asignacion:
	    id 
      {
        t_info *tInfoPilaIdAsig=(t_info*) malloc(sizeof(t_info));
        tInfoPilaIdAsig->cadena = (char *) malloc (50 * sizeof (char));
        strcpy(tInfoPilaIdAsig->cadena,$1);
        apilar(&pilaIdsAsig,tInfoPilaIdAsig);
      }
      ASIGN expresion 
	    {
	      printf(" 20\n");
	      char strId[MAXCAD]; 
	      desapilar_str(&pilaIdsAsig, strId);
	      //printf("\nid asignacion desapilado: %s", strId);
	      ponerEnPolaca(&polaca, strId);
	      ponerEnPolaca(&polaca, "=");
	    }
      ;

ifunario:
        IF P_A condicion 
        {
          ponerEnPolaca(&polaca,"@r");
        }
        COMA expresion COMA 
        {
          //insertar(ASIGN);
          ponerEnPolaca(&polaca,"="); 
          //insertar(BI); 
          ponerEnPolaca(&polaca,"BI");
          int i;
          for(i=0; i<contadorComparaciones; i++)
          {
            //@x=desapilar(tope_de_pila);
            int nro = desapilar_nro(&pilaCMP);
            //insertar_en(@x, #celda_actual);
            sprintf(posPolaca,"%d",posicionPolaca+1);
            ponerEnPolacaPosicion(&polaca,nro,posPolaca);
          }
          contadorComparaciones = 0;
          //apilar(#celda_actual); 
          t_info *tInfoIfUnario=(t_info*) malloc(sizeof(t_info));
          if(!tInfoIfUnario)
          {
            return;
          }
          tInfoIfUnario->nro = posicionPolaca;
          apilar(&pilaIfUnario,tInfoIfUnario);
          //avanzar(); 
          ponerEnPolaca(&polaca,"");
          //insertar(@r);
          ponerEnPolaca(&polaca,"@r");
        }
        expresion P_C 
        {
          //insertar(ASIGN); 
          ponerEnPolaca(&polaca,"=");
          //@x=desapilar(tope_de_pila);
          int nro = desapilar_nro(&pilaIfUnario);
          //insertar_en(@x, #celda_actual); 
          sprintf(posPolaca,"%d",posicionPolaca);
          ponerEnPolacaPosicion(&polaca,nro,posPolaca);
          //insertar(@r);
          ponerEnPolaca(&polaca,"@r");
          printf(" 21\n");
        }
        ;

salida:
        DISPLAY id{

          char strId[MAXCAD]; 
	        desapilar_str(&pilaIds, strId);

          printf("22\n");
          ponerEnPolaca(&polaca,strId);
          printf("paso 22");
          ponerEnPolaca(&polaca,"DISPLAY");
        }
        |DISPLAY CTE_STRING{
          printf("23\n");
          printf("paso 23");
          ponerEnPolaca(&polaca,$2);
          ponerEnPolaca(&polaca,"DISPLAY");
        }
        ;

entrada:
      GET id{
        char strId[MAXCAD]; 
	      desapilar_str(&pilaIds, strId);

        printf("24\n");
        printf("paso 24");
        ponerEnPolaca(&polaca,strId);
        ponerEnPolaca(&polaca,"GET");
      }
      ;

condicion:
          comparacion
          {
            printf(" 25\n");
            ponerEnPolaca(&polaca, "CMP");
            //insertar(@cmp_type); 
            ponerEnPolaca(&polaca, tipoComparador);
            //apilar(#celda_actual); 
            t_info *tInfoPilaCmp=(t_info*) malloc(sizeof(t_info));
            if(!tInfoPilaCmp)
            {
              return;
            }
            tInfoPilaCmp->nro = posicionPolaca;
            apilar(&pilaCMP,tInfoPilaCmp);
            //avanzar(); 
            ponerEnPolaca(&polaca,"");
            contadorComparaciones = 1;
          }
          |comparacion AND 
          {
            //insertar(CMP); 
            ponerEnPolaca(&polaca, "CMP");
            //insertar(@cmp_type); 
            ponerEnPolaca(&polaca, tipoComparador);
            //apilar(#celda_actual); 
            t_info *tInfoPilaCmp=(t_info*) malloc(sizeof(t_info));
            if(!tInfoPilaCmp)
            {
              return;
            }
            tInfoPilaCmp->nro = posicionPolaca;
            apilar(&pilaCMP,tInfoPilaCmp);
            //avanzar(); 
            ponerEnPolaca(&polaca,"");
            contadorComparaciones++;
          }
          comparacion 
          {
            printf(" 26\n");
            //insertar(CMP); 
            ponerEnPolaca(&polaca, "CMP");
            //insertar(@cmp_type);
            ponerEnPolaca(&polaca, tipoComparador);
            //apilar(#celda_actual); 
            t_info *tInfoPilaCmp=(t_info*) malloc(sizeof(t_info));
            if(!tInfoPilaCmp)
            {
              return;
            }
            tInfoPilaCmp->nro = posicionPolaca;
            apilar(&pilaCMP,tInfoPilaCmp);
            //avanzar(); 
            ponerEnPolaca(&polaca,"");
            contadorComparaciones++;
          }
          |comparacion OR 
          {
            ponerEnPolaca(&polaca, "CMP");
            //si es con OR se deberia modificar el cmp apilado y cambiarlo por el contrario
            invertirComparador(tipoComparador);

                       
            ponerEnPolaca(&polaca, tipoComparador);
            t_info *tInfoPilaCmp=(t_info*) malloc(sizeof(t_info));
            if(!tInfoPilaCmp)
            {
              return;
            }
            tInfoPilaCmp->nro = posicionPolaca;
            apilar(&pilaCMP,tInfoPilaCmp);
            //avanzar(); 
            ponerEnPolaca(&polaca,"");
            contadorComparaciones++;
          }
          comparacion 
          {
            //insertar(CMP); 
            ponerEnPolaca(&polaca, "CMP");
            //insertar(@cmp_type);
            ponerEnPolaca(&polaca, tipoComparador);
            //apilar(#celda_actual); 
            t_info *tInfoPilaCmp=(t_info*) malloc(sizeof(t_info));
            if(!tInfoPilaCmp)
            {
              return;
            }
            tInfoPilaCmp->nro = posicionPolaca;
            apilar(&pilaCMP,tInfoPilaCmp);
            //avanzar(); 
            ponerEnPolaca(&polaca,"");
            contadorComparaciones++;
            printf(" 27\n");
          }
        |NOT comparacion {
            ponerEnPolaca(&polaca, "CMP");
            //si es con OR se deberia modificar el cmp apilado y cambiarlo por el contrario
            invertirComparador(tipoComparador);
                       
            ponerEnPolaca(&polaca, tipoComparador);
            t_info *tInfoPilaCmp=(t_info*) malloc(sizeof(t_info));
            if(!tInfoPilaCmp)
            {
              return;
            }
            tInfoPilaCmp->nro = posicionPolaca;
            apilar(&pilaCMP,tInfoPilaCmp);
            //avanzar(); 
            ponerEnPolaca(&polaca,"");
            contadorComparaciones++;
            printf(" 28\n");
        }
		;

comparacion:
          expresion comparador expresion {printf(" 29\n");}
	      |P_A expresion comparador expresion P_C {printf(" 30\n");}
		  ;
        
comparador:
          MAYEQ 
          {
            printf(" 31\n");
            strcpy(tipoComparador,"BLT");
          }
          |MINEQ 
          {
            printf(" 32\n");
            strcpy(tipoComparador,"BGT");
          }
          |MIN 
          {
            printf(" 33\n");
            strcpy(tipoComparador,"BGE");
          }
          |MAY {
            printf(" 34\n");
            strcpy(tipoComparador,"BLE");
          }
          |EQUAL 
          {
            printf(" 35\n");
            strcpy(tipoComparador,"BNE");
          }
	  |NOTEQUAL 
          {
            printf(" 36\n");
            strcpy(tipoComparador,"BEQ");
          }
		  ;

expresion:
		termino  {printf(" 37\n");}
	     |expresion OPSUM termino {
         printf(" 38\n");
         ponerEnPolaca(&polaca,"+");
         }
         |expresion OPRES termino {
           printf(" 39\n");
           ponerEnPolaca(&polaca,"-");
           }
         |factorial {printf(" 40\n");
                 
                 }
         |combinatoria {printf(" 41\n");}
         |ifunario {printf(" 42\n");}
		 ;

termino: 
       factor                   {printf("43\n");}
	   |termino OPDIV factor    {
                                
        printf("44\n");
        ponerEnPolaca(&polaca,"/");
                                
            }
       |termino OPMUL factor    {
                                
        printf("45\n");
        ponerEnPolaca(&polaca,"*");
            }			   
       ;

factor:
      id     {
               
                printf("46\n");
                ponerEnPolaca(&polaca,$1);
                
              }
      | cte_Entera              {
        
        printf("47\n");
      char arrayEntera[MAXCAD];
      sprintf(arrayEntera,"%d\0",$1);
      ponerEnPolaca(&polaca,arrayEntera);


         }
      | cte_Real                {

        printf("48\n");
      char arrayReal[MAXCAD];
        sprintf(arrayReal,"%f",$1);
      ponerEnPolaca(&polaca,arrayReal);

      }
      | cte_String              {
        printf("49\n");
      ponerEnPolaca(&polaca,$1);
      }
      ;

factorial:
      FACT P_A {

        insertarEnNuevaTS("_@res","","","");
        ponerEnPolaca(&polaca,"@res");

        } expresion P_C   {

        ponerEnPolaca(&polaca,"=");

        insertarEnNuevaTS("_@fact","","","");
        ponerEnPolaca(&polaca,"@fact");

        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"=");        
        
        //Apilar posicion del res para While e insertar Res
        t_info *tInfoFactorial=(t_info*) malloc(sizeof(t_info));
        if(!tInfoFactorial)
        {
          return;
        }
        tInfoFactorial->nro = posicionPolaca;
        apilar(&pilaFactorial,tInfoFactorial);
        
        ponerEnPolaca(&polaca,"@res");
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"CMP");
        ponerEnPolaca(&polaca,"BLI");
        
        //Apilar posicion del while actual y avanzar
        tInfoFactorial=(t_info*) malloc(sizeof(t_info));
        if(!tInfoFactorial)
        {
          return;
        }
        tInfoFactorial->nro = posicionPolaca;
        apilar(&pilaFactorial,tInfoFactorial);
        ponerEnPolaca(&polaca,"");

        ponerEnPolaca(&polaca,"@fact"); 
        ponerEnPolaca(&polaca,"@fact");
        ponerEnPolaca(&polaca,"@res");
        ponerEnPolaca(&polaca,"*");
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,"@res");
        ponerEnPolaca(&polaca,"@res");
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"-");
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,"BI");
        
        int nro = desapilar_nro(&pilaFactorial);
                 printf("Valor de la pila %d",nro); 
        
        char posPolacaFact[MAXCAD];
        sprintf(posPolacaFact,"%d",posicionPolaca);
        ponerEnPolacaPosicion(&polaca,nro,posPolacaFact);

         nro = desapilar_nro(&pilaFactorial);

         char posIteracion[MAXCAD];
         sprintf(posIteracion,"%d",nro);
         ponerEnPolaca(&polaca,posIteracion);
        }
      ;

combinatoria:
      COMB P_A {
        
        insertarEnNuevaTS("_@res1","","","");
        ponerEnPolaca(&polaca,"@res1");
        
        } expresion {
        ponerEnPolaca(&polaca,"="); 
        ponerEnPolaca(&polaca,"F1"); 
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"=");
        }
        COMA { 
          
          insertarEnNuevaTS("_@res2","","","");
          ponerEnPolaca(&polaca,"@res2"); 
          
          }  expresion 
        {
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,"F2");
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"=");
        
        insertarEnNuevaTS("_@res3","","","");
        ponerEnPolaca(&polaca,"@res3");

        ponerEnPolaca(&polaca,"@res1");
        ponerEnPolaca(&polaca,"@res2");
        ponerEnPolaca(&polaca,"-");
        ponerEnPolaca(&polaca,"=");

        hacerFactoriales();

        ponerEnPolaca(&polaca,"@res3");
        
        insertarEnNuevaTS("_@F1","","","");
        ponerEnPolaca(&polaca,"@F1");

        insertarEnNuevaTS("_@F2","","","");
        ponerEnPolaca(&polaca,"@F2");

        insertarEnNuevaTS("_@F3","","","");
        ponerEnPolaca(&polaca,"@F3");
        ponerEnPolaca(&polaca,"*");
        ponerEnPolaca(&polaca,"/");
        ponerEnPolaca(&polaca,"=");

        }

        P_C 
      ;


id: ID {
   t_info *tInfoPilaId=(t_info*) malloc(sizeof(t_info));
    
    tInfoPilaId->cadena = (char *) malloc (MAXCAD * sizeof (char));
    strcpy(tInfoPilaId->cadena,$1);
    
    apilar(&pilaIds,tInfoPilaId);

};

cte_Entera: CTE_ENTERA {
  };

cte_Real: CTE_REAL {
  };
;

cte_String: CTE_STRING {
  };

%%


int main(int argc,char *argv[])
{ 
  char cadena[] = "ID";
  int value = 0;
  //fprintf(archTabla,"%s\n","NOMBRE\t\t\tTIPODATO\t\tVALOR");
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
  crearPila(&pilaIds);
  crearPila(&pilaFactorial);
	crearPolaca(&polaca);
  crearPila(&pilaCMP);
	yyparse();
  }
  guardarPolaca(&polaca);
  
  printf("Validando tipo de dato: %d",validarTipoDatoEnTS("a1","STRING"));
  mostrarTS();
  guardarTS();
  fclose(yyin);

  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }


//-----------------------------------Funciones tabla de simbolos---------------------------------------&&
 mostrarTS(){
    int i=0;
    for(i; i<cantFilasTS;i++)
    { 
     printf("Verificando: %s\t\t\t%s\t\t\t%s\t\t\t\n",tablaDeSimbolos[i].nombre,tablaDeSimbolos[i].tipoDato,tablaDeSimbolos[i].valor);
    }
    return 0;
  }


int existeEnTS(char *nombre){
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);
    
    int i=0;
    for(i; i<cantFilasTS;i++)
    { 
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        return 1;
      }
    }
    return 0;
  }

    insertarEnNuevaTS(char* nombre, char* tipoDato, char* valor, char* longitud){
    struct datoTS dato;

	  dato.nombre = nombre;
	  dato.tipoDato = tipoDato;
	  dato.valor = valor;
	  dato.longitud = longitud;
	  tablaDeSimbolos[cantFilasTS] = dato;
	  
    cantFilasTS++; 
      
  }

void insertarTipoDatoEnTS(char* nombre, char* tipoDato){
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;
    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        tablaDeSimbolos[i].tipoDato = tipoDato;
        return;
      }
    }
    printf("Error! No existe la variable en la tabla de simbolos");	  
    return;
  }

int validarTipoDatoEnTS(char* nombre, char* tipoDato){
    
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;

    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        if(strcmpi(tipoDato,tablaDeSimbolos[i].tipoDato) == 0)
        {
          return OK;
        }
        else{
          printf("\nError! La variable %s es de tipo %s y no coinciden los tipos asignados\n",nombreVariable,tablaDeSimbolos[i].tipoDato);
          return ERROR;
          }
      }
    }
    printf("\nError! No existe la variable en la tabla de simbolos");	  
    return ERROR;
  }

  int ponerValorEnTS(char* nombre, char* nuevoValor){
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;

    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        tablaDeSimbolos[i].valor = nuevoValor;
      }
    }
    printf("\nError! No existe la variable en la tabla de simbolos");	  
    return ERROR;
  }


  void guardarTS()
{
	FILE *file = fopen("ts.txt", "w+");
	
	if(file == NULL) 
	{
    	printf("\nERROR: No se pudo abrir el txt correspondiente a la tabla de simbolos\n");
	}
	else 
	{
		int i = 0;
		for (i; i < cantFilasTS; i++) 
		{
			fprintf(file, "%s\t\t%s\t\t%s\t\t%s\n", tablaDeSimbolos[i].nombre, tablaDeSimbolos[i].tipoDato, tablaDeSimbolos[i].valor, tablaDeSimbolos[i].longitud);
		}		
		fclose(file);
	}
}
//------------------------------------Funciones de Pila----------------------------------------------------//

void crearPila(t_pila* p){
		*p=NULL;
}

int vaciarPila(t_pila* p)
{
    t_nodoPila *aux;
    if(*p==NULL)
        return(0);
   while(*p)
   {
    aux=*p;
    *p=(*p)->sig;
    free(aux);}
    return(1);
}

int apilar(t_pila* p,t_info* d)
{   
	t_nodoPila *nue=(t_nodoPila*) malloc(sizeof(t_nodoPila));
    
    if(nue==NULL)
        return(0);

    nue->info=*d;

    nue->sig=*p;

    *p=nue;

    return(1);
}

t_info* desapilar(t_pila *p)
{   
		t_nodoPila *aux;

	if(*p==NULL)
        return(0);

	  aux=*p;
	  t_info *infoDePila;
    
	  *infoDePila = (*p)->info;    

    *p=(*p)->sig;

    free(aux);

	return (infoDePila);
}

int desapilar_nro(t_pila *p)
{   
		t_nodoPila *aux;

	if(*p==NULL)
        return(0);

	  aux=*p;

	  int nro;
    
	  nro = (*p)->info.nro;    

    *p=(*p)->sig;

    free(aux);

	return (nro);
}

void desapilar_str(t_pila *p, char* str)
{   
	t_nodoPila *aux;
	if(*p==NULL)
        return;

	  aux=*p;

	  strcpy(str,(*p)->info.cadena);   

    *p=(*p)->sig;

    free(aux);
}

t_info* verTopeDePila(t_pila* p)
{   if(*p==NULL)
    return(0); 

	  t_info* info;

    *info =(*p)->info;

    return(info);
}

int pilaVacia (const t_pila* p)
{
    return *p==NULL;
}


//------------------------------------Funciones de Polaca----------------------------------------------------//
//Creamos la polaca
void crearPolaca(t_polaca* p){
  *p=NULL;
  return;
}

//Ponemos en polaca el nodo a lo último, con su respectiva cadena y hacemos que apunte a null su siguiente
int ponerEnPolaca(t_polaca* p, char *cadena)
	{
	  t_nodoPolaca* nue = (t_nodoPolaca*)malloc(sizeof(t_nodoPolaca));
	      if(!nue){
	          return ERROR;
	      }

		  t_nodoPolaca* aux;
	      
		  //Asignamos la cadena al nodo
		  strcpy(nue->info.cadena,cadena);
		  //Ponemos la posicion en la polaca
		  nue->info.nro=posicionPolaca++;
		  //Hacemos que sea el último nodo en la lista de polaca
	      nue->psig=NULL;
	      
		while(*p)
    		{
       		 p=&(*p)->psig;
    		}
		*p=nue;


		return OK;
	}

int ponerEnPolacaPosicion(t_polaca* p,int pos, char *cadena){
		t_nodoPolaca* aux;
		
		aux=*p;
		
	    while(aux!=NULL && aux->info.nro != pos){
	    	aux=aux->psig;
	    }
	    
		if(aux->info.nro==pos){
	    	strcpy(aux->info.cadena,cadena);
	    	return OK;
	    }

	    return ERROR;
}

int guardarPolaca(t_polaca *p){
		FILE*pf=fopen("intermedia.txt","w+");
		
		if(!pf){
			//No se creó el archivo de intermedia en el main
			return ERROR;
		}

		t_nodoPolaca* nodoActual;

		while(*p)
	    {
	        nodoActual=*p;

	        fprintf(pf, "%s %d\n",nodoActual->info.cadena, nodoActual->info.nro);
	        
			*p=(*p)->psig;
	        
			free(nodoActual);
	    }
		fclose(pf);
	}

//----------------------------------------------------------------------------------------------------------//
hacerFactoriales(){
  int cicloActual = 1;
  for(cicloActual;cicloActual<=3;cicloActual++){
  //Apilar posicion del res para While e insertar Res
        t_info *tInfoFactorial=(t_info*) malloc(sizeof(t_info));
        if(!tInfoFactorial)
        {
          return;
        }
        tInfoFactorial->nro = posicionPolaca;
        apilar(&pilaFactorial,tInfoFactorial);
        
        char resActual[MAXCAD];

        sprintf(resActual,"@res%d",cicloActual);
        ponerEnPolaca(&polaca,resActual);
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"CMP");
        ponerEnPolaca(&polaca,"BLI");
        
        //Apilar posicion del while actual y avanzar
        tInfoFactorial=(t_info*) malloc(sizeof(t_info));
        if(!tInfoFactorial)
        {
          return;
        }
        tInfoFactorial->nro = posicionPolaca;
        apilar(&pilaFactorial,tInfoFactorial);
        ponerEnPolaca(&polaca,"");


        char factActual[MAXCAD];
        sprintf(factActual,"@F%d",cicloActual);
        ponerEnPolaca(&polaca,factActual); 
        ponerEnPolaca(&polaca,factActual);
        ponerEnPolaca(&polaca,resActual);
        ponerEnPolaca(&polaca,"*");
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,resActual);
        ponerEnPolaca(&polaca,resActual);
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"-");
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,"BI");
        
        int nro = desapilar_nro(&pilaFactorial);
        
        char posPolacaActual[MAXCAD];
        sprintf(posPolacaActual,"%d",posicionPolaca+1);

        ponerEnPolacaPosicion(&polaca,nro,posPolacaActual);

         nro = desapilar_nro(&pilaFactorial);

         char posIteracion[MAXCAD];
         sprintf(posIteracion,"%d",nro);
         ponerEnPolaca(&polaca,posIteracion);
  }
}

  void invertirComparador(char *comparadorEntrada) 
  {
    if(strcmpi(comparadorEntrada,"BEQ")==0)
    {
      strcpy(comparadorEntrada,"BNE");
      
    }
    if(strcmpi(comparadorEntrada,"BNE")==0)
    {
      strcpy(comparadorEntrada,"BEQ");
      
    }
    if(strcmpi(comparadorEntrada,"BLT")==0)
    {
      strcpy(comparadorEntrada,"BGE");
      
    }
    if(strcmpi(comparadorEntrada,"BGT")==0)
    {
      strcpy(comparadorEntrada,"BLE");
      
    }
    if(strcmpi(comparadorEntrada,"BGE")==0)
    {
      strcpy(comparadorEntrada,"BLT");
      
    }
    if(strcmpi(comparadorEntrada,"BLE")==0)
    {
      strcpy(comparadorEntrada,"BGT");
      
    }
  }







