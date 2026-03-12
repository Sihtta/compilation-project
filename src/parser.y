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

/* Nouveaux mots-clés du langage */
%token IF ELSE WHILE

/* Opérateurs de comparaison */
%token GT LT GE LE EQ NE

/* Opérateurs booléens */
%token AND OR NOT

/* Priorités des opérateurs : * et / plus prioritaires que + et - */
%left PLUS MINUS
%left TIMES DIVIDE

/* Priorités pour les comparaisons */
%left GT LT GE LE EQ NE

/* Priorités pour les opérateurs booléens */
%left OR
%left AND
%right NOT

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

/* Une instruction peut être une déclaration, une affectation,
   ou une structure de contrôle */
stmt:
    decl_stmt
    | assign_stmt
    | if_stmt
    | while_stmt
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

/* Instruction conditionnelle */
if_stmt:
    IF LPAREN expr RPAREN LBRACE stmt_list RBRACE
    | IF LPAREN expr RPAREN LBRACE stmt_list RBRACE
      ELSE LBRACE stmt_list RBRACE
    ;

/* Boucle while */
while_stmt:
    WHILE LPAREN expr RPAREN LBRACE stmt_list RBRACE
    ;

/* Expressions autorisées */
expr:
    expr PLUS expr
    | expr MINUS expr
    | expr TIMES expr
    | expr DIVIDE expr

    /* comparaisons entre expressions */
    | expr GT expr
    | expr LT expr
    | expr GE expr
    | expr LE expr
    | expr EQ expr
    | expr NE expr

    /* opérateurs booléens */
    | expr AND expr
    | expr OR expr
    | NOT expr

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