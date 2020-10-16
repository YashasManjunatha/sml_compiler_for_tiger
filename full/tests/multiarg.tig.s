
L597:
addi $sp $sp -4
sw $sp $fp 
move $fp $sp 
addi $sp $sp -36
sw $ra -4($fp)
sw $s0 -8($fp)
sw $s1 -12($fp)
sw $s2 -16($fp)
sw $s3 -20($fp)
sw $s4 -24($fp)
sw $s5 -28($fp)
sw $s6 -32($fp)
sw $s7 -36($fp)
L603:
addi $t0 $r0 5
addi $a0 $t0 0
jal L598
addi $v0 $v0 0
j L602
L602:
lw $s0 -8($fp)
lw $s1 -12($fp)
lw $s2 -16($fp)
lw $s3 -20($fp)
lw $s4 -24($fp)
lw $s5 -28($fp)
lw $s6 -32($fp)
lw $s7 -36($fp)
lw $ra -4($fp)
lw $fp ($fp) 
addi $sp $sp 40
jr $ra

L598:
addi $sp $sp -8
sw $sp $fp 
move $fp $sp 
addi $sp $sp -40
sw $ra -8($fp)
sw $s0 -12($fp)
sw $s1 -16($fp)
sw $s2 -20($fp)
sw $s3 -24($fp)
sw $s4 -28($fp)
sw $s5 -32($fp)
sw $s6 -36($fp)
sw $s7 -40($fp)
L605:
sw $a0 4($fp)
addi $t0 $r0 2
sw $t0 ~4($fp)
lw $t1 4($fp)
addi $t0 $r0 0
beq $t1 $t0 L599
L600:
lw $t0 4($fp)
addi $s0 $t0 0
lw $t0 4($fp)
addi $t0 $t0 -1
addi $a0 $t0 0
jal L598
addi $t0 $v0 0
mult $s0 $t0
mflo $t1
lw $t0 ~4($fp)
add $t0 $t1 $t0
addi $t0 $t0 0
L601:
addi $v0 $t0 0
j L604
L599:
addi $t0 $r0 1
addi $t0 $t0 0
j L601
L604:
lw $s0 -12($fp)
lw $s1 -16($fp)
lw $s2 -20($fp)
lw $s3 -24($fp)
lw $s4 -28($fp)
lw $s5 -32($fp)
lw $s6 -36($fp)
lw $s7 -40($fp)
lw $ra -8($fp)
lw $fp ($fp) 
addi $sp $sp 48
jr $ra
