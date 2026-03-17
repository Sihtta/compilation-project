%option yylineno

%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
%}

%%

"program"               { return PROGRAMME; }

"real"                  { return REEL; }
"bool"                  { return BOOLEEN; }

"true"                  { return VRAI; }
"false"                 { return FAUX; }

"if"                    { return SI; }
"else"                  { return SINON; }
"while"                 { return TANTQUE; }

"{"                     { return ACCOLADE_OUVRANTE; }
"}"                     { return ACCOLADE_FERMANTE; }

"("                     { return PARENTHESE_OUVRANTE; }
")"                     { return PARENTHESE_FERMANTE; }

"["                     { return CROCHET_OUVRANT; }
"]"                     { return CROCHET_FERMANT; }

";"                     { return POINT_VIRGULE; }
","                     { return VIRGULE; }

"="                     { return AFFECTATION; }

"+"                     { return PLUS; }
"-"                     { return MOINS; }
"*"                     { return FOIS; }
"/"                     { return DIVISE; }

">="                    { return SUPERIEUR_OU_EGAL; }
"<="                    { return INFERIEUR_OU_EGAL; }
"=="                    { return EGAL; }
"!="                    { return DIFFERENT; }
">"                     { return SUPERIEUR; }
"<"                     { return INFERIEUR; }

"&&"                    { return ET; }
"||"                    { return OU; }
"!"                     { return NON; }

[0-9]+(\.[0-9]+)?       {
                            yylval.valeur_reelle = atof(yytext);
                            return NOMBRE;
                        }

[a-zA-Z_][a-zA-Z0-9_]*  {
                            yylval.chaine = strdup(yytext);
                            return IDENTIFIANT;
                        }

"//".*                  { }

[ \t\r\n]+              { }

.                       {
                            printf("Caractère inconnu ligne %d : %s\n", yylineno, yytext);
                        }

%%

int yywrap(void) {
    return 1;
}