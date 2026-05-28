/* FLEX Lexer */
%{
#define _GNU_SOURCE  /* Extensión POSIX/GNU (strndup) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "patito.tab.h"
%}

%option noyywrap
%option yylineno
%option nounput
%option noinput

%%

 /* 1. Palabras reservadas */
"programa"   { return T_PROGRAMA; }
"vars"       { return T_VARS; }
"inicio"     { return T_INICIO; }
"fin"        { return T_FIN; }
"nula"       { return T_NULA; }
"si"         { return T_SI; }
"sino"       { return T_SINO; }
"mientras"   { return T_MIENTRAS; }
"haz"        { return T_HAZ; }
"entero"     { return T_ENTERO; }
"flotante"   { return T_FLOTANTE; }
"escribe"    { return T_ESCRIBE; }
"regresa"    { return T_REGRESA; }

 /* 2. Cadena literal */
\"[^"\n]*\"   { yylval.sval = strndup(yytext+1, yyleng-2); return T_LETRERO; }

 /* 3. Operadores de dos caracteres */
"=="   { return T_EQUAL_TO; }
"!="   { return T_NEQ; }

 /* 4. Constante flotante */
[0-9]+\.[0-9]+   { yylval.fval = atof(yytext); return T_CTE_FLOT; }

 /* 5. Constante entera */
[0-9]+   { yylval.ival = atoi(yytext); return T_CTE_ENT; }

 /* 6. Identificador */
[a-zA-Z][a-zA-Z0-9_]*   { yylval.sval = strdup(yytext); return T_ID; }

 /* 7. Operadores y puntuación de un carácter */
[=><+*/;:,(){}[\]-]   { return *yytext; }

 /* 8. Espacios en blanco */
[ \t\r\n]+   { /* ignorar */ }

 /* 9. Error léxico */
.   { printf("Error léxico: carácter no reconocido '%c' en línea %d\n", yytext[0], yylineno); }

%%