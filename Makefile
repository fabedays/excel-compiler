CC = gcc
CFLAGS = -Wall

parser: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) y.tab.c lex.yy.c -lfl
	./a.out texto.csv output.csv

y.tab.c: excel.yacc
	bison excel.yacc -o y.tab.c -d

lex.yy.c: excel.lex
	flex excel.lex

clean:
	rm -f a.out y.tab.c y.tab.h lex.yy.c
