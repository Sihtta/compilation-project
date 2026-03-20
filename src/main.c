#include <stdio.h>
#include <stdlib.h>

/*
yyparse() est la fonction principale générée par Bison.
Elle lance l'analyse syntaxique du programme.
*/
int yyparse(void);

/*
yyin est une variable globale utilisée par Flex.
Elle indique au lexer quel fichier lire.
*/
extern FILE *yyin;

int main(int argc, char **argv)
{
    /*
    On attend exactement 2 arguments :
    parser.exe fichier_source
    */

    if (argc != 2)
    {
        fprintf(stderr, "Usage : %s <fichier_source>\n", argv[0]);
        return 1;
    }

    /*
    On ouvre le fichier passé en argument et on le donne au lexer via yyin.
    */

    yyin = fopen(argv[1], "r");

    if (!yyin)
    {
        perror("Erreur ouverture fichier");
        return 1;
    }

    /*
    yyparse() lance l'analyse syntaxique. Retourne :
    0  si syntaxe correcte
    ≠0 si erreur syntaxique
    */

    if (yyparse() == 0)
    {
        printf("Syntaxe correcte.\n");
    }
    else
    {
        printf("Syntaxe incorrecte.\n");
    }

    /* fermeture du fichier */

    fclose(yyin);

    return 0;
}