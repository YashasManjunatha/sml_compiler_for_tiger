

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
    ESEQ(
     SEQ(
           MOVE(
       TEMP t222,
       CALL(
        NAME malloc,
         CONST 8)),
           SEQ(
             MOVE(
        MEM(
         BINOP(PLUS,
          TEMP t222,
          CONST 0)),
        CONST 3),
             MOVE(
        MEM(
         BINOP(PLUS,
          TEMP t222,
          CONST 4)),
        CONST 4),
),
),
     TEMP t222)),
     MOVE(
    MEM(
     BINOP(PLUS,
      TEMP t107,
      CONST ~8)),
    CONST 0),
),
  ESEQ(
   SEQ(
),
   MEM(
    BINOP(PLUS,
     TEMP t107,
     CONST ~8)))))


CANNONIZED BODY 
SEQ(
 MOVE(
  TEMP t223,
  BINOP(PLUS,
   TEMP t107,
   CONST ~4)),
 MOVE(
  TEMP t222,
  CALL(
   NAME malloc,
    CONST 8)),
 SEQ(
   MOVE(
   MEM(
    BINOP(PLUS,
     TEMP t222,
     CONST 0)),
   CONST 3),
   MOVE(
   MEM(
    BINOP(PLUS,
     TEMP t222,
     CONST 4)),
   CONST 4),
),
 MOVE(
  MEM(
   TEMP t223),
  TEMP t222),
)
MOVE(
 MEM(
  BINOP(PLUS,
   TEMP t107,
   CONST ~8)),
 CONST 0)
MOVE(
 TEMP t102,
 MEM(
  BINOP(PLUS,
   TEMP t107,
   CONST ~8)))


Instructions 
L29:
addi $t224 $fp ~4
addi $t223 $t224 0
lw $t225 malloc
addi $t226 $r0 8
addi $a0 $t226 0
jal $t225
addi $t222 $v0 0
addi $t227 $r0 3
sw $t227 0($t222)
addi $t228 $r0 4
sw $t228 4($t222)
sw $t223 $t222
addi $t229 $r0 0
sw $t229 ~8($fp)
lw $t230 ~8($fp)
addi $v0 $t230 0
lw $t231 L28
j $t231
L28:
