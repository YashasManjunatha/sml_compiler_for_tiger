

Instructions 
L191:
addi $t646 $r0 10
sw $t646 ~4($fp)
jal L193
addi $v0 $v0 0
j L194
L194:


Instructions 
L193:
addi $t647 $r0 6
addi $a0 $t647 0
jal L192
addi $v0 $v0 0
j L195
L195:


Instructions 
L192:
lw $t649 ($fp)
lw $t648 ~4($t649)
addi $v0 $t648 0
j L196
L196:
