%{
#include <stdio.h>
#include <stdlib.h>

/* Fonction du lexer Flex appelée par Bison pour obtenir le token suivant */
int yylex(void);

/* Fonction appelée par Bison lorsqu'une erreur syntaxique est détectée */
void yyerror(const char *s);
extern int yylineno;
%}

/* 
%union définit les types de valeurs que les tokens peuvent transporter.
Ici :
- NUMBER transporte un réel
- ID transporte une chaîne de caractères
*/
%union {
    double realval;
    char* strval;
}

/* Déclaration des tokens simples */
%token PROGRAM
%token REAL BOOL
%token TRUE FALSE

/* Tokens avec valeur associée */
%token <strval> ID
%token <realval> NUMBER

%token ASSIGN SEMICOLON
%token LBRACE RBRACE
%token LPAREN RPAREN
%token PLUS MINUS TIMES DIVIDE

/* Priorités des opérateurs : * et / plus prioritaires que + et - */
%left PLUS MINUS
%left TIMES DIVIDE

%%

/* Un programme est de la forme : program { ... } */
program:
    PROGRAM LBRACE stmt_list RBRACE
    ;

/* 
Une liste d'instructions contient :
- soit plusieurs instructions
- soit rien du tout (règle vide)
*/
stmt_list:
    stmt_list stmt
    |
    ;

/* Une instruction peut être une déclaration ou une affectation */
stmt:
    decl_stmt
    | assign_stmt
    ;

/* Déclaration de variable : real x; ou bool ok; */
decl_stmt:
    REAL ID SEMICOLON
    | BOOL ID SEMICOLON
    ;

/* Affectation : x = expr; */
assign_stmt:
    ID ASSIGN expr SEMICOLON
    ;

/* Expressions autorisées */
expr:
    expr PLUS expr
    | expr MINUS expr
    | expr TIMES expr
    | expr DIVIDE expr
    | LPAREN expr RPAREN
    | NUMBER
    | ID
    | TRUE
    | FALSE
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Ligne %d : %s\n", yylineno, s);
}