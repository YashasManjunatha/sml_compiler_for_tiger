.data
L1845:
 .word L1845_data
L1845_data:
 .word 1
 .ascii "\n"
L1842:
 .word L1842_data
L1842_data:
 .word 1
 .ascii "\n"
L1836:
 .word L1836_data
L1836_data:
 .word 2
 .ascii " ."
L1835:
 .word L1835_data
L1835_data:
 .word 2
 .ascii " O"
L1826:
 .word L1826_data
L1826_data:
 .word 1
 .ascii "0"
L1825:
 .word L1825_data
L1825_data:
 .word 1
 .ascii "-"
L1821:
 .word L1821_data
L1821_data:
 .word 1
 .ascii "0"

.text
tig_main:

L1816:
addi $sp $sp -36
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
addi $fp $sp 32
L1866:
sw $a0 0($fp)
addi $s0, $0, 8
sw $s0 -4($fp)
addi $s0, $fp, -8
move $s0, $s0
lw $t0 -4($fp)
move $a0, $t0
addi $t0, $0, 0
move $a1, $t0
jal tig_initArray
move $t0, $v0
addi $t0, $t0, 4
move $t0, $t0
sw $t0 ($s0)
addi $s0, $fp, -12
move $s0, $s0
lw $t0 -4($fp)
move $a0, $t0
addi $t0, $0, 0
move $a1, $t0
jal tig_initArray
move $t0, $v0
addi $t0, $t0, 4
move $t0, $t0
sw $t0 ($s0)
addi $s0, $fp, -16
move $s0, $s0
lw $t0 -4($fp)
lw $t1 -4($fp)
add $t0, $t0, $t1
addi $t0, $t0, -1
move $a0, $t0
addi $t0, $0, 0
move $a1, $t0
jal tig_initArray
move $t0, $v0
addi $t0, $t0, 4
move $t0, $t0
sw $t0 ($s0)
addi $s0, $fp, -20
move $s0, $s0
lw $t0 -4($fp)
lw $t1 -4($fp)
add $t0, $t0, $t1
addi $t0, $t0, -1
move $a0, $t0
addi $t0, $0, 0
move $a1, $t0
jal tig_initArray
move $t0, $v0
addi $t0, $t0, 4
move $t0, $t0
sw $t0 ($s0)
move $a0, $fp
addi $s0, $0, 0
move $a1, $s0
jal L1819
move $v0, $v0
j L1865
L1865:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
addi $sp $sp 36
jr $ra

