#include <stdio.h>
#include <stdlib.h>

int yyparse(void);
extern FILE *yyin;

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage : %s <fichier_source>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin)
    {
        perror("Erreur ouverture fichier");
        return 1;
    }

    if (yyparse() == 0)
    {
        printf("Syntaxe correcte.\n");
    }
    else
    {
        printf("Syntaxe incorrecte.\n");
    }

    fclose(yyin);
    return 0;
}