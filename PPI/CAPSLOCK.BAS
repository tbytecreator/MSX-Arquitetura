010 ' ==================================
020 ' VERIFICAR O STATUS DO CAPSLOCK
040 ' ==================================
050 ?
060 ? "================================"
070 ? "APERTE QUALQUER TECLA           "
080 ? "OU <ESC> PARA SAIR              "
090 ? "================================"
100 OP$=INPUT$(1)
110 IF OP$ = CHR$(27) THEN 170  
130 X=INP(170)
140 IF X=26 THEN 180 ELSE 200
160 GOTO 50
170 RUN "AUTOEXEC.BAS"
180 ?"CAPS EM MAIUSCULAS"
190 GOTO 50
200 ? "caps em minusculas"
210 GOTO 50 