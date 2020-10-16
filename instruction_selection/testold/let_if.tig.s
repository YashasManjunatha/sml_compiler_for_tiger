

FUNCTION BODY 
MOVE(
 TEMP t134,
 ESEQ(
  SEQ(
     MOVE(
    MEM(
     BINOP(PLUS,
      TEMP t139,
      CONST ~4)),
    ESEQ(
     SEQ(
           CJUMP(EQ,
       BINOP(PLUS,
        CONST 2,
        CONST 3),
       CONST 4,
       L88,L89),
           LABEL L88,
           MOVE(
       TEMP t488,
       CONST 0),
           JUMP(
       NAME L90),
           LABEL L89,
           MOVE(
       TEMP t488,
       CONST 1),
           LABEL L90,
),
     TEMP t488)),
),
  ESEQ(
   SEQ(
),
   MEM(
    BINOP(PLUS,
     TEMP t139,
     CONST ~4)))))


CANNONIZED BODY 
MOVE(
 TEMP t489,
 BINOP(PLUS,
  TEMP t139,
  CONST ~4))
CJUMP(EQ,
 BINOP(PLUS,
  CONST 2,
  CONST 3),
 CONST 4,
 L88,L89)
LABEL L88
MOVE(
 TEMP t488,
 CONST 0)
JUMP(
 NAME L90)
LABEL L89
MOVE(
 TEMP t488,
 CONST 1)
LABEL L90
MOVE(
 MEM(
  TEMP t489),
 TEMP t488)
MOVE(
 TEMP t134,
 MEM(
  BINOP(PLUS,
   TEMP t139,
   CONST ~4)))


Instructions 
L92:
addi $t490 $fp ~4
addi $t489 $t490 0
addi $t492 $r0 2
addi $t491 $t492 3
addi $t493 $r0 4
beq $t491 $t493 L88
L89:
addi $t494 $r0 1
addi $t488 $t494 0
L90:
sw $t489 $t488
lw $t495 ~4($fp)
addi $v0 $t495 0
lw $t496 L91
j $t496
L88:
addi $t497 $r0 0
addi $t488 $t497 0
lw $t498 L90
j $t498
L91:
