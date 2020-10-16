

FUNCTION BODY 
MOVE(
 TEMP t296,
 ESEQ(
  SEQ(
),
  ESEQ(
   SEQ(
),
   ESEQ(
    SEQ(
         CJUMP(EQ,
      BINOP(PLUS,
       CONST 2,
       CONST 3),
      CONST 4,
      L147,L148),
         LABEL L147,
         MOVE(
      TEMP t398,
      CONST 0),
         JUMP(
      NAME L149),
         LABEL L148,
         MOVE(
      TEMP t398,
      CONST 1),
         LABEL L149,
),
    TEMP t398))))


CANNONIZED BODY 
CJUMP(EQ,
 BINOP(PLUS,
  CONST 2,
  CONST 3),
 CONST 4,
 L147,L148)
LABEL L147
MOVE(
 TEMP t398,
 CONST 0)
JUMP(
 NAME L149)
LABEL L148
MOVE(
 TEMP t398,
 CONST 1)
LABEL L149
MOVE(
 TEMP t296,
 TEMP t398)


Instructions 
L151:
addi $t400 $r0 2
addi $t399 $t400 3
addi $t401 $r0 4
beq $t399 $t401 L147
L148:
addi $t402 $r0 1
addi $t398 $t402 0
L149:
addi $v0 $t398 0
j L150
L147:
addi $t403 $r0 0
addi $t398 $t403 0
j L149
L150:
