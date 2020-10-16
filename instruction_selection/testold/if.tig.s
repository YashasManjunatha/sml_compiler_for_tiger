

Instructions 
L0:
addi $t134 $r0 2
addi $t133 $t134 3
addi $t135 $r0 4
beq $t133 $t135 L1
L1:
addi $t136 $r0 0
addi $t132 $t136 0
j L3
L2:
addi $t137 $r0 1
addi $t132 $t137 0
L3:
addi $v0 $t132 0
j L4
L4:
