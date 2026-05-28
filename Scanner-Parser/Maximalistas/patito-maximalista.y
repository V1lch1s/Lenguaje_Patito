/* BISON parser (Maximalista no funcional) */
%{
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* =========================================================
 * Interfaz Flex <-> Bison
 * ========================================================= */

int yylex(void);
void yyerror(const char *s);

extern int yylineno;
extern char *yytext;

/* =========================================================
 * Hooks semánticos futuros
 * =========================================================
 *
 * El parser actual es sintáctico.
 * No se construye AST todavía.
 *
 * Aquí podrían agregarse:
 *
 * - tabla de símbolos
 * - árbol sintáctico abstracto
 * - verificación de tipos
 * - generación de cuádruplos
 * - generación de IR
 * - manejo de scopes
 * - memoria temporal
 * - VM / backend
 */

/* =========================================================
 * Flags de depuración
 * ========================================================= */

/* int semantic_debug = 0; */
/* int symbol_debug   = 0; */
/* int quadruple_debug = 0; */

%}

/* =========================================================
 * Parser verbose errors
 * ========================================================= */

%define parse.error verbose

/* =========================================================
 * API reentrante (no usada actualmente)
 * ========================================================= */

/* %define api.pure full */

/* =========================================================
 * Locations (no usadas todavía)
 * ========================================================= */

/* %locations */

/* =========================================================
 * Unión semántica
 * ========================================================= */

%union
{
	int    ival;
	float  fval;
	char  *sval;

	/* =====================================================
	 * Espacios reservados para futuras estructuras
	 * ===================================================== */

	/* struct ast_node *node; */
	/* struct symbol   *sym;  */
	/* struct quad     *quad; */
}

/* =========================================================
 * Tokens con valor semántico
 * ========================================================= */

%token <sval> T_ID
%token <sval> T_LETRERO

%token <ival> T_CTE_ENT
%token <fval> T_CTE_FLOT

/* =========================================================
 * Keywords
 * ========================================================= */

%token T_PROGRAMA
%token T_VARS
%token T_INICIO
%token T_FIN
%token T_NULA
%token T_SI
%token T_SINO
%token T_MIENTRAS
%token T_HAZ
%token T_ENTERO
%token T_FLOTANTE
%token T_ESCRIBE
%token T_REGRESA

/* =========================================================
 * Operadores complejos
 * ========================================================= */

%token T_EQUAL_TO
%token T_NEQ

/* =========================================================
 * Asociatividad y precedencia
 * ========================================================= */

%left '+' '-'
%left '*' '/'
%left '<' '>' T_EQUAL_TO T_NEQ

/* =========================================================
 * Tipos semánticos de no terminales
 * =========================================================
 *
 * No se usan todavía, pero quedan preparados.
 */

/*
%type <node> programa
%type <node> expresion
%type <node> exp
%type <node> termino
%type <node> factor
*/

/* =========================================================
 * Símbolo inicial
 * ========================================================= */

%start programa

%%

/* =========================================================
 * Programa principal
 * ========================================================= */

programa:
	T_PROGRAMA T_ID ';'
	declaracion_Vars
	declaracion_Funcs
	T_INICIO
	cuerpo
	T_FIN
	{
		printf("Programa válido.\n");
	}
;

/* =========================================================
 * Declaraciones globales
 * ========================================================= */

declaracion_Vars:
	/* vacío */
	| vars
;

declaracion_Funcs:
	/* vacío */
	| funcs list_Funcs
;

list_Funcs:
	/* vacío */
	| declaracion_Funcs
;

/* =========================================================
 * Variables
 * ========================================================= */

vars:
	T_VARS def_vars
;

def_vars:
	identifiers ':' tipo ';' Multi_var
;

identifiers:
	T_ID list_id
;

list_id:
	/* vacío */
	| ',' identifiers
;

Multi_var:
	/* vacío */
	| def_vars
;

/* =========================================================
 * Tipos
 * ========================================================= */

tipo:
	T_ENTERO
	| T_FLOTANTE
;

/* =========================================================
 * Constantes
 * ========================================================= */

cte:
	T_CTE_ENT
	| T_CTE_FLOT
;

/* =========================================================
 * Cuerpo
 * ========================================================= */

cuerpo:
	'{' def_Est '}'
;

def_Est:
	/* vacío */
	| estatuto Multi_Statements
;

Multi_Statements:
	/* vacío */
	| def_Est
;

/* =========================================================
 * Asignación
 * ========================================================= */

asigna:
	T_ID '=' expresion ';'
;

