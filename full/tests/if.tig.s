
L382:
addi $sp (t108) $sp (t108) -4
sw $sp (t108) $fp (t107) 
move $fp (t107) $sp (t108) 
addi $sp (t108) $sp (t108) -12
sw $ra (t109) -4($fp (t107))
sw $s0 (t110) -8($fp (t107))
sw $s1 (t111) -12($fp (t107))
L387:
addi $s0 (t481) $r0 (t100) 2
addi $s1 (t480) $s0 (t481) 3
addi $s0 (t482) $r0 (t100) 4
beq $s1 (t480) $s0 (t482) L383
L384:
addi $s0 (t483) $r0 (t100) 1
addi $s0 (t479) $s0 (t483) 0
L385:
addi $v0 (t102) $s0 (t479) 0
j L386
L383:
addi $s0 (t484) $r0 (t100) 0
addi $s0 (t479) $s0 (t484) 0
j L385
L386:
lw $s0 (t110) -8($fp (t107))
lw $s1 (t111) -12($fp (t107))
lw $ra (t109) -4($fp (t107))
lw $fp (t107) ($fp (t107)) 
addi $sp (t108) $sp (t108) 16
jr $ra (t109)
