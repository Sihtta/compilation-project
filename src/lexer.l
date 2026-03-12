%option yylineno

%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
%}

%%

"program"               { return PROGRAM; }
"real"                  { return REAL; }
"bool"                  { return BOOL; }
"true"                  { return TRUE; }
"false"                 { return FALSE; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }

"{"                     { return LBRACE; }
"}"                     { return RBRACE; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
";"                     { return SEMICOLON; }

"="                     { return ASSIGN; }

"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return TIMES; }
"/"                     { return DIVIDE; }

">="                    { return GE; }
"<="                    { return LE; }
"=="                    { return EQ; }
"!="                    { return NE; }
">"                     { return GT; }
"<"                     { return LT; }

"&&"                    { return AND; }
"||"                    { return OR; }
"!"                     { return NOT; }

[0-9]+(\.[0-9]+)?       { yylval.realval = atof(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.strval = strdup(yytext); return ID; }

"//".*                  { }

[ \t\r\n]+              { }

.                       { printf("Caractère inconnu : %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}