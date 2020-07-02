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
    char* tipoDeDato;
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
  char* tieneTipoDatoEnTS(char* nombre);

  //assembler
  void generarAssembler(t_polaca*);


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
  t_pila pilaTipoDato;
  char tipoComparador[4];
  int contadorComparaciones = 0;
  int saltoOR=0;
  int condicion_or=0;
  int resActual = 1;
  int resExpFactActual = 1;
  char resPrimExpComb[MAXCAD] ="@resExp1";
  char resSegExpComb[MAXCAD] ="@resExp2";
  char resTercExpComb[MAXCAD] ="@resExp3";
  char resExpFact[MAXCAD] ="@resFact1";
  char resComb[MAXCAD] = "@resComb1";

  //Assembler
  t_pila pilaIdsASM;
  int auxiliaresASM = 0;


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
	PROGRAM est_declaracion bloque {printf("Regla 1, Fin programa\n");}
    ;

est_declaracion:
	DEFVAR {printf("Inicio declaraciones\n");} declaraciones ENDDEF {printf("Regla 2, Fin declaraciones\n");}
        ;

declaraciones:
            declaracion {printf("Regla 3\n");}
            |declaracion declaraciones  {printf("Regla 4\n");}
      ;
declaracion:
            FLOAT COLON lista_var{
              
              t_info* tInfoADesapilar;
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
          sentencia   {printf(" Regla 10\n");}
          |bloque sentencia {printf(" Regla 11\n");}
          ;
sentencia:
          decision{printf("Regla 12: fin decision\n");}
          |iteracion{printf("Regla 13: fin iteracion\n");}
          |asignacion {printf("Regla 14: fin asignacion\n");}
          |salida {printf("Regla 15: fin salida\n");}
          |entrada {printf("Regla 16: fin entrada\n");}
          ;

decision: 
    	 IF P_A condicion P_C bloque ENDIF 
        { 
          printf("17\n");
          int i, nro;
          for(i=0; i<contadorComparaciones; i++)
          {
            nro = desapilar_nro(&pilaCMP);

            sprintf(posPolaca,"%d",posicionPolaca);
            ponerEnPolacaPosicion(&polaca,nro,posPolaca);
          }
	      if(condicion_or == 1){
            char posPolaca[MAXCAD];
            sprintf(posPolaca,"%d",saltoOR);
            ponerEnPolacaPosicion(&polaca,nro,posPolaca);
            condicion_or = 0;
          }
          contadorComparaciones = 0;
        }

     |IF P_A condicion P_C bloque ELSE 
     {
        int i;
        int nro;
        for(i=0; i<contadorComparaciones; i++)
        {
          nro = desapilar_nro(&pilaCMP);
          
          //char posPolaca[MAXCAD];
          //creo variable global para evitar escribirlo en todos lados
          sprintf(posPolaca,"%d",posicionPolaca+2);
          ponerEnPolacaPosicion(&polaca,nro,posPolaca);
        }
	if(condicion_or == 1){
           char posPolaca[MAXCAD];
           sprintf(posPolaca,"%d",saltoOR);
           ponerEnPolacaPosicion(&polaca,nro,posPolaca);
           condicion_or = 0;
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
        //char posPolaca[MAXCAD];
        //creo variable global para evitar escribirlo en todos lados
        sprintf(posPolaca,"%d",posicionPolaca);
        ponerEnPolacaPosicion(&polaca,nro,posPolaca);
      }
      ENDIF {printf("18\n");}	 
;

iteracion:
          WHILE{
            printf("Empieza WHILE\n");
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
          P_A condicion P_C
          bloque{
            ponerEnPolaca(&polaca,"BI");
            int i, nro;
            for(i=0; i<contadorComparaciones; i++)
            {
              nro = desapilar_nro(&pilaCMP);
        
              char posPolaca[MAXCAD];
              sprintf(posPolaca,"%d",posicionPolaca+1);
              ponerEnPolacaPosicion(&polaca,nro,posPolaca);
            }
	    if(condicion_or == 1){
              char posPolaca[MAXCAD];
              sprintf(posPolaca,"%d",saltoOR);
              ponerEnPolacaPosicion(&polaca,nro,posPolaca);
              condicion_or = 0;
            }

            nro = desapilar_nro(&pilaWhile);

            char posIteracion[MAXCAD];
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
	      t_info  *tInfoTipoDato;
        
              printf("Regla 20\n");
	      char strId[MAXCAD];
              char tipoDeDato[MAXCAD]; 
	      desapilar_str(&pilaIdsAsig, strId);
        
              desapilar_str(&pilaTipoDato,tipoDeDato);
              // printf("Validando tipo de dato: %d, de la variable %s",validarTipoDatoEnTS(strId,tipoDeDato),strId);
              if(validarTipoDatoEnTS(strId,tipoDeDato)  != OK)
              {
                //printf("Tipo de dato del id : %s invalido: %s\n",strId,tipoDeDato);
                return;
              }
	      //printf("\nid asignacion desapilado: %s", strId);
	      ponerEnPolaca(&polaca, strId);
	      ponerEnPolaca(&polaca, "=");
	    }
      ;

ifunario:
        IF P_A condicion 
        {
	  if(existeEnTS("@resIfUn")==0)
          insertarEnNuevaTS("_@resIfUn","","","");
          ponerEnPolaca(&polaca,"@r");
        }
        COMA expresion COMA 
        {
          //insertar(ASIGN);
          ponerEnPolaca(&polaca,"="); 
          //insertar(BI); 
          ponerEnPolaca(&polaca,"BI");
          int i, nro;
          for(i=0; i<contadorComparaciones; i++)
          {
            //@x=desapilar(tope_de_pila);
            nro = desapilar_nro(&pilaCMP);
            //insertar_en(@x, #celda_actual);
            sprintf(posPolaca,"%d",posicionPolaca+1);
            ponerEnPolacaPosicion(&polaca,nro,posPolaca);
          }
	          if(condicion_or == 1){
              char posPolaca[MAXCAD];
              sprintf(posPolaca,"%d",saltoOR);
              ponerEnPolacaPosicion(&polaca,nro,posPolaca);
              condicion_or = 0;
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

          char tipoDatoId[MAXCAD];
                strcpy(tipoDatoId,tieneTipoDatoEnTS(strId)); 
                if(strcmpi(tipoDatoId,"") == 0){
                  printf("ERROR: El id %s no tiene tipo de dato ni fue declarado\n",strId);
                  system ("Pause");
										exit(3);
                  return;
                }

          printf("Regla 22\n");
          ponerEnPolaca(&polaca,strId);
          ponerEnPolaca(&polaca,"DISPLAY");
        }
        |DISPLAY CTE_STRING{
          printf("Regla 23\n");
          ponerEnPolaca(&polaca,$2);
          ponerEnPolaca(&polaca,"DISPLAY");
        }
        ;

entrada:
      GET id{
        char strId[MAXCAD]; 
	      desapilar_str(&pilaIds, strId);

        char tipoDatoId[MAXCAD];
                strcpy(tipoDatoId,tieneTipoDatoEnTS(strId)); 
                if(strcmpi(tipoDatoId,"") == 0){
                  printf("ERROR: El id %s no tiene tipo de dato ni fue declarado\n",strId);
                  system ("Pause");
										exit(3);
                  return;
                }

        printf("Regla 24\n");
        ponerEnPolaca(&polaca,strId);
        ponerEnPolaca(&polaca,"GET");
      }
      ;

condicion:
          comparacion
          {
            printf("Regla 25\n");
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
            printf("Regla 26\n");
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
	    saltoOR= posicionPolaca;
            condicion_or=1;
            printf("Posicion de salto del OR%d\n",saltoOR); 
            printf("Regla 27\n");
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
          expresion comparador expresion {printf("Regla 29\n");}
	      |P_A expresion comparador expresion P_C {printf("Regla 30\n");}
		  ;
        
comparador:
          MAYEQ 
          {
            printf("Regla 31\n");
            strcpy(tipoComparador,"BLT");
          }
          |MINEQ 
          {
            printf("Regla 32\n");
            strcpy(tipoComparador,"BGT");
          }
          |MIN 
          {
            printf("Regla 33\n");
            strcpy(tipoComparador,"BGE");
          }
          |MAY {
            printf("Regla 34\n");
            strcpy(tipoComparador,"BLE");
          }
          |EQUAL 
          {
            printf("Regla 35\n");
            strcpy(tipoComparador,"BNE");
          }
	  |NOTEQUAL 
          {
            printf("Regla 36\n");
            strcpy(tipoComparador,"BEQ");
          }
		  ;

expresion:
		termino  {printf("Regla 37\n");}
	     |expresion OPSUM termino {
         printf("Regla 38\n");
         auxiliaresASM++;
         ponerEnPolaca(&polaca,"+");
         }
         |expresion OPRES termino {
           printf("Regla 39\n");
           auxiliaresASM++;
           ponerEnPolaca(&polaca,"-");
           }
         |factorial {printf("Regla 40\n");
                 
                 }
         |combinatoria {printf("Regla 41\n");}
         |ifunario {printf("Regla 42\n");}
		 ;

termino: 
       factor                   {printf("Regla 43\n");}
	   |termino OPDIV factor    {
                                
        printf("Regla 44\n");
        auxiliaresASM++;
        ponerEnPolaca(&polaca,"/");
                                
            }
       |termino OPMUL factor    {
                                
        printf("Regla 45\n");
        auxiliaresASM++;
        ponerEnPolaca(&polaca,"*");
            }			   
       ;

factor:
      id     
      {
               
        printf("Regla 46: id por factor\n");
        char tipoDatoId[MAXCAD];
        strcpy(tipoDatoId,tieneTipoDatoEnTS($1)); 

        
        if(strcmpi(tipoDatoId, "") == 0)
        {
          printf("ERROR: El id %s no tiene tipo de dato\n",$1);
          return;
        }
        

        t_info *tInfoFactor = (t_info*) malloc(sizeof(t_info));
        tInfoFactor->cadena = (char *) malloc (50 * sizeof (char));
        strcpy(tInfoFactor->cadena,tipoDatoId);
        ponerEnPolaca(&polaca,$1);
        apilar(&pilaTipoDato,tInfoFactor);
        
      }
      | cte_Entera              
      {
        
        printf("Regla 47: cte entera por factor\n");
        char arrayEntera[MAXCAD];
        t_info *tInfoFactor = (t_info*) malloc(sizeof(t_info));
        tInfoFactor->cadena = (char *) malloc (50 * sizeof (char));
        strcpy(tInfoFactor->cadena,"INT");
        sprintf(arrayEntera,"%d\0",$1);
        ponerEnPolaca(&polaca,arrayEntera);
        
        apilar(&pilaTipoDato,tInfoFactor);


      }
      | cte_Real                {

      printf("Regla 48: cte real por factor\n");
      char arrayReal[MAXCAD];
      t_info *tInfoFactor =  (t_info*) malloc(sizeof(t_info));
      tInfoFactor->cadena = (char *) malloc (50 * sizeof (char));
      strcpy(tInfoFactor->cadena,"FLOAT");
      sprintf(arrayReal,"%f",$1);
      ponerEnPolaca(&polaca,arrayReal);
      apilar(&pilaTipoDato,tInfoFactor);


      }
      | cte_String              {
        printf("Regla 49: cte string por factor\n");
	t_info *tInfoFactor = (t_info*) malloc(sizeof(t_info));
        tInfoFactor->cadena = (char *) malloc (50 * sizeof (char));
        strcpy(tInfoFactor->cadena,"STRING");
     	ponerEnPolaca(&polaca,$1);
	apilar(&pilaTipoDato,tInfoFactor);
      }
      ;

factorial:
      FACT P_A {
        printf("Regla 50: Empieza factorial");
        while(existeEnTS(resExpFact) == 1)
            {
            sprintf(resExpFact,"@resFact%d",resExpFactActual+1);
            resExpFactActual = resExpFactActual + 1;
            }

        char* resAGuardar = (char*) malloc(sizeof(char)*MAXCAD+1);
        
        sprintf(resAGuardar,"_%s",resExpFact);

        insertarEnNuevaTS(resAGuardar,"","","");

        ponerEnPolaca(&polaca,resExpFact);

        } expresion P_C   {

        ponerEnPolaca(&polaca,"=");

        if(existeEnTS("@fact")==0)
        insertarEnNuevaTS("_@fact","INT","","");

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
        
        ponerEnPolaca(&polaca,resExpFact);
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
        ponerEnPolaca(&polaca,resExpFact);
        ponerEnPolaca(&polaca,"*");
        auxiliaresASM++;

        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,resExpFact);
        ponerEnPolaca(&polaca,resExpFact);
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"-");
        auxiliaresASM++;
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,"BI");
        
        int nro = desapilar_nro(&pilaFactorial);
                 printf("Valor de la pila %d",nro); 
        
        char posPolacaFact[MAXCAD];
        sprintf(posPolacaFact,"%d",posicionPolaca+1);
        ponerEnPolacaPosicion(&polaca,nro,posPolacaFact);

         nro = desapilar_nro(&pilaFactorial);

         char posIteracion[MAXCAD];
         sprintf(posIteracion,"%d",nro);
         ponerEnPolaca(&polaca,posIteracion);

         ponerEnPolaca(&polaca,"@fact");
          
        resExpFactActual--;
        sprintf(resExpFact,"@resFact%d",resExpFactActual);
        }
      ;

combinatoria:
      COMB P_A {
        printf("Regla 51: combina");
        while(existeEnTS(resPrimExpComb) == 1) 
            {
            sprintf(resPrimExpComb,"@resExp%d",resActual+3);
            resActual = resActual + 3;
            }
        
        char* resAGuardar = (char*) malloc(sizeof(char)*MAXCAD+1);
        
        sprintf(resAGuardar,"_%s",resPrimExpComb);

        insertarEnNuevaTS(resAGuardar,"INT","","");
        
        ponerEnPolaca(&polaca,resPrimExpComb);
        
        } expresion {
        ponerEnPolaca(&polaca,"="); 
        }
        COMA { 
          char* resSegAGuardar = (char*) malloc(sizeof(char)*MAXCAD+1);
          
          sprintf(resSegExpComb,"@resExp%d",resActual+1);
         
          sprintf(resSegAGuardar,"_%s",resSegExpComb);
          
          insertarEnNuevaTS(resSegAGuardar,"INT","","");
          ponerEnPolaca(&polaca,resSegExpComb); 
          
          }  expresion 
        {
        ponerEnPolaca(&polaca,"=");

        if(existeEnTS("@F1")==0)
        insertarEnNuevaTS("_@F1","INT","","");

        ponerEnPolaca(&polaca,"F1"); 
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"=");

        if(existeEnTS("@F2")==0)
        insertarEnNuevaTS("_@F2","INT","","");

        ponerEnPolaca(&polaca,"F2");
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"=");
        
        char* resTercAGuardar = (char*) malloc(sizeof(char)*MAXCAD+1);
        
        sprintf(resTercExpComb,"@resExp%d",resActual+2);
         
        sprintf(resTercAGuardar,"_%s",resTercExpComb);
          
        insertarEnNuevaTS(resTercAGuardar,"INT","","");

        ponerEnPolaca(&polaca,resTercExpComb);
        ponerEnPolaca(&polaca,resPrimExpComb);
        ponerEnPolaca(&polaca,resSegExpComb);
        ponerEnPolaca(&polaca,"-");
        auxiliaresASM++;
        ponerEnPolaca(&polaca,"=");

        hacerFactoriales();

        sprintf(resComb,"@resComb%d",resActual);
        ponerEnPolaca(&polaca,resComb);
        ponerEnPolaca(&polaca,"@F1");
        ponerEnPolaca(&polaca,"@F2");

        if(existeEnTS("@F3")==0)
        insertarEnNuevaTS("_@F3","FLOAT","","");
        
        ponerEnPolaca(&polaca,"@F3");
        ponerEnPolaca(&polaca,"*");
        auxiliaresASM++;
        ponerEnPolaca(&polaca,"/");
        auxiliaresASM++;
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,resComb);

        resActual = resActual-3;
        sprintf(resPrimExpComb,"@resExp%d",resActual);
        sprintf(resSegExpComb,"@resExp%d",resActual+1);
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


