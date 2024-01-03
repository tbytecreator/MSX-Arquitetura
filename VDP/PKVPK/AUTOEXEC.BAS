0010 CLS:KEY OFF:DEFINT A-Z
0020 ?"=============================="
0030 ?"Teste de PEEK e VPEEK         "
0040 ?"Manoel Neto 2024-1-3          "
0050 ?"=============================="
0060 ?"Comandos:                     "
0070 ?"(P)eek =>endereco &HXXXX      "
0080 ?"(V)peek=>endereco &HXXXX      "
0090 ?"(E)nd                         "
0100 ?"=============================="
0110 ?:LINE INPUT">";A$
0120 IF LEN(A$)=0 THEN 110
0130 C$=MID$(A$,1,1)
0140 IF C$="P" THEN 1000:'COMANDOPEEK
0150 IF C$="V" THEN 2000:'COMANDOVPEEK 
0160 IF C$="E" THEN 3000:'FINALIZA   
0170 BEEP:?"?";:GOTO 20

1000 ' EXECUTA PEEK NO ENDERECO 
1010 E=VAL(MID$(A$,2))
1020 FOR J=1 TO 8
1030   ? RIGHT$("0000"+HEX$(E),4);" ";
1040   FOR I=0 TO 3
1050     ? RIGHT$("00"+HEX$(PEEK(I+E)),2);" ";
1060   NEXT I
1070   FOR I=0 TO 3
1080     IF PEEK(I+E)>32 THEN ? CHR$(PEEK(I+E));" "; ELSE ?"  ";
1090   NEXT I
1100   ?
1110   E=E+4
1120 NEXT J
1130 I$ =INPUT$(1):IF I$=CHR$(27) THEN 110 ELSE ?:GOTO 1020

2000 ' EXECUTA VPEEK NO ENDERECO 
2010 E=VAL(MID$(A$,2))
2020 FOR J=1 TO 8
2030   ? RIGHT$("0000"+HEX$(E),4);" ";
2040   FOR I=0 TO 3
2050     ? RIGHT$("00"+HEX$(VPEEK(I+E)),2);" ";
2060   NEXT I
2070   FOR I=0 TO 3
2080     IF VPEEK(I+E)>32 THEN ? CHR$(VPEEK(I+E));" "; ELSE ?"  ";
2090   NEXT I
2100   ?
2110   E=E+4
2120 NEXT J
2130 I$ =INPUT$(1):IF I$=CHR$(27) THEN 110 ELSE ?:GOTO 2020

3000 ' FIM DO PROGRAMA 
3010 KEY ON:CLS
3020 END