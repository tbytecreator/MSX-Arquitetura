0001 ?"====================================="
0002 ?"TByteCreator ASM Monitor"
0003 ?"Manoel Neto 2022-12-19"
0004 ?"====================================="
0005 ?"Comandos:                            "
0006 ?"(D)ump   =>endereco em hexa &HXXXX   "
0007 ?"(M)odify =>endereco em hexa &HXXXX   "
0008 ?"(L)oad   =>endereco em hexa &HXXXX   "
0009 ?"(E)nd                                "
0010 ?"(?) Este HELP!                       "
0011 ?"====================================="
0012 RETURN
0000 ' FINALIZA O PROGRAMA
0010 KEY 1,"color":KEY 2,"auto":KEY 3,"goto":KEY 5,"list"+CHR$(13):KEY 4,"run"+CHR$(13)
0020 CLS
0030 END