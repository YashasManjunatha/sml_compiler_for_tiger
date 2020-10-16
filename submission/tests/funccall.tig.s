
L660:
addi $sp $sp -4
sw $sp $fp 
move $fp $sp 
addi $sp $sp -4
sw $ra -4($fp)
L664:
jal L661
addi $t0 $r0 2
addi $a0 $t0 0
jal L662
addi $v0 $v0 0
j L663
L663:
lw $ra -4($fp)
lw $fp ($fp) 
addi $sp $sp 8
jr $ra

L662:
addi $sp $sp -8
sw $sp $fp 
move $fp $sp 
addi $sp $sp -4
sw $ra -4($fp)
L666:
sw $a0 4($fp)
lw $t0 4($fp)
addi $t0 $t0 1
addi $v0 $t0 0
j L665
L665:
lw $ra -4($fp)
lw $fp ($fp) 
addi $sp $sp 12
jr $ra

L661:
addi $sp $sp -4
sw $sp $fp 
move $fp $sp 
addi $sp $sp -4
sw $ra -4($fp)
L668:
addi $t0 $r0 5
addi $v0 $t0 0
j L667
L667:
lw $ra -4($fp)
lw $fp ($fp) 
addi $sp $sp 8
jr $ra
