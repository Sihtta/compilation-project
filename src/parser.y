%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Fonction appelée par Bison pour lire le prochain token */
int yylex(void);

/* Fonction appelée lorsqu'une erreur syntaxique est détectée */
void yyerror(const char *message);
extern int yylineno;

#define MAX_VARIABLES 100

typedef struct {
    char* nom;
    double valeur;
} Variable;

Variable table_symboles[MAX_VARIABLES];
int nombre_variables = 0;

/* Enregistre ou met à jour une variable simple */
void definir_variable(const char* nom, double valeur) {
    for (int i = 0; i < nombre_variables; i++) {
        if (strcmp(table_symboles[i].nom, nom) == 0) {
            table_symboles[i].valeur = valeur;
            return;
        }
    }

    if (nombre_variables < MAX_VARIABLES) {
        table_symboles[nombre_variables].nom = strdup(nom);
        table_symboles[nombre_variables].valeur = valeur;
        nombre_variables++;
    }
}

/* Récupère la valeur d'une variable simple */
double lire_variable(const char* nom) {
    for (int i = 0; i < nombre_variables; i++) {
        if (strcmp(table_symboles[i].nom, nom) == 0) {
            return table_symboles[i].valeur;
        }
    }

    fprintf(stderr, "Avertissement ligne %d : variable '%s' non initialisée, valeur 0 utilisée.\n", yylineno, nom);
    return 0;
}
%}

/*
Types transportés par certains tokens/non-terminaux :
- NOMBRE transporte un réel
- IDENTIFIANT transporte une chaîne
- expression et acces_tableau retournent un réel
*/
%union {
    double valeur_reelle;
    char* chaine;
}

/* Tokens sans valeur */
%token PROGRAMME
%token REEL BOOLEEN
%token VRAI FAUX

%token SI SINON TANTQUE

%token AFFECTATION POINT_VIRGULE VIRGULE

%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token CROCHET_OUVRANT CROCHET_FERMANT

%token PLUS MOINS FOIS DIVISE

%token SUPERIEUR INFERIEUR SUPERIEUR_OU_EGAL INFERIEUR_OU_EGAL EGAL DIFFERENT
%token ET OU NON

/* Tokens avec valeur */
%token <chaine> IDENTIFIANT
%token <valeur_reelle> NOMBRE

/* Non-terminaux typés */
%type <valeur_reelle> expression
%type <valeur_reelle> acces_tableau

/* Priorités */
%left OU
%left ET
%right NON

%left SUPERIEUR INFERIEUR SUPERIEUR_OU_EGAL INFERIEUR_OU_EGAL EGAL DIFFERENT
%left PLUS MOINS
%left FOIS DIVISE

%%

programme:
    PROGRAMME ACCOLADE_OUVRANTE liste_instructions ACCOLADE_FERMANTE
    ;

liste_instructions:
    liste_instructions instruction
    |
    ;

instruction:
    declaration
    | affectation
    | instruction_si
    | instruction_tantque
    ;

declaration:
    REEL IDENTIFIANT POINT_VIRGULE
    {
        definir_variable($2, 0);
    }
    | BOOLEEN IDENTIFIANT POINT_VIRGULE
    {
        definir_variable($2, 0);
    }
    | REEL IDENTIFIANT CROCHET_OUVRANT NOMBRE CROCHET_FERMANT POINT_VIRGULE
    {
        printf("Declaration tableau reel : %s[%.0f]\n", $2, $4);
    }
    | BOOLEEN IDENTIFIANT CROCHET_OUVRANT NOMBRE CROCHET_FERMANT POINT_VIRGULE
    {
        printf("Declaration tableau booleen : %s[%.0f]\n", $2, $4);
    }
    ;

affectation:
    IDENTIFIANT AFFECTATION expression POINT_VIRGULE
    {
        definir_variable($1, $3);
        printf("%s = %.2f\n", $1, $3);
    }
    | IDENTIFIANT CROCHET_OUVRANT expression CROCHET_FERMANT AFFECTATION expression POINT_VIRGULE
    {
        printf("%s[%.0f] = %.2f\n", $1, $3, $6);
    }
    | IDENTIFIANT AFFECTATION liste_litterale POINT_VIRGULE
    {
        printf("%s = [liste]\n", $1);
    }
    ;

instruction_si:
    SI PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE
    ACCOLADE_OUVRANTE liste_instructions ACCOLADE_FERMANTE
    | SI PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE
      ACCOLADE_OUVRANTE liste_instructions ACCOLADE_FERMANTE
      SINON
      ACCOLADE_OUVRANTE liste_instructions ACCOLADE_FERMANTE
    ;

instruction_tantque:
    TANTQUE PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE
    ACCOLADE_OUVRANTE liste_instructions ACCOLADE_FERMANTE
    ;

liste_litterale:
    CROCHET_OUVRANT liste_expressions CROCHET_FERMANT
    ;

liste_expressions:
    expression
    | liste_expressions VIRGULE expression
    ;

acces_tableau:
    IDENTIFIANT CROCHET_OUVRANT expression CROCHET_FERMANT
    {
        /* On reste surtout sur l’analyse syntaxique.
           On renvoie une valeur fictive pour permettre les expressions. */
        $$ = 0;
    }
    ;

expression:
    expression PLUS expression
    {
        $$ = $1 + $3;
    }
    | expression MOINS expression
    {
        $$ = $1 - $3;
    }
    | expression FOIS expression
    {
        $$ = $1 * $3;
    }
    | expression DIVISE expression
    {
        $$ = $1 / $3;
    }

    | expression SUPERIEUR expression
    {
        $$ = ($1 > $3);
    }
    | expression INFERIEUR expression
    {
        $$ = ($1 < $3);
    }
    | expression SUPERIEUR_OU_EGAL expression
    {
        $$ = ($1 >= $3);
    }
    | expression INFERIEUR_OU_EGAL expression
    {
        $$ = ($1 <= $3);
    }
    | expression EGAL expression
    {
        $$ = ($1 == $3);
    }
    | expression DIFFERENT expression
    {
        $$ = ($1 != $3);
    }

    | expression ET expression
    {
        $$ = ($1 && $3);
    }
    | expression OU expression
    {
        $$ = ($1 || $3);
    }
    | NON expression
    {
        $$ = (!$2);
    }

    | PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE
    {
        $$ = $2;
    }
    | NOMBRE
    {
        $$ = $1;
    }
    | IDENTIFIANT
    {
        $$ = lire_variable($1);
    }
    | acces_tableau
    {
        $$ = $1;
    }
    | VRAI
    {
        $$ = 1;
    }
    | FAUX
    {
        $$ = 0;
    }
    ;

%%

void yyerror(const char *message) {
    fprintf(stderr, "Erreur syntaxique ligne %d : %s\n", yylineno, message);
}