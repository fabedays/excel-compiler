CC = gcc
CFLAGS = -w
NOME = excel

parser: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) y.tab.c lex.yy.c -lfl -lm
	./a.out texto.csv output.csv

y.tab.c: $(NOME).yacc
	bison $(NOME).yacc -o y.tab.c -d

lex.yy.c: $(NOME).lex
	flex $(NOME).lex

clean:
	rm -f a.out y.tab.c y.tab.h lex.yy.c
