010 ' ==================================
020 ' ESTE COMAMNDO VERIFICA QUAIS SLOTS
030 ' POSSUEM MEMORIA RAM CONECTADA
040 ' ==================================
050 ?
060 ? "================================"
070 ? "SLOTS"
080 ? "================================"
090 SP=INP(&HA8):' LE O SLOT PRIMARIO
100 BN$=BIN$(SP):' CONVERTEMOS PARA BIN
110 P3=VAL("&B"+MID$(BN$,1,2))
120 P2=VAL("&B"+MID$(BN$,3,2))
130 P1=VAL("&B"+MID$(BN$,5,2))
140 P0=VAL("&B"+MID$(BN$,7,2))
150 ?"PAGINA 0=>";P0
160 ?"PAGINA 1=>";P1
170 ?"PAGINA 2=>";P2
180 ?"PAGINA 3=>";P3
190 ? "================================"
200 OP$=INPUT$(1)
210 RUN "AUTOEXEC.BAS"