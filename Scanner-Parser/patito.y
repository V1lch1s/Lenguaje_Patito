/* BISON parser */
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
extern int yylineno;
%}

%define parse.error verbose
%start Programa

%union {
    char *sval;
    int   ival;
    float fval;
}

%token T_PROGRAMA T_VARS T_INICIO T_FIN T_NULA T_SI T_SINO T_MIENTRAS T_HAZ T_ENTERO T_FLOTANTE T_ESCRIBE T_REGRESA
%token <sval> T_LETRERO T_ID
%token <ival> T_CTE_ENT
%token <fval> T_CTE_FLOT
%token T_EQUAL_TO T_NEQ

%%

/* =========================
   Programa
   ========================= */

Programa
    : T_PROGRAMA T_ID ';' declaracion_Vars declaracion_Funcs T_INICIO CUERPO T_FIN
    ;

/* =========================
   Variables globales
   ========================= */

declaracion_Vars
    : /* empty */
    | VARS
    ;

VARS
    : T_VARS def_vars
    ;

def_vars
    : identifiers ':' TIPO ';' Multi_var
    ;

identifiers
    : T_ID list_id
    ;

list_id
    : /* empty */
    | ',' identifiers
    ;

Multi_var
    : /* empty */
    | def_vars
    ;

TIPO
    : T_ENTERO
    | T_FLOTANTE
    ;

/* =========================
   Funciones
   ========================= */

declaracion_Funcs
    : /* empty */
    | FUNCS list_Funcs
    ;

list_Funcs
    : /* empty */
    | FUNCS list_Funcs
    ;

FUNCS
    : Func_Type T_ID '(' def_Type ')' '{' def_Var_Funcs CUERPO '}' ';'
    ;

Func_Type
    : T_NULA
    | TIPO
    ;

def_Type
    : /* empty */
    | T_ID ':' TIPO Multi_Type
    ;

Multi_Type
    : /* empty */
    | ',' def_Type
    ;

def_Var_Funcs
    : /* empty */
    | VARS
    ;

/* =========================
   Bloques y sentencias
   ========================= */

CUERPO
    : '{' def_Est '}'
    ;

def_Est
    : /* empty */
    | ESTATUTO Multi_Statements
    ;

Multi_Statements
    : /* empty */
    | ESTATUTO Multi_Statements
    ;

ESTATUTO
    : ASIGNA
    | CONDICION
    | CICLO
    | LLAMADA ';'
    | IMPRIME
    | REGRESA
    | '[' Estatuto_Anidado ']'
    ;

Estatuto_Anidado
    : /* empty */
    | ESTATUTO Multi_Sttmnt_2
    ;

Multi_Sttmnt_2
    : /* empty */
    | ESTATUTO Multi_Sttmnt_2
    ;

/* =========================
   Asignación
   ========================= */

ASIGNA
    : T_ID '=' EXPRESION ';'
    ;

/* =========================
   Ciclos y condición
   ========================= */

CICLO
    : T_MIENTRAS '(' EXPRESION ')' T_HAZ CUERPO ';'
    ;

CONDICION
    : T_SI '(' EXPRESION ')' CUERPO Si_No ';'
    ;

Si_No
    : /* empty */
    | T_SINO CUERPO
    ;

/* =========================
   Imprime / mensaje
   ========================= */

IMPRIME
    : T_ESCRIBE '(' Mensaje ')' ';'
    ;

Mensaje
    : T_LETRERO Multi_Express
    | EXPRESION Multi_Express
    ;

Multi_Express
    : /* empty */
    | ',' Mensaje
    ;

/* =========================
   Llamadas
   ========================= */

LLAMADA
    : T_ID '(' Expression_Call ')'
    ;

Expression_Call
    : /* empty */
    | EXPRESION Expression_list
    ;

Expression_list
    : /* empty */
    | ',' Expression_Call
    ;

/* =========================
   Regresa
   ========================= */

REGRESA
    : T_REGRESA EXPRESION ';'
    ;

/* =========================
   Expresiones
   ========================= */

EXPRESION
    : EXP def_Exp
    ;

def_Exp
    : /* empty */
    | Operator EXP
    ;

Operator
    : '>'
    | '<'
    | T_NEQ
    | T_EQUAL_TO
    ;

EXP
    : TERMINO Add_Sust_2
    ;

Add_Sust_2
    : /* empty */
    | '+' EXP
    | '-' EXP
    ;

TERMINO
    : FACTOR Mult_Div
    ;

Mult_Div
    : /* empty */
    | '*' TERMINO
    | '/' TERMINO
    ;

FACTOR
    : '(' EXPRESION ')'
    | Add_Sust id_CTE
    | LLAMADA
    ;

Add_Sust
    : /* empty */
    | '+'
    | '-'
    ;

id_CTE
    : T_ID
    | CTE
    ;

CTE
    : T_CTE_ENT
    | T_CTE_FLOT
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Error sintáctico en línea %d: %s\n", yylineno, s);
}

int main(void)
{
    return yyparse();
}