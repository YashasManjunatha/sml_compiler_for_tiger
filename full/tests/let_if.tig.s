

Instructions 
L30:
addi $t0 $fp ~4
addi $t0 $t0 0
addi $t0 $r0 2
addi $t1 $t0 3
addi $t0 $r0 4
beq $t1 $t0 L31
L32:
addi $t0 $r0 1
addi $t0 $t0 0
L33:
sw $t0 $t0
lw $t0 ~4($fp)
addi $v0 $t0 0
j L34
L31:
addi $t0 $r0 0
addi $t0 $t0 0
j L33
L34:
