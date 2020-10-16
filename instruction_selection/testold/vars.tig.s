

FUNCTION BODY 
MOVE(
 TEMP t102,
 ESEQ(
  SEQ(
     MOVE(
    MEM(
     BINOP(PLUS,
      TEMP t107,
      CONST ~4)),
    CONST 8),
     MOVE(
    MEM(
     BINOP(PLUS,
      TEMP t107,
      CONST ~8)),
    ESEQ(
     SEQ(
           MOVE(
       TEMP t232,
       CALL(
        NAME malloc,
         CONST 8)),
           SEQ(
             MOVE(
        MEM(
         BINOP(PLUS,
          TEMP t232,
          CONST 0)),
        CONST 6),
             MOVE(
        MEM(
         BINOP(PLUS,
          TEMP t232,
          CONST 4)),
        CONST 8),
),
),
     TEMP t232)),
),
  ESEQ(
   SEQ(
       EXP(
     BINOP(PLUS,
      MEM(
       BINOP(PLUS,
        TEMP t107,
        CONST ~4)),
      CONST 2)),
       EXP(
     BINOP(PLUS,
      MEM(
       BINOP(PLUS,
        TEMP t107,
        CONST ~4)),
      CONST 3)),
       EXP(
     MEM(
      BINOP(PLUS,
       MEM(
        BINOP(PLUS,
         TEMP t107,
         CONST ~8)),
       BINOP(MUL,
        CONST 0,
        CONST 4)))),
),
   MEM(
    BINOP(PLUS,
     MEM(
      BINOP(PLUS,
       TEMP t107,
       CONST ~8)),
     BINOP(MUL,
      CONST 1,
      CONST 4))))))


CANNONIZED BODY 
MOVE(
 MEM(
  BINOP(PLUS,
   TEMP t107,
   CONST ~4)),
 CONST 8)
SEQ(
 MOVE(
  TEMP t233,
  BINOP(PLUS,
   TEMP t107,
   CONST ~8)),
 MOVE(
  TEMP t232,
  CALL(
   NAME malloc,
    CONST 8)),
 SEQ(
   MOVE(
   MEM(
    BINOP(PLUS,
     TEMP t232,
     CONST 0)),
   CONST 6),
   MOVE(
   MEM(
    BINOP(PLUS,
     TEMP t232,
     CONST 4)),
   CONST 8),
),
 MOVE(
  MEM(
   TEMP t233),
  TEMP t232),
)
SEQ(
 EXP(
  BINOP(PLUS,
   MEM(
    BINOP(PLUS,
     TEMP t107,
     CONST ~4)),
   CONST 2)),
 EXP(
  BINOP(PLUS,
   MEM(
    BINOP(PLUS,
     TEMP t107,
     CONST ~4)),
   CONST 3)),
 EXP(
  MEM(
   BINOP(PLUS,
    MEM(
     BINOP(PLUS,
      TEMP t107,
      CONST ~8)),
    BINOP(MUL,
     CONST 0,
     CONST 4)))),
)
MOVE(
 TEMP t102,
 MEM(
  BINOP(PLUS,
   MEM(
    BINOP(PLUS,
     TEMP t107,
     CONST ~8)),
   BINOP(MUL,
    CONST 1,
    CONST 4))))


Instructions 
L32:
addi $t234 $r0 8
sw $t234 ~4($fp)
addi $t235 $fp ~8
addi $t233 $t235 0
lw $t236 malloc
addi $t237 $r0 8
addi $a0 $t237 0
jal $t236
addi $t232 $v0 0
addi $t238 $r0 6
sw $t238 0($t232)
addi $t239 $r0 8
sw $t239 4($t232)
sw $t233 $t232
lw $t241 ~4($fp)
addi $t240 $t241 2
lw $t243 ~4($fp)
addi $t242 $t243 3
lw $t246 ~8($fp)
addi $t248 $r0 0
addi $t249 $r0 4
mult $t248 $t249
 mflo $t247
add $t245 $t246 $t247
lw $t244 ($t245)
lw $t252 ~8($fp)
addi $t254 $r0 1
addi $t255 $r0 4
mult $t254 $t255
 mflo $t253
add $t251 $t252 $t253
lw $t250 ($t251)
addi $v0 $t250 0
lw $t256 L31
j $t256
L31:
