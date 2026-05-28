/* FLEX Lexer (Maximalista no funcional) */
%{
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "patito.tab.h"

static void lex_error(char c)
{
	fprintf(stderr, "Error léxico: carácter no reconocido '%c' en línea %d\n", c, yylineno);
}
%}

/* =========================
 * Opciones Flex
 * ========================= */
%option noyywrap
%option yylineno
%option nounput
%option noinput
%option nodefault

/* =========================
 * Macros léxicas
 * ========================= */
DIGIT      [0-9]
LETTER     [A-Za-z]
ID         {LETTER}[A-Za-z0-9_]*
INT        {DIGIT}+
FLOT       {DIGIT}+"."{DIGIT}+
STRING     \"[^"\n]*\"
WS         [ \t\r\n\f\v]+

%%
/* =========================
 * 1. Palabras reservadas
 * =========================
 * Se evalúan antes de ID.
 */

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

/* =========================
 * 2. Cadena literal
 * =========================
 * No se permiten saltos de línea dentro.
 * Las comillas se eliminan al guardar el lexema.
 */

{STRING}     { yylval.sval = strndup(yytext + 1, yyleng - 2); return T_LETRERO; }

/* =========================
 * 3. Operadores de dos caracteres
 * =========================
 * Siempre antes que los de un solo carácter.
 */

"=="         { return T_EQUAL_TO; }
"!="         { return T_NEQ; }

/* =========================
 * 4. Constante flotante
 * =========================
 * Forma actual del lenguaje:
 *     [0-9]+\.[0-9]+
 *
 * No aplica, por ahora:
 *     .5
 *     5.
 *     1.0e10
 */

{FLOT}       { yylval.fval = atof(yytext); return T_CTE_FLOT; }

/* =========================
 * 5. Constante entera
 * ========================= */

{INT}        { yylval.ival = atoi(yytext); return T_CTE_ENT; }

/* =========================
 * 6. Identificador
 * =========================
 * Letras seguidas de letras, dígitos o guion bajo.
 * No se admiten identificadores que inicien con '_'.
 */

{ID}         { yylval.sval = strdup(yytext); return T_ID; }

/* =========================
 * 7. Operadores y puntuación de un carácter
 * =========================
 * El parser consume estos símbolos como ASCII directo.
 */

"="          { return '='; }
">"          { return '>'; }
"<"          { return '<'; }
"+"          { return '+'; }
"-"          { return '-'; }
"*"          { return '*'; }
"/"          { return '/'; }
";"          { return ';'; }
":"          { return ':'; }
","          { return ','; }
"("          { return '('; }
")"          { return ')'; }
"{"          { return '{'; }
"}"          { return '}'; }
"["          { return '['; }
"]"          { return ']'; }

/* =========================
 * 8. Espacios en blanco
 * =========================
 * Se ignoran sin generar token.
 */

{WS}         { /* ignorar */ }

/* =========================
 * Reglas desactivadas / no aplicables al lenguaje actual
 * =========================
 *
 * Comentarios en el lenguaje fuente:
 *     - No soportados en esta versión.
 *
 * Literales de carácter:
 *     - No aplican al lenguaje actual.
 *
 * Operadores no definidos por la gramática:
 *     - <=, >=, &&, ||, ++, --, !
 *
 * Notación científica:
 *     - No forma parte del lexer actual.
 *
 * Identificadores con '_':
 *     - No se permiten como primer carácter.
 *
 * Extensiones tipo C++:
 *     - No se usan.
 */

/* =========================
 * 9. Cualquier otro carácter
 * =========================
 * Error léxico, pero el escaneo continúa.
 */

.            { lex_error(yytext[0]); }

/* EOF explícito */
<<EOF>>      { return 0; }

%%