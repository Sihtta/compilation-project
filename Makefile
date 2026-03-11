all: parser.exe

parser.exe: parser.tab.c lex.yy.c src/main.c
	gcc -o parser.exe parser.tab.c lex.yy.c src/main.c

parser.tab.c parser.tab.h: src/parser.y
	bison -d -o parser.tab.c src/parser.y

lex.yy.c: src/lexer.l parser.tab.h
	flex -o lex.yy.c src/lexer.l

clean:
	del /Q parser.exe parser.tab.c parser.tab.h lex.yy.c 2>NUL || exit 0