/* =========================================================
 * Expresiones
 * ========================================================= */

expresion:
	exp def_Exp
;

def_Exp:
	/* vacío */
	| Operator exp
;

Operator:
	'>'
	| '<'
	| T_NEQ
	| T_EQUAL_TO
;

/* =========================================================
 * Expresión aritmética
 * ========================================================= */

exp:
	termino Add_Sust_2
;

Add_Sust_2:
	/* vacío */
	| '+' exp
	| '-' exp
;

/* =========================================================
 * Término
 * ========================================================= */

termino:
	factor Mult_Div
;

Mult_Div:
	/* vacío */
	| '*' termino
	| '/' termino
;

/* =========================================================
 * Factor
 * ========================================================= */

factor:
	'(' expresion ')'
	| Add_Sust id_CTE
	| llamada
;

/* =========================================================
 * Signo opcional
 * ========================================================= */

Add_Sust:
	/* vacío */
	| '+'
	| '-'
;

/* =========================================================
 * ID o constante
 * ========================================================= */

id_CTE:
	T_ID
	| cte
;

/* =========================================================
 * Funciones
 * ========================================================= */

funcs:
	Func_Type
	T_ID
	'('
	def_Type
	')'
	'{'
	def_Var_Funcs
	cuerpo
	'}'
	';'
;

Func_Type:
	T_NULA
	| tipo
;

def_Type:
	/* vacío */
	| T_ID ':' tipo Multi_Type
;

Multi_Type:
	/* vacío */
	| ',' def_Type
;

def_Var_Funcs:
	/* vacío */
	| vars
;

/* =========================================================
 * Imprime
 * ========================================================= */

imprime:
	T_ESCRIBE '(' Mensaje ')' ';'
;

Mensaje:
	T_LETRERO
	| T_LETRERO Mensaje
	| expresion Multi_Express
;

Multi_Express:
	/* vacío */
	| ',' Mensaje
;

/* =========================================================
 * Llamadas
 * ========================================================= */

llamada:
	T_ID '(' Expression_Call ')'
;

Expression_Call:
	/* vacío */
	| expresion Expression_list
;

Expression_list:
	/* vacío */
	| ',' Expression_Call
;

/* =========================================================
 * Regresa
 * ========================================================= */

regresa:
	T_REGRESA expresion ';'
;

/* =========================================================
 * Estatuto
 * ========================================================= */

estatuto:
	asigna
	| condicion
	| ciclo
	| llamada ';'
	| imprime
	| regresa
	| '[' Estatuto_Anidado ']'
;

/* =========================================================
 * Bloque anidado
 * ========================================================= */

Estatuto_Anidado:
	/* vacío */
	| estatuto Multi_Sttmnt_2
;

Multi_Sttmnt_2:
	/* vacío */
	| Estatuto_Anidado
;

/* =========================================================
 * Ciclo
 * ========================================================= */

ciclo:
	T_MIENTRAS
	'(' expresion ')'
	T_HAZ
	cuerpo
	';'
;

/* =========================================================
 * Condición
 * ========================================================= */

condicion:
	T_SI
	'(' expresion ')'
	cuerpo
	Si_No
	';'
;

Si_No:
	/* vacío */
	| T_SINO cuerpo
;

%%

/* =========================================================
 * Error sintáctico
 * ========================================================= */

void yyerror(const char *s)
{
	fprintf(
		stderr,
		"Error sintáctico: %s en línea %d cerca de '%s'\n",
		s,
		yylineno,
		yytext
	);
}

/* =========================================================
 * Funciones auxiliares futuras
 * ========================================================= */

/*
static void semantic_error(const char *msg)
{
	fprintf(stderr, "Error semántico: %s\n", msg);
}
*/

/*
static void type_error(const char *expected, const char *received)
{
	fprintf(
		stderr,
		"Type mismatch: expected %s but got %s\n",
		expected,
		received
	);
}
*/

/*
static void internal_compiler_error(const char *msg)
{
	fprintf(stderr, "Internal compiler error: %s\n", msg);
	exit(EXIT_FAILURE);
}
*/

/* =========================================================
 * Hooks reservados
 * ========================================================= */

/*
static void enter_scope(void)
{
}
*/

/*
static void leave_scope(void)
{
}
*/

/*
static void emit_quadruple(...)
{
}
*/

/*
static void build_ast_node(...)
{
}
*/

/*
static void verify_function_call(...)
{
}
*/

/*
static void insert_symbol(...)
{
}
*/

/*
static void lookup_symbol(...)
{
}
*/