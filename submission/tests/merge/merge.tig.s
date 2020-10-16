.data
LA247:
 .word LA247_data
LA247_data:
 .word 1
 .ascii " "
LA246:
 .word LA246_data
LA246_data:
 .word 1
 .ascii "\n"
LA239:
 .word LA239_data
LA239_data:
 .word 1
 .ascii "0"
LA238:
 .word LA238_data
LA238_data:
 .word 1
 .ascii "-"
LA234:
 .word LA234_data
LA234_data:
 .word 1
 .ascii "0"
LA214:
 .word LA214_data
LA214_data:
 .word 1
 .ascii "0"
LA205:
 .word LA205_data
LA205_data:
 .word 1
 .ascii "\n"
LA204:
 .word LA204_data
LA204_data:
 .word 1
 .ascii " "
LA197:
 .word LA197_data
LA197_data:
 .word 1
 .ascii "9"
LA196:
 .word LA196_data
LA196_data:
 .word 1
 .ascii "0"

.text
tig_main:

LA192:
addi $sp $sp -32
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
addi $fp $sp 28
LA252:
sw $a0 0($fp)
addi $s0, $fp, -4
move $s0, $s0
jal tig_getchar
move $s1, $v0
sw $s1 ($s0)
addi $s0, $fp, -8
move $s0, $s0
move $a0, $fp
jal LA217
move $s1, $v0
sw $s1 ($s0)
addi $s0, $fp, -12
move $s0, $s0
addi $s1, $fp, -4
move $s1, $s1
jal tig_getchar
move $t0, $v0
sw $t0 ($s1)
move $a0, $fp
jal LA217
sw $v0 ($s0)
move $s0, $fp
move $a0, $fp
lw $s1 -8($fp)
move $a1, $s1
lw $s1 -12($fp)
move $a2, $s1
jal LA218
move $s1, $v0
move $a0, $s0
move $a1, $s1
jal LA220
move $v0, $v0
j LA251
LA251:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
addi $sp $sp 32
jr $ra

LA220:
addi $sp $sp -16
sw $ra 0($sp)
sw $fp 4($sp)
addi $fp $sp 8
LA254:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t1 4($fp)
addi $t0, $0, 0
beq $t1, $t0, LA248
LA249:
lw $t0 0($fp)
move $a0, $t0
lw $t2 4($fp)
addi $t1, $0, 0
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t0, $t2, $t0
lw $t0 ($t0)
move $a1, $t0
jal LA219
lw $t0 , LA247
move $a0, $t0
jal tig_print
lw $t0 0($fp)
move $a0, $t0
lw $t2 4($fp)
addi $t1, $0, 1
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $t0, $t2, $t0
lw $t0 ($t0)
move $a1, $t0
jal LA220
move $t0, $v0
LA250:
move $v0, $t0
j LA253
LA248:
lw $t0 , LA246
move $a0, $t0
jal tig_print
move $t0, $v0
j LA250
LA253:
lw $ra 0($sp)
lw $fp 4($sp)
addi $sp $sp 16
jr $ra

LA219:
addi $sp $sp -16
sw $ra 0($sp)
sw $fp 4($sp)
addi $fp $sp 8
LA256:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t1 4($fp)
addi $t0, $0, 0
sub $t0, $t1, $t0
bltz $t0, LA243
LA244:
lw $t1 4($fp)
addi $t0, $0, 0
sub $t0, $t1, $t0
bgtz $t0, LA240
LA241:
lw $t0 , LA239
move $a0, $t0
jal tig_print
move $t0, $v0
LA242:
move $t0, $t0
LA245:
move $v0, $t0
j LA255
LA243:
lw $t0 , LA238
move $a0, $t0
jal tig_print
move $a0, $fp
addi $t1, $0, 0
lw $t0 4($fp)
sub $t0 $t1 $t0
move $a1, $t0
jal LA233
move $t0, $v0
j LA245
LA240:
move $a0, $fp
lw $t0 4($fp)
move $a1, $t0
jal LA233
move $t0, $v0
j LA242
LA255:
lw $ra 0($sp)
lw $fp 4($sp)
addi $sp $sp 16
jr $ra

