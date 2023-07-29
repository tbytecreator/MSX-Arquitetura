0010 SCREEN 0:WIDTH 40:KEY OFF:CLS:COLOR 15,1,1
0020 ?"================================"
0030 ?"ANALISE DA PPI MSX              "
0040 ?"================================"
0050 ?"(S)lots populados com RAM       "
0060 ?"(C)aps lock                     "
1000 ?"================================"
1010 ?">";:OP$=INPUT$(1)
1020 IF OP$="S" OR OP$="s" THEN RUN"SLOTS.BAS"
1030 IF OP$="C" OR OP$="c" THEN RUN"CAPSLOCK.BAS"
2000 GOTO 10