///////////////////////////////MAIN Y FUNCIONES///////////////////////////////


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
  crearPila(&pilaTipoDato);
	yyparse();
  }
  guardarPolaca(&polaca);
  
  //printf("Validando tipo de dato: %d",validarTipoDatoEnTS("a1","STRING"));
  //mostrarTS();
  guardarTS();
  generarAssembler(&polaca);
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
    printf("Error! No existe la variable %s en la tabla de simbolos", nombre);	
    system ("Pause");
		exit(1);
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
    printf("\nError! No existe la variable %s en la tabla de simbolos",nombre);	  
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
    system ("Pause");
									exit(1);
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

char* tieneTipoDatoEnTS(char* nombre){
    
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;

    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        return tablaDeSimbolos[i].tipoDato;
      }
    }
    printf("\nError! No existe la variable en la tabla de simbolos");	  
    return "";
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

t_info * desapilarASM(t_pila *p)
{   
	t_info* info = (t_info *) malloc(sizeof(t_info));
	    if(!*p){
	    	return NULL;
	    }
	    *info=(*p)->info;
	    *p=(*p)->sig;
	    return info;
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
		
    t_nodoPolaca* aux;
		
		aux=*p;


		if(!pf){
			//No se creó el archivo de intermedia en el main
			return ERROR;
		}

		t_nodoPolaca* nodoActual;

		while(aux)
	    {
	        nodoActual=aux;

	        fprintf(pf, "%s %d\n",nodoActual->info.cadena, nodoActual->info.nro);
	        
			aux=(aux)->psig;
	    
			//free(nodoActual);
	    }
		fclose(pf);
	}

