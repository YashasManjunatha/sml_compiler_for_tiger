.data
L1268:
 .word L1268_data
L1268_data:
 .word 1
 .ascii "0"
L1259:
 .word L1259_data
L1259_data:
 .word 1
 .ascii "\n"
L1258:
 .word L1258_data
L1258_data:
 .word 1
 .ascii " "
L1251:
 .word L1251_data
L1251_data:
 .word 1
 .ascii "9"
L1250:
 .word L1250_data
L1250_data:
 .word 1
 .ascii "0"
L1241:
 .word L1241_data
L1241_data:
 .word 1
 .ascii "0"
L1240:
 .word L1240_data
L1240_data:
 .word 1
 .ascii "-"
L1236:
 .word L1236_data
L1236_data:
 .word 1
 .ascii "0"

.text
tig_main:

L1231:
addi $sp $sp -20
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
addi $fp $sp 16
L1272:
sw $a0 0($fp)
addi $s0, $fp, -4
move $s0, $s0
jal tig_getchar
move $t0, $v0
sw $t0 ($s0)
move $s0, $fp
move $a0, $fp
jal L1234
move $t0, $v0
move $a0, $s0
move $a1, $t0
jal L1232
move $v0, $v0
j L1271
L1271:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
addi $sp $sp 20
jr $ra

L1234:
addi $sp $sp -24
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
addi $fp $sp 20
L1274:
sw $a0 0($fp)
addi $s0, $fp, -4
move $s0, $s0
addi $t0, $0, 4
move $a0, $t0
jal tig_allocRecord
move $t0, $v0
addi $t1, $0, 2
sw $t1 0($t0)
sw $t0 ($s0)
addi $s0, $fp, -8
move $s0, $s0
lw $t0 0($fp)
move $a0, $t0
lw $t0 -4($fp)
move $a1, $t0
jal L1233
move $t0, $v0
sw $t0 ($s0)
lw $s0 -8($fp)
move $v0, $s0
j L1273
L1273:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
addi $sp $sp 24
jr $ra

L1233:
addi $sp $sp -28
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
addi $fp $sp 20
L1276:
sw $a0 0($fp)
sw $a1 4($fp)
addi $s0, $0, 0
sw $s0 -4($fp)
move $a0, $fp
jal L1249
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
jal L1248
move $s1, $v0
sw $s1 ($s0)
L1270:
move $a0, $fp
lw $s0 0($fp)
lw $s0 -4($s0)
move $a1, $s0
jal L1248
move $s1, $v0
addi $s0, $0, 0
bne $s0, $s1, L1269
L1267:
lw $s0 -4($fp)
move $v0, $s0
j L1275
L1269:
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
lw $t0 , L1268
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
j L1270
L1275:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
addi $sp $sp 28
jr $ra

L1249:
addi $sp $sp -24
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
sw $s2 16($sp)
addi $fp $sp 20
L1278:
sw $a0 0($fp)
L1266:
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
lw $s0 , L1258
move $a1, $s0
jal tig_stringEqual
move $s1, $v0
addi $s0, $0, 1
beq $s1, $s0, L1262
L1263:
addi $s0, $0, 1
move $s2, $s0
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
lw $s0 , L1259
move $a1, $s0
jal tig_stringEqual
move $s1, $v0
addi $s0, $0, 1
beq $s1, $s0, L1260
L1261:
addi $s0, $0, 0
move $s2, $s0
L1260:
move $s1, $s2
L1264:
addi $s0, $0, 0
bne $s0, $s1, L1265
L1257:
addi $s0, $0, 0
move $v0, $s0
j L1277
L1265:
lw $s0 0($fp)
lw $s0 0($s0)
addi $s0, $s0, -4
move $s0, $s0
jal tig_getchar
move $s1, $v0
sw $s1 ($s0)
j L1266
L1262:
addi $s0, $0, 1
move $s1, $s0
j L1264
L1277:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
lw $s2 16($sp)
addi $sp $sp 24
jr $ra

L1248:
addi $sp $sp -28
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
sw $s1 12($sp)
sw $s2 16($sp)
addi $fp $sp 20
L1280:
sw $a0 0($fp)
sw $a1 4($fp)
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
jal tig_ord
move $s0, $v0
move $s0, $s0
lw $s1 , L1250
move $a0, $s1
jal tig_ord
move $s1, $v0
sub $s0, $s0, $s1
bgez $s0, L1254
L1255:
addi $s0, $0, 0
move $s0, $s0
L1256:
move $v0, $s0
j L1279
L1254:
addi $s0, $0, 1
move $s2, $s0
lw $s0 0($fp)
lw $s0 0($s0)
lw $s0 -4($s0)
move $a0, $s0
jal tig_ord
move $s0, $v0
move $s0, $s0
lw $s1 , L1251
move $a0, $s1
jal tig_ord
move $s1, $v0
sub $s0, $s0, $s1
blez $s0, L1252
L1253:
addi $s0, $0, 0
move $s2, $s0
L1252:
move $s0, $s2
j L1256
L1279:
lw $ra 0($sp)
lw $fp 4($sp)
lw $s0 8($sp)
lw $s1 12($sp)
lw $s2 16($sp)
addi $sp $sp 28
jr $ra

L1232:
addi $sp $sp -16
sw $ra 0($sp)
sw $fp 4($sp)
addi $fp $sp 8
L1282:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t1 4($fp)
addi $t0, $0, 0
sub $t0, $t1, $t0
bltz $t0, L1245
L1246:
lw $t1 4($fp)
addi $t0, $0, 0
sub $t0, $t1, $t0
bgtz $t0, L1242
L1243:
lw $t0 , L1241
move $a0, $t0
jal tig_print
move $t0, $v0
L1244:
move $t0, $t0
L1247:
move $v0, $t0
j L1281
L1245:
lw $t0 , L1240
move $a0, $t0
jal tig_print
move $a0, $fp
addi $t1, $0, 0
lw $t0 4($fp)
sub $t0 $t1 $t0
move $a1, $t0
jal L1235
move $t0, $v0
j L1247
L1242:
move $a0, $fp
lw $t0 4($fp)
move $a1, $t0
jal L1235
move $t0, $v0
j L1244
L1281:
lw $ra 0($sp)
lw $fp 4($sp)
addi $sp $sp 16
jr $ra

L1235:
addi $sp $sp -20
sw $ra 0($sp)
sw $fp 4($sp)
sw $s0 8($sp)
addi $fp $sp 12
L1284:
sw $a0 0($fp)
sw $a1 4($fp)
lw $t0 4($fp)
addi $s0, $0, 0
sub $s0, $t0, $s0
bgtz $s0, L1237
L1238:
addi $s0, $0, 0
move $s0, $s0
L1239:
move $v0, $s0
j L1283
L1237:
lw $s0 0($fp)
move $a0, $s0
lw $t0 4($fp)
addi $s0, $0, 10
div $t0 $s0
mflo $s0
move $a1, $s0
jal L1235
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
lw $t0 , L1236
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
j L1239
L1283:
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
	