LA233:
addi $sp $sp -20
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
addi $fp $sp 12
LA258:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t0 4($fp)
addi $s0, $0, 0
sub $s0, $t0, $s0
bgtz $s0, LA235
LA236:
addi $s0, $0, 0
move $s0, $s0
LA237:
move $v0, $s0
j LA257
LA235:
lw $s0 0($fp)
move $a0, $s0
lw $t0 4($fp)
addi $s0, $0, 10
div $t0 $s0
mflo $s0
move $a1, $s0
jal LA233
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
lw $t0 , LA234
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
j LA237
LA257:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
addi $sp $sp 20
jr $ra

LA218:
addi $sp $sp -32
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
sw $s2 16($sp)
addi $fp $sp 20
LA260:
sw $a0 0($fp)
sw $a1 4($fp)
sw $a2 8($fp)
lw $s1 4($fp)
addi $s0, $0, 0
beq $s1, $s0, LA230
LA231:
lw $s1 8($fp)
addi $s0, $0, 0
beq $s1, $s0, LA227
LA228:
lw $s2 4($fp)
addi $s1, $0, 0
addi $s0, $0, 4
mult $s1 $s0
mflo $s0
add $s0, $s2, $s0
lw $s0 ($s0)
lw $t0 8($fp)
addi $s2, $0, 0
addi $s1, $0, 4
mult $s2 $s1
mflo $s1
add $s1, $t0, $s1
lw $s1 ($s1)
sub $s0, $s0, $s1
bltz $s0, LA224
LA225:
addi $s0, $0, 8
move $a0, $s0
jal tig_allocRecord
move $s2, $v0
lw $t0 8($fp)
addi $s1, $0, 0
addi $s0, $0, 4
mult $s1 $s0
mflo $s0
add $s0, $t0, $s0
lw $s0 ($s0)
sw $s0 0($s2)
addi $s0, $s2, 4
move $s0, $s0
lw $s1 0($fp)
move $a0, $s1
lw $s1 4($fp)
move $a1, $s1
lw $s1 8($fp)
addi $t1, $0, 1
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $s1, $s1, $t0
lw $s1 ($s1)
move $a2, $s1
jal LA218
move $s1, $v0
sw $s1 ($s0)
move $s0, $s2
LA226:
move $s0, $s0
LA229:
move $s0, $s0
LA232:
move $v0, $s0
j LA259
LA230:
lw $s0 8($fp)
move $s0, $s0
j LA232
LA227:
lw $s0 4($fp)
move $s0, $s0
j LA229
LA224:
addi $s0, $0, 8
move $a0, $s0
jal tig_allocRecord
move $s2, $v0
lw $t0 4($fp)
addi $s1, $0, 0
addi $s0, $0, 4
mult $s1 $s0
mflo $s0
add $s0, $t0, $s0
lw $s0 ($s0)
sw $s0 0($s2)
addi $s0, $s2, 4
move $s0, $s0
lw $s1 0($fp)
move $a0, $s1
lw $s1 4($fp)
addi $t1, $0, 1
addi $t0, $0, 4
mult $t1 $t0
mflo $t0
add $s1, $s1, $t0
lw $s1 ($s1)
move $a1, $s1
lw $s1 8($fp)
move $a2, $s1
jal LA218
move $s1, $v0
sw $s1 ($s0)
move $s0, $s2
j LA226
LA259:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
lw $s2 16($sp)
addi $sp $sp 32
jr $ra

LA217:
addi $sp $sp -32
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
sw $s2 16($sp)
addi $fp $sp 28
LA262:
sw $a0 0($fp)
addi $s0, $fp, -4
move $s0, $s0
addi $s1, $0, 4
move $a0, $s1
jal tig_allocRecord
move $s2, $v0
addi $s1, $0, 0
sw $s1 0($s2)
sw $s2 ($s0)
addi $s0, $fp, -8
move $s0, $s0
lw $s1 0($fp)
move $a0, $s1
lw $s1 -4($fp)
move $a1, $s1
jal LA193
move $s1, $v0
sw $s1 ($s0)
addi $t0, $0, 0
lw $s2 -4($fp)
addi $s1, $0, 0
addi $s0, $0, 4
mult $s1 $s0
mflo $s0
add $s0, $s2, $s0
lw $s0 ($s0)
bne $t0, $s0, LA221
LA222:
addi $s0, $0, 0
move $s0, $s0
LA223:
move $v0, $s0
j LA261
LA221:
addi $s0, $0, 8
move $a0, $s0
jal tig_allocRecord
move $s2, $v0
lw $s0 -8($fp)
sw $s0 0($s2)
addi $s0, $s2, 4
move $s0, $s0
lw $s1 0($fp)
move $a0, $s1
jal LA217
move $s1, $v0
sw $s1 ($s0)
move $s0, $s2
j LA223
LA261:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
lw $s2 16($sp)
addi $sp $sp 32
jr $ra

