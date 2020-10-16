

Instructions 
L93:
lw $t350 L94
jal $t350
lw $t351 L95
addi $t352 $r0 3
addi $a0 $t352 0
jal $t351
addi $v0 $v0 0
lw $t353 L96
j $t353
L96:


Instructions 
L95:
addi $v0 $t349 0
lw $t354 L97
j $t354
L97:


Instructions 
L94:
addi $t355 $r0 4
addi $v0 $t355 0
lw $t356 L98
j $t356
L98:
