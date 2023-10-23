05 SCREEN 0:KEY OFF:COLOR 15,1,1
10 ?"-------------------------------"
20 ?"UTILITARIOS TBYTECREATOR       "
30 ?"-------------------------------"
40 ?"(L)er e gravar slots expandidos"
50 ?"-------------------------------"
60 OP$=INPUT$(1)
70 IF OP$="L" OR OP$="l" THEN 100 
80 GOTO 10 
100 BLOAD"LGEXPNDR.BIN"
110 DEF USR0=&HC000
120 A=USR0(0)
130 GOTO 10 