L1819:
addi $sp $sp -20
sw $ra 0($sp)
sw $fp 4($sp)
addi $fp $sp 12
L1868:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t1 4($fp)
lw $t0 0($fp)
lw $t0 -4($t0)
beq $t1, $t0, L1862
L1863:
addi $t0, $0, 0
sw $t0 -4($fp)
lw $t1 -4($fp)
lw $t0 0($fp)
lw $t0 -4($t0)
addi $t0, $t0, -1
sub $t0, $t1, $t0
bgtz $t0, L1846
L1860:
lw $t0 0($fp)
move $a0, $t0
lw $t0 -4($fp)
move $a1, $t0
jal L1817
lw $t0 0($fp)
lw $t2 -8($t0)
lw $t1 -4($fp)
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t0, $t2, $t0
lw $t1 ($t0)
addi $t0, $0, 0
beq $t1, $t0, L1849
L1850:
addi $t0, $0, 0
move $t1, $t0
L1851:
addi $t0, $0, 0
bne $t0, $t1, L1854
L1855:
addi $t0, $0, 0
move $t1, $t0
L1856:
addi $t0, $0, 0
bne $t0, $t1, L1857
L1858:
addi $t0, $0, 0
move $t0, $t0
L1859:
lw $t1 -4($fp)
lw $t0 0($fp)
lw $t0 -4($t0)
addi $t0, $t0, -1
sub $t0, $t1, $t0
bgez $t0, L1846
L1861:
lw $t0 -4($fp)
addi $t0, $t0, 1
sw $t0 -4($fp)
j L1860
L1862:
lw $t0 0($fp)
move $a0, $t0
jal L1818
move $t0, $v0
L1864:
move $v0, $t0
j L1867
L1849:
addi $t0, $0, 1
move $t3, $t0
lw $t0 0($fp)
lw $t2 -16($t0)
lw $t1 -4($fp)
lw $t0 4($fp)
add $t1, $t1, $t0
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t0, $t2, $t0
lw $t1 ($t0)
addi $t0, $0, 0
beq $t1, $t0, L1847
L1848:
addi $t0, $0, 0
move $t3, $t0
L1847:
move $t1, $t3
j L1851
L1854:
addi $t0, $0, 1
move $t3, $t0
lw $t0 0($fp)
lw $t2 -20($t0)
lw $t0 -4($fp)
addi $t1, $t0, 7
lw $t0 4($fp)
sub $t1 $t1 $t0
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t0, $t2, $t0
lw $t1 ($t0)
addi $t0, $0, 0
beq $t1, $t0, L1852
L1853:
addi $t0, $0, 0
move $t3, $t0
L1852:
move $t1, $t3
j L1856
L1857:
lw $t0 0($fp)
lw $t2 -8($t0)
lw $t1 -4($fp)
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t1, $t2, $t0
addi $t0, $0, 1
sw $t0 ($t1)
lw $t0 0($fp)
lw $t2 -16($t0)
lw $t1 -4($fp)
lw $t0 4($fp)
add $t1, $t1, $t0
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t1, $t2, $t0
addi $t0, $0, 1
sw $t0 ($t1)
lw $t0 0($fp)
lw $t2 -20($t0)
lw $t0 -4($fp)
addi $t1, $t0, 7
lw $t0 4($fp)
sub $t1 $t1 $t0
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t1, $t2, $t0
addi $t0, $0, 1
sw $t0 ($t1)
lw $t0 0($fp)
lw $t2 -12($t0)
lw $t1 4($fp)
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t1, $t2, $t0
lw $t0 -4($fp)
sw $t0 ($t1)
lw $t0 0($fp)
move $a0, $t0
lw $t0 4($fp)
addi $t0, $t0, 1
move $a1, $t0
jal L1819
lw $t0 0($fp)
lw $t2 -8($t0)
lw $t1 -4($fp)
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t1, $t2, $t0
addi $t0, $0, 0
sw $t0 ($t1)
lw $t0 0($fp)
lw $t2 -16($t0)
lw $t1 -4($fp)
lw $t0 4($fp)
add $t1, $t1, $t0
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t1, $t2, $t0
addi $t0, $0, 0
sw $t0 ($t1)
lw $t0 0($fp)
lw $t2 -20($t0)
lw $t0 -4($fp)
addi $t1, $t0, 7
lw $t0 4($fp)
sub $t1 $t1 $t0
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t1, $t2, $t0
addi $t0, $0, 0
sw $t0 ($t1)
addi $t0, $0, 0
move $t0, $t0
j L1859
L1846:
addi $t0, $0, 0
move $t0, $t0
j L1864
L1867:
lw $ra 0($sp)
lw $fp 4($sp)
addi $sp $sp 20
jr $ra

L1818:
addi $sp $sp -20
sw $ra 0($sp)
sw $fp 4($sp)
addi $fp $sp 16
L1870:
sw $a0 0($fp)
addi $t0, $0, 0
sw $t0 -4($fp)
lw $t1 -4($fp)
lw $t0 0($fp)
lw $t0 -4($t0)
addi $t0, $t0, -1
sub $t0, $t1, $t0
bgtz $t0, L1833
L1843:
addi $t0, $0, 0
sw $t0 -8($fp)
lw $t1 -8($fp)
lw $t0 0($fp)
lw $t0 -4($t0)
addi $t0, $t0, -1
sub $t0, $t1, $t0
bgtz $t0, L1834
L1840:
lw $t0 0($fp)
lw $t2 -12($t0)
lw $t1 -4($fp)
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t0, $t2, $t0
lw $t0 ($t0)
lw $t1 -8($fp)
beq $t0, $t1, L1837
L1838:
lw $t0 , L1836
move $t0, $t0
L1839:
move $a0, $t0
jal tig_print
lw $t1 -8($fp)
lw $t0 0($fp)
lw $t0 -4($t0)
addi $t0, $t0, -1
sub $t0, $t1, $t0
bgez $t0, L1834
L1841:
lw $t0 -8($fp)
addi $t0, $t0, 1
sw $t0 -8($fp)
j L1840
L1837:
lw $t0 , L1835
move $t0, $t0
j L1839
L1834:
lw $t0 , L1842
move $a0, $t0
jal tig_print
lw $t1 -4($fp)
lw $t0 0($fp)
lw $t0 -4($t0)
addi $t0, $t0, -1
sub $t0, $t1, $t0
bgez $t0, L1833
L1844:
lw $t0 -4($fp)
addi $t0, $t0, 1
sw $t0 -4($fp)
j L1843
L1833:
lw $t0 , L1845
move $a0, $t0
jal tig_print
move $v0, $v0
j L1869
L1869:
lw $ra 0($sp)
lw $fp 4($sp)
addi $sp $sp 20
jr $ra

L1817:
addi $sp $sp -16
sw $ra 0($sp)
sw $fp 4($sp)
addi $fp $sp 8
L1872:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t1 4($fp)
addi $t0, $0, 0
sub $t0, $t1, $t0
bltz $t0, L1830
L1831:
lw $t1 4($fp)
addi $t0, $0, 0
sub $t0, $t1, $t0
bgtz $t0, L1827
L1828:
lw $t0 , L1826
move $a0, $t0
jal tig_print
move $t0, $v0
L1829:
move $t0, $t0
L1832:
move $v0, $t0
j L1871
L1830:
lw $t0 , L1825
move $a0, $t0
jal tig_print
move $a0, $fp
addi $t1, $0, 0
lw $t0 4($fp)
sub $t0 $t1 $t0
move $a1, $t0
jal L1820
move $t0, $v0
j L1832
L1827:
move $a0, $fp
lw $t0 4($fp)
move $a1, $t0
jal L1820
move $t0, $v0
j L1829
L1871:
lw $ra 0($sp)
lw $fp 4($sp)
addi $sp $sp 16
jr $ra

L1820:
addi $sp $sp -20
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
addi $fp $sp 12
L1874:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t0 4($fp)
addi $s0, $0, 0
sub $s0, $t0, $s0
bgtz $s0, L1822
L1823:
addi $s0, $0, 0
move $s0, $s0
L1824:
move $v0, $s0
j L1873
L1822:
lw $s0 0($fp)
move $a0, $s0
lw $t0 4($fp)
addi $s0, $0, 10
div $t0 $s0
mflo $s0
move $a1, $s0
jal L1820
lw $s0 4($fp)
lw $t1 4($fp)
addi $t0, $0, 10
div $t1 $t0
mflo $t1
addi $t0, $0, 10
mult $t1 $t0
mflo $t0
sub $s0 $s0 $t0
move $s0, $s0
lw $t0 , L1821
move $a0, $t0
jal tig_ord
move $t0, $v0
add $s0, $s0, $t0
move $a0, $s0
jal tig_chr
move $s0, $v0
move $a0, $s0
jal tig_print
move $s0, $v0
j L1824
L1873:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
addi $sp $sp 20
jr $ra

	#.file	1 "runtime.c"
	.option pic2
	.text
	.align 4
	.globl	tig_initArray
	.ent	tig_initArray
tig_initArray:
.LFB1:
	.frame	$fp,64,$ra		# vars= 16, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,64
.LCFI0:
	sd	$ra,48($sp)
.LCFI1:
	sd	$fp,40($sp)
.LCFI2:
.LCFI3:
	move	$fp,$sp
.LCFI4:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	sw	$a1,20($fp)
	lw	$v1,16($fp)
	addu	$v0,$v1,1
	move	$v1,$v0
	sll	$v0,$v1,2
	move	$a0,$v0
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,28($fp)
	lw	$v0,28($fp)
	lw	$v1,16($fp)
	sw	$v1,0($v0)
	li	$v0,1			# 0x1
	sw	$v0,24($fp)
.L3:
	lw	$v1,16($fp)
	addu	$v0,$v1,1
	lw	$v1,24($fp)
	slt	$v0,$v1,$v0
	bne	$v0,$zero,.L6
	b	.L4
.L6:
	lw	$v0,24($fp)
	move	$v1,$v0
	sll	$v0,$v1,2
	lw	$v1,28($fp)
	addu	$v0,$v0,$v1
	lw	$v1,20($fp)
	sw	$v1,0($v0)
.L5:
	lw	$v0,24($fp)
	addu	$v1,$v0,1
	sw	$v1,24($fp)
	b	.L3
.L4:
	lw	$v1,28($fp)
	move	$v0,$v1
	b	.L2
.L2:
	move	$sp,$fp
	ld	$ra,48($sp)
	ld	$fp,40($sp)
	addu	$sp,$sp,64
	j	$ra
.LFE1:
	.end	tig_initArray
	.align 4
	.globl	tig_allocRecord
	.ent	tig_allocRecord
tig_allocRecord:
.LFB2:
	.frame	$fp,64,$ra		# vars= 16, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,64
.LCFI5:
	sd	$ra,48($sp)
.LCFI6:
	sd	$fp,40($sp)
.LCFI7:
.LCFI8:
	move	$fp,$sp
.LCFI9:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	lw	$a0,16($fp)
	la	$t9,malloc
	jal	$ra,$t9
	move	$v1,$v0
	move	$v0,$v1
	sw	$v0,28($fp)
	sw	$v0,24($fp)
	sw	$zero,20($fp)
.L8:
	lw	$v0,20($fp)
	lw	$v1,16($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,.L11
	b	.L9
.L11:
	addu	$v0,$fp,24
	lw	$v1,0($v0)
	sw	$zero,0($v1)
	addu	$v1,$v1,4
	sw	$v1,0($v0)
.L10:
	lw	$v0,20($fp)
	addu	$v1,$v0,4
	sw	$v1,20($fp)
	b	.L8
.L9:
	lw	$v1,28($fp)
	move	$v0,$v1
	b	.L7
.L7:
	move	$sp,$fp
	ld	$ra,48($sp)
	ld	$fp,40($sp)
	addu	$sp,$sp,64
	j	$ra
.LFE2:
	.end	tig_allocRecord
	.align 4
	.globl	tig_stringEqual
	.ent	tig_stringEqual
tig_stringEqual:
.LFB3:
	.frame	$fp,48,$ra		# vars= 16, regs= 2/0, args= 0, extra= 16
	.mask	0x50000000,-8
	.fmask	0x00000000,0
	subu	$sp,$sp,48
.LCFI10:
	sd	$fp,40($sp)
.LCFI11:
.LCFI12:
	move	$fp,$sp
.LCFI13:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	sw	$a1,20($fp)
	lw	$v0,16($fp)
	lw	$v1,20($fp)
	bne	$v0,$v1,.L13
	li	$v0,1			# 0x1
	b	.L12
.L13:
	lw	$v0,16($fp)
	lw	$v1,20($fp)
	lw	$v0,0($v0)
	lw	$v1,0($v1)
	beq	$v0,$v1,.L14
	move	$v0,$zero
	b	.L12
.L14:
	.set	noreorder
	nop
	.set	reorder
	sw	$zero,24($fp)
.L15:
	lw	$v0,16($fp)
	lw	$v1,24($fp)
	lw	$v0,0($v0)
	slt	$v1,$v1,$v0
	bne	$v1,$zero,.L18
	b	.L16
.L18:
	lw	$v0,16($fp)
	addu	$v1,$v0,4
	lw	$a0,24($fp)
	addu	$v0,$v1,$a0
	lw	$v1,20($fp)
	addu	$a0,$v1,4
	lw	$v1,24($fp)
	addu	$a0,$a0,$v1
	lbu	$v0,0($v0)
	lbu	$v1,0($a0)
	beq	$v0,$v1,.L17
	move	$v0,$zero
	b	.L12
.L19:
.L17:
	lw	$v0,24($fp)
	addu	$v1,$v0,1
	sw	$v1,24($fp)
	b	.L15
.L16:
	li	$v0,1			# 0x1
	b	.L12
.L12:
	move	$sp,$fp
	ld	$fp,40($sp)
	addu	$sp,$sp,48
	j	$ra
.LFE3:
	.end	tig_stringEqual
	.align 4
	.globl	tig_print
	.ent	tig_print
tig_print:
.LFB4:
	.frame	$fp,64,$ra		# vars= 16, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,64
.LCFI14:
	sd	$ra,48($sp)
.LCFI15:
	sd	$fp,40($sp)
.LCFI16:
.LCFI17:
	move	$fp,$sp
.LCFI18:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	lw	$v0,16($fp)
	addu	$v1,$v0,4
	sw	$v1,24($fp)
	sw	$zero,20($fp)
.L21:
	lw	$v0,16($fp)
	lw	$v1,20($fp)
	lw	$v0,0($v0)
	slt	$v1,$v1,$v0
	bne	$v1,$zero,.L24
	b	.L22
.L24:
	lw	$v0,24($fp)
	lbu	$v1,0($v0)
	move	$a0,$v1
	la	$t9,putchar
	jal	$ra,$t9
.L23:
	lw	$v0,20($fp)
	addu	$v1,$v0,1
	sw	$v1,20($fp)
	lw	$v0,24($fp)
	addu	$v1,$v0,1
	sw	$v1,24($fp)
	b	.L21
.L22:
.L20:
	move	$sp,$fp
	ld	$ra,48($sp)
	ld	$fp,40($sp)
	addu	$sp,$sp,64
	j	$ra
.LFE4:
	.end	tig_print
	.globl	consts
	.data
	.align 4
consts:
	.word	0

	.byte	0x0
	.space	3
	.space	2040
	.globl	empty
	.align 4
empty:
	.word	0

	.byte	0x0
	.space	3
	.text
	.align 4
	.globl	main
	.ent	main
main:
.LFB5:
	.frame	$fp,64,$ra		# vars= 16, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,64
.LCFI19:
	sd	$ra,48($sp)
.LCFI20:
	sd	$fp,40($sp)
.LCFI21:
.LCFI22:
	move	$fp,$sp
.LCFI23:
	.set	noat
	.set	at
	.set	noreorder
	nop
	.set	reorder
	sw	$zero,16($fp)
.L26:
	lw	$v0,16($fp)
	slt	$v1,$v0,256
	bne	$v1,$zero,.L29
	b	.L27
.L29:
	lw	$v0,16($fp)
	move	$v1,$v0
	sll	$v0,$v1,3
	la	$v1,consts
	addu	$v0,$v1,$v0
	li	$v1,1			# 0x1
	sw	$v1,0($v0)
	lw	$v0,16($fp)
	move	$v1,$v0
	sll	$v0,$v1,3
	la	$v1,consts
	addu	$v0,$v0,$v1
	lbu	$v1,16($fp)
	sb	$v1,4($v0)
.L28:
	lw	$v0,16($fp)
	addu	$v1,$v0,1
	sw	$v1,16($fp)
	b	.L26
.L27:
	move	$a0,$zero
	la	$t9,tig_main
	jal	$ra,$t9
	move	$v1,$v0
	move	$v0,$v1
	b	.L25
.L25:
	move	$sp,$fp
	ld	$ra,48($sp)
	ld	$fp,40($sp)
	addu	$sp,$sp,64
	j	$ra
.LFE5:
	.end	main
	.align 4
	.globl	tig_ord
	.ent	tig_ord
tig_ord:
.LFB6:
	.frame	$fp,48,$ra		# vars= 16, regs= 2/0, args= 0, extra= 16
	.mask	0x50000000,-8
	.fmask	0x00000000,0
	subu	$sp,$sp,48
.LCFI24:
	sd	$fp,40($sp)
.LCFI25:
.LCFI26:
	move	$fp,$sp
.LCFI27:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	lw	$v0,16($fp)
	lw	$v1,0($v0)
	bne	$v1,$zero,.L31
	li	$v0,-1			# 0xffffffff
	b	.L30
	b	.L32
.L31:
	lw	$v0,16($fp)
	lbu	$v1,4($v0)
	move	$v0,$v1
	b	.L30
.L32:
.L30:
	move	$sp,$fp
	ld	$fp,40($sp)
	addu	$sp,$sp,48
	j	$ra
.LFE6:
	.end	tig_ord
	.align 4
	.globl	tig_chr
	.ent	tig_chr
tig_chr:
.LFB7:
	.frame	$fp,64,$ra		# vars= 16, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,64
.LCFI28:
	sd	$ra,48($sp)
.LCFI29:
	sd	$fp,40($sp)
.LCFI30:
.LCFI31:
	move	$fp,$sp
.LCFI32:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	lw	$v0,16($fp)
	bltz	$v0,.L35
	lw	$v0,16($fp)
	slt	$v1,$v0,256
	beq	$v1,$zero,.L35
	b	.L34
.L35:
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
.L34:
	lw	$v0,16($fp)
	move	$v1,$v0
	sll	$v0,$v1,3
	la	$a0,consts
	addu	$v1,$v0,$a0
	move	$v0,$v1
	b	.L33
.L33:
	move	$sp,$fp
	ld	$ra,48($sp)
	ld	$fp,40($sp)
	addu	$sp,$sp,64
	j	$ra
.LFE7:
	.end	tig_chr
	.align 4
	.globl	tig_size
	.ent	tig_size
tig_size:
.LFB8:
	.frame	$fp,48,$ra		# vars= 16, regs= 2/0, args= 0, extra= 16
	.mask	0x50000000,-8
	.fmask	0x00000000,0
	subu	$sp,$sp,48
.LCFI33:
	sd	$fp,40($sp)
.LCFI34:
.LCFI35:
	move	$fp,$sp
.LCFI36:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	lw	$v0,16($fp)
	lw	$v1,0($v0)
	move	$v0,$v1
	b	.L36
.L36:
	move	$sp,$fp
	ld	$fp,40($sp)
	addu	$sp,$sp,48
	j	$ra
.LFE8:
	.end	tig_size
.data
	.align 4
.LC0:

	.byte	0x73,0x75,0x62,0x73,0x74,0x72,0x69,0x6e
	.byte	0x67,0x28,0x5b,0x25,0x64,0x5d,0x2c,0x25
	.byte	0x64,0x2c,0x25,0x64,0x29,0x20,0x6f,0x75
	.byte	0x74,0x20,0x6f,0x66,0x20,0x72,0x61,0x6e
	.byte	0x67,0x65,0xa,0x0
	.text
	.align 4
	.globl	tig_substring
	.ent	tig_substring
tig_substring:
.LFB9:
	.frame	$fp,80,$ra		# vars= 32, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,80
.LCFI37:
	sd	$ra,64($sp)
.LCFI38:
	sd	$fp,56($sp)
.LCFI39:
.LCFI40:
	move	$fp,$sp
.LCFI41:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	sw	$a1,20($fp)
	sw	$a2,24($fp)
	lw	$v0,20($fp)
	bltz	$v0,.L39
	lw	$v0,20($fp)
	lw	$v1,24($fp)
	addu	$v0,$v0,$v1
	lw	$v1,16($fp)
	lw	$a0,0($v1)
	slt	$v0,$a0,$v0
	bne	$v0,$zero,.L39
	b	.L38
.L39:
	lw	$v0,16($fp)
	la	$a0,.LC0
	lw	$a1,0($v0)
	lw	$a2,20($fp)
	lw	$a3,24($fp)
	la	$t9,printf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
.L38:
	lw	$v0,24($fp)
	li	$v1,1			# 0x1
	bne	$v0,$v1,.L40
	lw	$v0,16($fp)
	addu	$v1,$v0,4
	lw	$v0,20($fp)
	addu	$v1,$v1,$v0
	lbu	$v0,0($v1)
	move	$v1,$v0
	sll	$v0,$v1,3
	la	$a0,consts
	addu	$v1,$v0,$a0
	move	$v0,$v1
	b	.L37
.L40:
	lw	$v1,24($fp)
	addu	$v0,$v1,4
	move	$a0,$v0
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,28($fp)
	lw	$v0,28($fp)
	lw	$v1,24($fp)
	sw	$v1,0($v0)
	sw	$zero,32($fp)
.L41:
	lw	$v0,32($fp)
	lw	$v1,24($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,.L44
	b	.L42
.L44:
	lw	$v0,28($fp)
	addu	$v1,$v0,4
	lw	$a0,32($fp)
	addu	$v0,$v1,$a0
	lw	$v1,16($fp)
	lw	$a0,20($fp)
	lw	$a1,32($fp)
	addu	$a0,$a0,$a1
	addu	$v1,$v1,4
	addu	$a0,$v1,$a0
	lbu	$v1,0($a0)
	sb	$v1,0($v0)
.L43:
	lw	$v0,32($fp)
	addu	$v1,$v0,1
	sw	$v1,32($fp)
	b	.L41
.L42:
	lw	$v1,28($fp)
	move	$v0,$v1
	b	.L37
.L37:
	move	$sp,$fp
	ld	$ra,64($sp)
	ld	$fp,56($sp)
	addu	$sp,$sp,80
	j	$ra
.LFE9:
	.end	tig_substring
	.align 4
	.globl	tig_concat
	.ent	tig_concat
tig_concat:
.LFB10:
	.frame	$fp,80,$ra		# vars= 32, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,80
.LCFI42:
	sd	$ra,64($sp)
.LCFI43:
	sd	$fp,56($sp)
.LCFI44:
.LCFI45:
	move	$fp,$sp
.LCFI46:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	sw	$a1,20($fp)
	lw	$v0,16($fp)
	lw	$v1,0($v0)
	bne	$v1,$zero,.L46
	lw	$v1,20($fp)
	move	$v0,$v1
	b	.L45
	b	.L47
.L46:
	lw	$v0,20($fp)
	lw	$v1,0($v0)
	bne	$v1,$zero,.L48
	lw	$v1,16($fp)
	move	$v0,$v1
	b	.L45
	b	.L47
.L48:
	lw	$v0,16($fp)
	lw	$v1,20($fp)
	lw	$v0,0($v0)
	lw	$v1,0($v1)
	addu	$v0,$v0,$v1
	sw	$v0,28($fp)
	lw	$v1,28($fp)
	addu	$v0,$v1,4
	move	$a0,$v0
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v0,32($fp)
	lw	$v1,28($fp)
	sw	$v1,0($v0)
	sw	$zero,24($fp)
.L50:
	lw	$v0,16($fp)
	lw	$v1,24($fp)
	lw	$v0,0($v0)
	slt	$v1,$v1,$v0
	bne	$v1,$zero,.L53
	b	.L51
.L53:
	lw	$v0,32($fp)
	addu	$v1,$v0,4
	lw	$a0,24($fp)
	addu	$v0,$v1,$a0
	lw	$v1,16($fp)
	addu	$a0,$v1,4
	lw	$v1,24($fp)
	addu	$a0,$a0,$v1
	lbu	$v1,0($a0)
	sb	$v1,0($v0)
.L52:
	lw	$v0,24($fp)
	addu	$v1,$v0,1
	sw	$v1,24($fp)
	b	.L50
.L51:
	.set	noreorder
	nop
	.set	reorder
	sw	$zero,24($fp)
.L54:
	lw	$v0,20($fp)
	lw	$v1,24($fp)
	lw	$v0,0($v0)
	slt	$v1,$v1,$v0
	bne	$v1,$zero,.L57
	b	.L55
.L57:
	lw	$v0,32($fp)
	lw	$v1,16($fp)
	lw	$a0,24($fp)
	lw	$a1,0($v1)
	addu	$v1,$a0,$a1
	addu	$a0,$v0,4
	addu	$v0,$a0,$v1
	lw	$v1,20($fp)
	addu	$a0,$v1,4
	lw	$v1,24($fp)
	addu	$a0,$a0,$v1
	lbu	$v1,0($a0)
	sb	$v1,0($v0)
.L56:
	lw	$v0,24($fp)
	addu	$v1,$v0,1
	sw	$v1,24($fp)
	b	.L54
.L55:
	lw	$v1,32($fp)
	move	$v0,$v1
	b	.L45
.L49:
.L47:
.L45:
	move	$sp,$fp
	ld	$ra,64($sp)
	ld	$fp,56($sp)
	addu	$sp,$sp,80
	j	$ra
.LFE10:
	.end	tig_concat
	.align 4
	.globl	tig_not
	.ent	tig_not
tig_not:
.LFB11:
	.frame	$fp,48,$ra		# vars= 16, regs= 2/0, args= 0, extra= 16
	.mask	0x50000000,-8
	.fmask	0x00000000,0
	subu	$sp,$sp,48
.LCFI47:
	sd	$fp,40($sp)
.LCFI48:
.LCFI49:
	move	$fp,$sp
.LCFI50:
	.set	noat
	.set	at
	sw	$a0,16($fp)
	lw	$v0,16($fp)
	xori	$a0,$v0,0x0
	sltu	$v1,$a0,1
	move	$v0,$v1
	b	.L58
.L58:
	move	$sp,$fp
	ld	$fp,40($sp)
	addu	$sp,$sp,48
	j	$ra
.LFE11:
	.end	tig_not
	.align 4
	.globl	tig_getchar
	.ent	tig_getchar
tig_getchar:
.LFB12:
	.frame	$fp,48,$ra		# vars= 0, regs= 3/0, args= 0, extra= 16
	.mask	0xd0000000,-16
	.fmask	0x00000000,0
	subu	$sp,$sp,48
.LCFI51:
	sd	$ra,32($sp)
.LCFI52:
	sd	$fp,24($sp)
.LCFI53:
.LCFI54:
	move	$fp,$sp
.LCFI55:
	.set	noat
	.set	at
	la	$t9,getchar
	jal	$ra,$t9
	move	$a0,$v0
	la	$t9,tig_chr
	jal	$ra,$t9
	move	$v1,$v0
	move	$v0,$v1
	b	.L59
.L59:
	move	$sp,$fp
	ld	$ra,32($sp)
	ld	$fp,24($sp)
	addu	$sp,$sp,48
	j	$ra
.LFE12:
	.end	tig_getchar
tig_flush:
  j $ra
  .end tig_flush
tig_exit:
  j exit
  .end tig_exit


# system calls for Tiger, when running on SPIM
#
# $Id: sysspim.s,v 1.1 2002/08/25 05:06:41 shivers Exp $

	.globl malloc
	.ent malloc
	.text
malloc:
	# round up the requested amount to a multiple of 4
	add $a0, $a0, 3
	srl $a0, $a0, 2
	sll $a0, $a0, 2

	# allocate the memory with sbrk()
	li $v0, 9
	syscall
	
	j $ra

	.end malloc

	

	.data
	.align 4
getchar_buf:	.byte 0, 0

	.text
getchar:
	# read the character
	la $a0, getchar_buf
	li $a1, 2
	li $v0, 8
	syscall

	# return it
	lb $v0, ($a0)
	j $ra
	

	.data
	.align 4
putchar_buf:	.byte 0, 0

	.text
putchar:
	# save the character so that it is NUL-terminated 
	la $t0, putchar_buf
	sb $a0, ($t0)

	# print it out
	la $a0, putchar_buf
	li $v0, 4
	syscall

	j $ra


	.text	
# just prints the format string, not the arguments
printf:
	li $v0, 4
	syscall
	j $ra


	.text
exit:
	li $v0, 10
	syscall
	

