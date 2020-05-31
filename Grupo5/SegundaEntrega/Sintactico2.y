%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

	#define ERROR -1
	#define OK 3
  #define MAXINT 50
  #define MAXCAD 50

//------------------ESTRUCUTURAS ----------------------------//
//Pila
	typedef struct
	{
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
	void crearPila(t_pila*);
	int apilar(t_pila*,t_info*);
	t_info* verTopeDePila(t_pila*);
	int pilaVacia (const t_pila*);
	

	//internas del compilador
	int insertarEnTS(char[],char[],char[],int,double);

	//Contadores
	int contIf=0;
	int contWhile=0;

	//Posicion en polaca
	int posicionPolaca=0;

	//Notacion intermedia
	t_polaca polaca;
	t_pila pilaIf;
	t_pila pilaWhile;
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
	PROGRAM est_declaracion bloque {printf(" 1\n");}
    ;

est_declaracion:
	DEFVAR declaraciones ENDDEF {printf(" 2\n");}
        ;

declaraciones:
            declaracion {printf(" 3\n");}
            |declaracion declaraciones  {printf(" 4\n");}
      ;
declaracion:
            FLOAT COLON lista_var{printf("5\n");}
            |STRING COLON lista_var{printf("6\n");}
            |INT COLON lista_var{printf("7\n");}
            ;

lista_var:
          ID              {printf(" 8\n");}
          |ID SEMICOLON lista_var {printf(" 9\n");}
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
    	 IF P_A condicion P_C bloque ENDIF{printf("17\n");}
	    |IF P_A condicion P_C bloque ELSE bloque ENDIF {printf("18\n");}	 
;

iteracion:
          WHILE P_A condicion P_C bloque ENDWHILE {printf("19\n");}
        ;

asignacion:
		ID 
		{
			//char cadena[] = (char)ID;
			char cadena[] = "id";
			printf("\nID = %s", ID);
			//ponerEnPolaca(&polaca, &cadena);
		}
		ASIGN expresion {printf(" 20\n");}
        ;

ifunario:
        IF P_A condicion COMA expresion COMA expresion P_C {printf(" 21\n");}
        ;

salida:
        DISPLAY ID{printf("22\n");}
        |DISPLAY CTE_STRING{printf("23\n");}
        ;

entrada:
      GET ID{printf("24\n");}
      ;

condicion:
          comparacion{printf(" 25\n");}
          |comparacion AND comparacion {printf(" 26\n");}
          |comparacion OR comparacion {printf(" 27\n");}
	      |NOT comparacion {printf(" 28\n");}
		;

comparacion:
          expresion comparador expresion {printf(" 29\n");}
	      |P_A expresion comparador expresion P_C {printf(" 30\n");}
		  ;
        
comparador:
          MAYEQ {printf(" 31\n");}
          |MINEQ {printf(" 32\n");}
          |MIN {printf(" 33\n");}
          |MAY {printf(" 34\n");}
          |EQUAL {printf(" 35\n");}
		  |NOTEQUAL {printf(" 36\n");}
		  ;

expresion:
         termino  {printf(" 37\n");}
	     |expresion OPSUM termino {printf(" 38\n");}
         |expresion OPRES termino {printf(" 39\n");}
         |factorial {printf(" 40\n");}
         |combinatoria {printf(" 41\n");}
         |ifunario {printf(" 42\n");}
		 ;

termino: 
       factor                   {printf("43\n");}
       |termino OPDIV factor    {printf("44\n");}
       |termino OPMUL factor    {printf("45\n");}
       ;

factor:
      ID                        {printf("46\n");}
      | CTE_ENTERA              {printf("47\n");}
      | CTE_REAL                {printf("48\n");}
      | CTE_STRING              {printf("49\n");}
      ;

factorial:
      FACT P_A expresion P_C {printf("50\n");}
      ;

combinatoria:
      COMB P_A expresion COMA expresion P_C {printf("51\n");}
      ;

%%


int main(int argc,char *argv[])
{ 
  FILE *archTabla = fopen("ts.txt","w");
  t_pila pp;
  //t_polaca polaca;
  char cadena[] = "ID";
  
  fprintf(archTabla,"%s\n","NOMBRE\t\t\tTIPODATO\t\tVALOR");
  fclose(archTabla);

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	crearPila(&pp);
	crearPolaca(&polaca);
	
	//ponerEnPolaca(&polaca, &cadena);
	
	yyparse();
  }
  //guardarPolaca(&polaca);
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }



//------------------------------------Funciones de Pila----------------------------------------------------//

void crearPila(t_pila* p){
		p=NULL;
		printf("\nPila creada");
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
	t_info* info;
    
	*info =(*p)->info;
    *p=(*p)->sig;
    
	free(aux);
    
	return (info);
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
  printf("\nPolaca creada");
  //return;
}

//Ponemos en polaca el nodo a lo último, con su respectiva cadena y hacemos que apunte a null su siguiente
int ponerEnPolaca(t_polaca* p, char *cadena)
	{
		printf("\nPoniendo en Polaca: %s\n", cadena);
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

	        fprintf(pf, "%s\n",nodoActual->info.cadena);
	        
			*p=(*p)->psig;
	        
			free(nodoActual);
	    }
		fclose(pf);
	}
	
///////////////////////////////////////////Ni idea si anda esto de abajo:
int mostrarPolaca(t_polaca *p){
		
		if(!p){
			//No hay polaca
			return ERROR;
		}

		t_nodoPolaca* nodoActual;

		while(*p)
	    {
	        nodoActual=*p;

	        printf("%s\n",nodoActual->info.cadena);
	        
			*p=(*p)->psig;
	        
			free(nodoActual);
	    }
	}

//----------------------------------------------------------------------------------------------------------//


int insertarEnTS(char nombreToken[],char tipoToken[],char valorString[],int valorInteger, double valorFloat){
  
  FILE *tablaSimbolos = fopen("ts.txt","r");
  char simboloNuevo[200];
  int repetido = 0;
  int i = 0;
  
  char tab[6] = "\t\t\t"; 	
  char *finCadena;

  int j;
  int cantidadACiclar;

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


      cantidadACiclar = (strlen(valor)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }


      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,valor);
      //strcat(simboloNuevo,"\t\t\t");
      strcat(simboloNuevo,tab);
      strcat(simboloNuevo,"Ent");
      strcat(simboloNuevo,"\t\t\t");
      strcat(simboloNuevo,valor);
    }

    //Chequea si es real
    if(strcmp(tipoToken,"CTE_REAL") == 0){
      sprintf(valor,"%.3f",valorFloat);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);


      cantidadACiclar = (strlen(valor)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }

      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,valor);
      strcat(simboloNuevo,tab);
      strcat(simboloNuevo,"Real");
      strcat(simboloNuevo,"\t\t\t");
      strcat(simboloNuevo,valor);
    }

    //Chequea si es string
    if(strcmp(tipoToken,"CTE_STRING") == 0){
      sprintf(valor,"%s",nombreToken);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);


	  cantidadACiclar = (strlen(valor)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }


      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,nombreToken);
      //strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,tab);
      strcat(simboloNuevo,"String");
      strcat(simboloNuevo,"\t\t\t");
      //strcat(simboloNuevo,tab);
      strcat(simboloNuevo,valorString);


    }
  }else{


      cantidadACiclar = (strlen(nombreToken)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }

    strcpy(simboloNuevo,nombreToken);
    strcat(simboloNuevo,tab);
    strcat(simboloNuevo,tipoToken);
    strcat(simboloNuevo,"\t\t\t");
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
