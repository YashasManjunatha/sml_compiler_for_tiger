

Instructions 
L161:
addi $t623 $r0 10
sw $t623 ~4($fp)
lw $t624 L162
jal $t624
addi $v0 $v0 0
j L164
L164:


Instructions 
L163:
addi $t625 $r0 5
sw $t625 ~4($fp)
lw $t626 ~4($fp)
addi $v0 $t626 0
j L165
L165:


Instructions 
L162:
lw $t628 ($fp)
lw $t627 ~4($t628)
addi $v0 $t627 0
j L166
L166:
