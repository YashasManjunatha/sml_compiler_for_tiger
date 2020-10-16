

FUNCTION BODY 
SEQ(
 MOVE(
  MEM(
   BINOP(PLUS,
    TEMP t853,
    CONST 0)),
  TEMP t874),
 MOVE(
  TEMP t848,
  ESEQ(
   SEQ(
       MOVE(
     MEM(
      BINOP(PLUS,
       TEMP t853,
       CONST ~8)),
     CONST 10),
),
   ESEQ(
    SEQ(
),
    CALL(
     NAME L283)))),
)


CANNONIZED BODY 
MOVE(
 MEM(
  BINOP(PLUS,
   TEMP t853,
   CONST 0)),
 TEMP t874)
MOVE(
 MEM(
  BINOP(PLUS,
   TEMP t853,
   CONST ~8)),
 CONST 10)
MOVE(
 TEMP t848,
 CALL(
  NAME L283))

L286:
sw $a0 0($fp)
addi $t0 $r0 10
sw $t0 ~8($fp)
jal L283
addi $v0 $v0 0
j L285
L285:


FUNCTION BODY 
SEQ(
 MOVE(
  MEM(
   BINOP(PLUS,
    TEMP t853,
    CONST 0)),
  TEMP t874),
 MOVE(
  TEMP t848,
  ESEQ(
   SEQ(
       MOVE(
     MEM(
      BINOP(PLUS,
       TEMP t853,
       CONST ~8)),
     CONST 5),
),
   ESEQ(
    SEQ(
),
    MEM(
     BINOP(PLUS,
      TEMP t853,
      CONST ~8))))),
)


CANNONIZED BODY 
MOVE(
 MEM(
  BINOP(PLUS,
   TEMP t853,
   CONST 0)),
 TEMP t874)
MOVE(
 MEM(
  BINOP(PLUS,
   TEMP t853,
   CONST ~8)),
 CONST 5)
MOVE(
 TEMP t848,
 MEM(
  BINOP(PLUS,
   TEMP t853,
   CONST ~8)))

L288:
sw $a0 0($fp)
addi $t0 $r0 5
sw $t0 ~8($fp)
lw $t0 ~8($fp)
addi $v0 $t0 0
j L287
L287:


FUNCTION BODY 
SEQ(
 MOVE(
  MEM(
   BINOP(PLUS,
    TEMP t853,
    CONST 0)),
  TEMP t874),
 MOVE(
  TEMP t848,
  MEM(
   BINOP(PLUS,
    MEM(
     TEMP t853),
    CONST ~8))),
)


CANNONIZED BODY 
MOVE(
 MEM(
  BINOP(PLUS,
   TEMP t853,
   CONST 0)),
 TEMP t874)
MOVE(
 TEMP t848,
 MEM(
  BINOP(PLUS,
   MEM(
    TEMP t853),
   CONST ~8)))

L290:
sw $a0 0($fp)
lw $t0 ($fp)
lw $t0 ~8($t0)
addi $v0 $t0 0
j L289
L289:
