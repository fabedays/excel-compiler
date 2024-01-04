Project compiler Excel
O projeto está a ler um ficheiro csv realiza operações aritméticas e realiza a soma de um conjunto de células com a keyword "=SOMA(células)". Uma célula é reconhecida com o regex [A-Z]+[0-9]+ e um conjunto de células é reconhecido com o regex ({cell}|{cell}:{cell})(;({cell}|{cell}:{cell}))*.
A execução do programa é realizada através do comando ./a.out origem.csv destino.csv em que origem.csv é o input e destino.csv é o output. Células sem valores númericos são lhe atribuídas o valor de zero.