LA193:
addi $sp $sp -28
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
addi $fp $sp 20
LA264:
sw $a0 0($fp)
sw $a1 4($fp)
addi $s0, $0, 0
sw $s0 -4($fp)
move $a0, $fp
jal LA195
lw $t0 4($fp)
addi $s1, $0, 0
addi $s0, $0, 4
mult $s1 $s0
mflo $s0
add $s0, $t0, $s0
move $s0, $s0
move $a0, $fp
lw $s1 0($fp)
lw $s1 -4($s1)
move $a1, $s1
jal LA194
move $s1, $v0
sw $s1 ($s0)
LA216:
move $a0, $fp
lw $s0 0($fp)
lw $s0 -4($s0)
move $a1, $s0
jal LA194
move $s1, $v0
addi $s0, $0, 0
bne $s0, $s1, LA215
LA213:
lw $s0 -4($fp)
move $v0, $s0
j LA263
LA215:
addi $s0, $fp, -4
move $s0, $s0
lw $t0 -4($fp)
addi $s1, $0, 10
mult $t0 $s1
mflo $s1
move $s1, $s1
lw $t0 0($fp)
lw $t0 -4($t0)
move $a0, $t0
jal tig_ord
move $t0, $v0
add $s1, $s1, $t0
move $s1, $s1
lw $t0 , LA214
move $a0, $t0
jal tig_ord
move $t0, $v0
sub $s1 $s1 $t0
sw $s1 ($s0)
lw $s0 0($fp)
addi $s0, $s0, -4
move $s0, $s0
jal tig_getchar
move $s1, $v0
sw $s1 ($s0)
j LA216
LA263:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
addi $sp $sp 28
jr $ra

LA195:
addi $sp $sp -24
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
sw $s2 16($sp)
addi $fp $sp 20
LA266:
sw $a0 0($fp)
LA212:
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
lw $s0 , LA204
move $a1, $s0
jal tig_stringEqual
move $s1, $v0
addi $s0, $0, 1
beq $s1, $s0, LA208
LA209:
addi $s0, $0, 1
move $s2, $s0
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
lw $s0 , LA205
move $a1, $s0
jal tig_stringEqual
move $s1, $v0
addi $s0, $0, 1
beq $s1, $s0, LA206
LA207:
addi $s0, $0, 0
move $s2, $s0
LA206:
move $s1, $s2
LA210:
addi $s0, $0, 0
bne $s0, $s1, LA211
LA203:
addi $s0, $0, 0
move $v0, $s0
j LA265
LA211:
lw $s0 0($fp)
lw $s0 0($s0)
addi $s0, $s0, -4
move $s0, $s0
jal tig_getchar
move $s1, $v0
sw $s1 ($s0)
j LA212
LA208:
addi $s0, $0, 1
move $s1, $s0
j LA210
LA265:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
lw $s2 16($sp)
addi $sp $sp 24
jr $ra

LA194:
addi $sp $sp -28
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
sw $s2 16($sp)
addi $fp $sp 20
LA268:
sw $a0 0($fp)
sw $a1 4($fp)
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
jal tig_ord
move $s0, $v0
move $s0, $s0
lw $s1 , LA196
move $a0, $s1
jal tig_ord
move $s1, $v0
sub $s0, $s0, $s1
bgez $s0, LA200
LA201:
addi $s0, $0, 0
move $s0, $s0
LA202:
move $v0, $s0
j LA267
LA200:
addi $s0, $0, 1
move $s2, $s0
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
jal tig_ord
move $s0, $v0
move $s0, $s0
lw $s1 , LA197
move $a0, $s1
jal tig_ord
move $s1, $v0
sub $s0, $s0, $s1
blez $s0, LA198
LA199:
addi $s0, $0, 0
move $s2, $s0
LA198:
move $s0, $s2
j LA202
LA267:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
lw $s2 16($sp)
addi $sp $sp 28
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
	