//----------------------------------------------------------------------------------------------------------//
hacerFactoriales(){
  int limite = resActual + 2;
  int ciclo = resActual;
  int factActual = 1;

  for(ciclo;ciclo<=limite;ciclo++){
  //Apilar posicion del res para While e insertar Res
        t_info *tInfoFactorial=(t_info*) malloc(sizeof(t_info));
        if(!tInfoFactorial)
        {
          return;
        }
        tInfoFactorial->nro = posicionPolaca;
        apilar(&pilaFactorial,tInfoFactorial);
        
        char resultActual[MAXCAD];

        sprintf(resultActual,"@resExp%d",ciclo);
        ponerEnPolaca(&polaca,resultActual);
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


        char factorActual[MAXCAD];
        sprintf(factorActual,"@F%d",factActual);
        ponerEnPolaca(&polaca,factorActual); 
        ponerEnPolaca(&polaca,factorActual);
        ponerEnPolaca(&polaca,resultActual);
        ponerEnPolaca(&polaca,"*");
        auxiliaresASM++;
        ponerEnPolaca(&polaca,"=");
        ponerEnPolaca(&polaca,resultActual);
        ponerEnPolaca(&polaca,resultActual);
        ponerEnPolaca(&polaca,"1");
        ponerEnPolaca(&polaca,"-");
        auxiliaresASM++;
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


void generarAssembler(t_polaca* p) {
  t_nodoPolaca* aux;
  char* linea;

  crearPila(&pilaIdsASM);
  int contAuxInt = 0;
  int contAuxFloat = 0;


 /*enum tipoDato ultimoTipo=sinTipo;
  char ultimaCadena[CADENA_MAXIMA];
  int huboAsignacion=TRUE;
  int asignacionConArray=FALSE;
  int vectorComoFactor;*/


  FILE* pf=fopen("final.asm","w+");
  if(!pf){
    printf("Error al guardar el archivo assembler.\n");
    exit(1);
  }



  fprintf(pf,"include macros2.asm\n");
  fprintf(pf,"include number.asm\n\n");
  fprintf(pf,".MODEL LARGE\n.386\n.STACK 200h\n\n.DATA\n");



  //DECLARACION DE VARIABLES  
    int i=0;
    for(i; i<cantFilasTS;i++)
    { 
    if(strcmpi("INT",tablaDeSimbolos[i].tipoDato) == 0){
          fprintf(pf,"%s dw ?\n",tablaDeSimbolos[i].nombre);        
        }

    if(strcmpi("FLOAT",tablaDeSimbolos[i].tipoDato) == 0){
          fprintf(pf,"%s dd ?\n",tablaDeSimbolos[i].nombre);        
        }
    
    if(strcmpi("STRING",tablaDeSimbolos[i].tipoDato) == 0){
          fprintf(pf,"%s dw ?\n",tablaDeSimbolos[i].nombre);        
    }

    if(strcmpi("Cte_String",tablaDeSimbolos[i].tipoDato) == 0){
          fprintf(pf,"%s dw %s\n",tablaDeSimbolos[i].nombre,tablaDeSimbolos[i].valor);        
    }  

    if(strcmpi("Cte_Entera",tablaDeSimbolos[i].tipoDato) == 0){
          fprintf(pf,"%s dd %s\n",tablaDeSimbolos[i].nombre,tablaDeSimbolos[i].valor);        
    }  

    if(strcmpi("Cte_Real",tablaDeSimbolos[i].tipoDato) == 0){
          fprintf(pf,"%s dd %s\n",tablaDeSimbolos[i].nombre,tablaDeSimbolos[i].valor);        
    }  
    }

  int j=0;

  for(j; j<auxiliaresASM; j++){
          fprintf(pf,"auxFloat%d dd 0\n",j); 
          fprintf(pf,"auxInt%d dw 0\n",j);
  }

  //FIN DECLARACION DE VARIABLES
  fprintf(pf,"\n.CODE\n");
  fprintf(pf,"\n\nMOV AX,@DATA\n");
  fprintf(pf,"MOV DS,AX\n");

  fprintf(pf,"\tFINIT\n\n"); //Inicializa el coprocesador

  //Recorremos la polaca
  while(*p)
	    {   
        
          aux = *p;
          
          printf("Recorriendo polaca");

          //Obtenemos la linea
          linea = (char *) malloc (sizeof((*p)->info.cadena));
	        sprintf(linea,"%s",(*p)->info.cadena);

        //En linea esta el valor de cada cadena que se recorre en la polaca

          //Chequeamos si es un ID o Cte. Preguntamos si está en la TS
          if(existeEnTS(linea)){
              t_info *auxPila =(t_info*) malloc(sizeof(t_info));

  
              auxPila->cadena = (char *) malloc (50 * sizeof (char));
              auxPila->tipoDeDato = (char *) malloc (50 * sizeof (char));

              //Guardamos el tipo de dato y la linea en la pila
              
              
              strcpy(auxPila->tipoDeDato,tieneTipoDatoEnTS(linea));
              char lineaAux[MAXCAD];
              sprintf(lineaAux,"@_%s",linea);

              strcpy(auxPila->cadena,lineaAux);

              apilar(&pilaIdsASM,auxPila);

          }


        //Suma
        if(strcmpi(linea,"+") == 0){
          t_info *id1 =(t_info*) malloc(sizeof(t_info));
          t_info *id2 =(t_info*) malloc(sizeof(t_info));
          
          id1 = desapilarASM(&pilaIdsASM);
          id2 = desapilarASM(&pilaIdsASM);

          if(strcmpi(id1->tipoDeDato,"INT")==0 || strcmpi(id1->tipoDeDato,"Cte_Entera")==0 || strcmpi(id2->tipoDeDato,"INT")==0 || strcmpi(id2->tipoDeDato,"Cte_Entera")==0 )
          {
              printf("Suma entera");

              fprintf(pf,"fild\t@%s\n", id1->cadena);
							fprintf(pf,"fiadd\t@%s\n", id2->cadena); 
       
              char auxInt[MAXCAD];
              sprintf(auxInt,"auxInt%d",contAuxInt);

              fprintf(pf,"fistp\t@%s\n", auxInt);

              t_info *auxPilaInt =(t_info*) malloc(sizeof(t_info));  
              auxPilaInt->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaInt->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));
              strcpy(auxPilaInt->cadena,auxInt);
              strcpy(auxPilaInt->tipoDeDato,"INT");  

              apilar(&pilaIdsASM,auxPilaInt);

              contAuxInt++;
          }else if(strcmpi(id1->tipoDeDato,"FLOAT")==0 || strcmpi(id1->tipoDeDato,"Cte_Real")==0 || strcmpi(id2->tipoDeDato,"FLOAT")==0 || strcmpi(id2->tipoDeDato,"Cte_Real")==0 )
          {
              printf("Suma Float");


              //Cargamos las cadenas
              fprintf(pf,"fld\t@%s\n", id1->cadena);

						  fprintf(pf,"fld\t@%s\n", id2->cadena);

              fprintf(pf,"fadd\n");

              //Dejamos el resultado en el aux
              char auxReal[MAXCAD];
              sprintf(auxReal,"auxFloat%d",contAuxFloat);

              fprintf(pf,"fstp\t@%s\n", auxReal);


              //Guardamos en la pila la nueva variable aux
              t_info *auxPilaReal =(t_info*) malloc(sizeof(t_info));  
              auxPilaReal->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaReal->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));

              strcpy(auxPilaReal->cadena,auxReal);
              strcpy(auxPilaReal->tipoDeDato,"FLOAT");  

              apilar(&pilaIdsASM,auxPilaReal);
              contAuxFloat++;

          }
        }

        //Resta
        if(strcmpi(linea,"-") == 0){

          //Despilamos los dos ids / ctes / aux
          t_info *id1 =(t_info*) malloc(sizeof(t_info));
          t_info *id2 =(t_info*) malloc(sizeof(t_info));
          
          id1 = desapilarASM(&pilaIdsASM);
          id2 = desapilarASM(&pilaIdsASM);

          if(strcmpi(id1->tipoDeDato,"INT")==0 || strcmpi(id1->tipoDeDato,"Cte_Entera")==0 || strcmpi(id2->tipoDeDato,"INT")==0 || strcmpi(id2->tipoDeDato,"Cte_Entera")==0 )
          {
              //Carga id 1
              fprintf(pf,"fild\t@%s\n", id1->cadena);

              //Resta el id2
							fprintf(pf,"fisubr\t@%s\n", id2->cadena); 
       
              char auxInt[MAXCAD];
              sprintf(auxInt,"auxInt%d",contAuxInt);

              fprintf(pf,"fistp\t@%s\n", auxInt);

              t_info *auxPilaInt =(t_info*) malloc(sizeof(t_info));  
              auxPilaInt->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaInt->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));
              strcpy(auxPilaInt->cadena,auxInt);
              strcpy(auxPilaInt->tipoDeDato,"INT");  

              apilar(&pilaIdsASM,auxPilaInt);
              contAuxInt++;
          }else if(strcmpi(id1->tipoDeDato,"FLOAT")==0 || strcmpi(id1->tipoDeDato,"Cte_Real")==0 || strcmpi(id2->tipoDeDato,"FLOAT")==0 || strcmpi(id2->tipoDeDato,"Cte_Real")==0 )
          {
              printf("Resta Float");
              //Cargo el primer id
              fprintf(pf,"fld\t@%s\n", id1->cadena);

              //Cargo el segundo id
						  fprintf(pf,"fld\t@%s\n", id2->cadena);

              //Realiza la resta
              fprintf(pf,"fsubr\n");


              char auxReal[MAXCAD];
              sprintf(auxReal,"auxFloat%d",contAuxFloat);

              fprintf(pf,"fstp\t@%s\n", auxReal);

              t_info *auxPilaReal =(t_info*) malloc(sizeof(t_info));  
              auxPilaReal->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaReal->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));
              strcpy(auxPilaReal->cadena,auxReal);
              strcpy(auxPilaReal->tipoDeDato,"FLOAT");  

              apilar(&pilaIdsASM,auxPilaReal);
              contAuxFloat++;

          }
        }

        //Multiplicacion
        if(strcmpi(linea,"*") == 0){
          t_info *id1 =(t_info*) malloc(sizeof(t_info));
          t_info *id2 =(t_info*) malloc(sizeof(t_info));
          
          id1 = desapilarASM(&pilaIdsASM);
          id2 = desapilarASM(&pilaIdsASM);

          if(strcmpi(id1->tipoDeDato,"INT")==0 || strcmpi(id1->tipoDeDato,"Cte_Entera")==0 || strcmpi(id2->tipoDeDato,"INT")==0 || strcmpi(id2->tipoDeDato,"Cte_Entera")==0 )
          {
              printf("Multiplicacion entera");
              fprintf(pf,"fild\t@%s\n", id1->cadena);

							fprintf(pf,"tfimul\t@%s\n", id2->cadena); 
       
              char auxInt[MAXCAD];
              sprintf(auxInt,"auxInt%d",contAuxInt);

              fprintf(pf,"fistp \t@%s\n", auxInt);

              t_info *auxPilaInt =(t_info*) malloc(sizeof(t_info));  
              auxPilaInt->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaInt->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));
              strcpy(auxPilaInt->cadena,auxInt);
              strcpy(auxPilaInt->tipoDeDato,"INT");  

              apilar(&pilaIdsASM,auxPilaInt);
              contAuxInt++;
          }else if(strcmpi(id1->tipoDeDato,"FLOAT")==0 || strcmpi(id1->tipoDeDato,"Cte_Real")==0 || strcmpi(id2->tipoDeDato,"FLOAT")==0 || strcmpi(id2->tipoDeDato,"Cte_Real")==0 )
          {
              printf("Multiplicacion Float");
              
              //Cargo el primer id
              fprintf(pf,"fld\t@%s\n", id1->cadena);

              //Cargo el segundo id
						  fprintf(pf,"fld\t@%s\n", id2->cadena);

              //Multiplico
              fprintf(pf,"fmul\n");


              char auxReal[MAXCAD];
              sprintf(auxReal,"auxFloat%d",contAuxFloat);

              fprintf(pf,"fstp\t@%s\n", auxReal);

              t_info *auxPilaReal =(t_info*) malloc(sizeof(t_info));  
              auxPilaReal->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaReal->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));
              strcpy(auxPilaReal->cadena,auxReal);
              strcpy(auxPilaReal->tipoDeDato,"FLOAT");  

              apilar(&pilaIdsASM,auxPilaReal);
              contAuxFloat++;

          }
        }

        //Division
        if(strcmpi(linea,"/") == 0){
          t_info *id1 =(t_info*) malloc(sizeof(t_info));
          t_info *id2 =(t_info*) malloc(sizeof(t_info));
          
          id1 = desapilarASM(&pilaIdsASM);
          id2 = desapilarASM(&pilaIdsASM);

          if(strcmpi(id1->tipoDeDato,"INT")==0 || strcmpi(id1->tipoDeDato,"Cte_Entera")==0 || strcmpi(id2->tipoDeDato,"INT")==0 || strcmpi(id2->tipoDeDato,"Cte_Entera")==0 )
          {
              printf("Division entera");
              fprintf(pf,"fild\t@%s\n", id1->cadena);

              //Divido por el segundo id
							fprintf(pf,"fidivr\t@%s\n", id2->cadena); 
       
              char auxInt[MAXCAD];
              sprintf(auxInt,"auxInt%d",contAuxInt);

              fprintf(pf,"fistp\t@%s\n", auxInt);

              t_info *auxPilaInt =(t_info*) malloc(sizeof(t_info));  
              auxPilaInt->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaInt->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));


              strcpy(auxPilaInt->cadena,auxInt);
              strcpy(auxPilaInt->tipoDeDato,"INT");  

              apilar(&pilaIdsASM,auxPilaInt);
              contAuxInt++;
          }else if(strcmpi(id1->tipoDeDato,"FLOAT")==0 || strcmpi(id1->tipoDeDato,"Cte_Real")==0 || strcmpi(id2->tipoDeDato,"FLOAT")==0 || strcmpi(id2->tipoDeDato,"Cte_Real")==0 )
          {
              printf("Division Float");

              //Cargo el primero
              fprintf(pf,"fld\t@%s\n", id1->cadena);

              //Cargo el segundo id
						  fprintf(pf,"fld\t@%s\n", id2->cadena);

              //Realiza la division
              fprintf(pf,"fdivr\n");


              char auxReal[MAXCAD];
              sprintf(auxReal,"auxFloat%d",contAuxFloat);

              fprintf(pf,"fstp\t@%s\n", auxReal);

              t_info *auxPilaReal =(t_info*) malloc(sizeof(t_info));  
              auxPilaReal->cadena = (char *) malloc (MAXCAD * sizeof (char));
              auxPilaReal->tipoDeDato = (char *) malloc (MAXCAD * sizeof (char));

              strcpy(auxPilaReal->cadena,auxReal);
              strcpy(auxPilaReal->tipoDeDato,"FLOAT");  

              apilar(&pilaIdsASM,auxPilaReal);
              contAuxFloat++;

          }
        }

      //Entrada y salida
			if(strcmpi(linea,"DISPLAY")==0){
				fprintf(pf,";SALIDA\n");
        t_info *auxPila =(t_info*) malloc(sizeof(t_info));
        auxPila = desapilarASM(&pilaIdsASM);

        if(strcmpi(auxPila->tipoDeDato,"INT")==0 || strcmpi(auxPila->tipoDeDato,"Cte_Entera")==0)
        {
            fprintf(pf,"\tdisplayInteger \t@%s,3\n\tnewLine 1\n",auxPila->cadena);
        }
        else 
        {
          if(strcmpi(auxPila->tipoDeDato,"FLOAT")==0 || strcmpi(auxPila->tipoDeDato,"Cte_Real")==0)
          {
            fprintf(pf,"\tdisplayFloat \t@%s,3\n\tnewLine 1\n",auxPila->cadena);
          }
          else if(strcmpi(auxPila->tipoDeDato,"STRING")==0 || strcmpi(auxPila->tipoDeDato,"Cte_String")==0)
          {
            fprintf(pf,"\tdisplayString \t@%s\n\tnewLine 1\n",auxPila->cadena);
          }
        }
        

			}

			if(strcmpi(linea,"GET")==0){
				fprintf(pf,";ENTRADA\n");
        t_info *auxPila =(t_info*) malloc(sizeof(t_info));
        auxPila = desapilarASM(&pilaIdsASM);

		    if(strcmpi(auxPila->tipoDeDato,"INT")==0 || strcmpi(auxPila->tipoDeDato,"Cte_Entera")==0)
        {
            fprintf(pf,"\tgetInteger \t@%s,3\n\tnewLine 1\n",auxPila->cadena);
        }
        else 
        {
          if(strcmpi(auxPila->tipoDeDato,"FLOAT")==0 || strcmpi(auxPila->tipoDeDato,"Cte_Real")==0)
          {
            fprintf(pf,"\tgetFloat \t@%s,3\n\tnewLine 1\n",auxPila->cadena);
          }
          else if(strcmpi(auxPila->tipoDeDato,"STRING")==0 || strcmpi(auxPila->tipoDeDato,"Cte_String")==0)
          {
            fprintf(pf,"\tgetString \t@%s\n\tnewLine 1\n",auxPila->cadena);
          }
        }
        
		  }


      //Asignacion
      if(strcmp(linea,"=")==0){
        fprintf(pf,";ASIGNACION\n");
        t_info *id =(t_info*) malloc(sizeof(t_info));
        id = desapilarASM(&pilaIdsASM);

        fprintf(pf,"\tfild\t@%s\n",desapilarASM(&pilaIdsASM)->cadena);
        fprintf(pf,"\tfistp\t@%s\n",id->cadena);


        fprintf(pf,"\tdisplayInteger @_b,3\n");
      }

      *p=(*p)->psig;
      free(aux);
      //FIN DEL WHILE
	  }
      



  /*while(aux!=NULL){

  }*/

 //COMPARADORES
    /*if(strcmp(linea,"CMP")==0){
				t_info *op1= desapilarASM(&pilaIdsASM);
				t_info *op2= desapilarASM(&pilaIdsASM);

        if(strcmpi(op1->tipoDeDato,"FLOAT") == 0){                                // diferencio la comparacion de enteros de la real.
					fprintf(pf,"\tfld \t@%s\n", op1->cadena); 
					fprintf(pf,"\tfld \t@%s\n", op2->cadena);
				}
				else{
					fprintf(pf,"\tfild \t@%s\n", op1->cadena);
					fprintf(pf,"\tfild \t@%s\n", op2->cadena);
				}
			}
      // >
			if(strcmp(linea,"BLE")==0){
				fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjbe\t\t%s\n",desapilarASM(&pilaIdsASM)->cadena);
			}

			//<
			if(strcmp(linea,"BGE")==0){
				fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjae\t\t%s\n",desapilarASM(&pilaIdsASM)->cadena);
			}

			//!=
			if(strcmp(linea,"BEQ")==0){
				fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tje\t\t%s\n",desapilarASM(&pilaIdsASM)->cadena);
			}

			//==
			if(strcmp(linea,"BNE")==0){
				fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjne\t\t%s\n",desapilarASM(&pilaIdsASM)->cadena);
			}

			//>=
			if(strcmp(linea,"BLT")==0){
				fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tjb\t\t%s\n",desapilarASM(&pilaIdsASM)->cadena);
			}

			//<=
			if(strcmp(linea,"BGT")==0){
				fprintf(pf,"\tfcomp\n\tfstsw\tax\n\tfwait\n\tsahf\n\tja\t\t%s\n",desapilarASM(&pilaIdsASM)->cadena);
			}

			if(strcmp(linea,"BI")==0){
				fprintf(pf,"\tjmp\t\t%s\n",sacarDePila(&pilaIdsASM)->cadena);
			}*/




  //FIN DE ARCHIVO
  fprintf(pf,"\tFFREE\n\n");
  fprintf(pf,"FINAL:\n");
  fprintf(pf,"\tmov ah, 1\n\tint 21h\n\tMOV AX, 4c00h\n\tINT 21h\n");
  fprintf(pf,"END\n\n;FIN DEL PROGRAMA DE USUARIO\n");

  fclose(pf);

  printf("FIN GENERACION DE ASSEMBLER!!!");
}




