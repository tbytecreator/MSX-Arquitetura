SCREEN 0:KEY OFF:COLOR 15,1,1
10 ?"-------------------------------"
20 ?"UTILITARIOS TBYTECREATOR       "
30 ?"-------------------------------"
40 ?"(D)ESCOBRIR SLOTS EXPADIDOS    "
50 ?"-------------------------------"
60 OP$=INPUT$(1)
70 IF OP$="D" OR OP$="d" THEN 100 
80 GOTO 10 
100 BLOAD"EXPANDER.BIN"
110 DEF USR0=&HC000
120 A=USR0(0)
130 GOTO 10 