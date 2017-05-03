Y	=	56
	.data
Z:	.word	1,2,3,4,5,6,7,8,9,0
	.word	1,2,3,4,5,6,7,8,9,0
	.word	1,2,3,4,5,6,7,8,9,0
	.word	1,2,3,4,5,6,7,8,9,0
	.word	1,2,3,4,5,6,7,8,9,0

	.word	1,2,3,4,5,6

prompt:	.asciiz	"\n Begin 5.11.asm"

	.globl	main
	.code
main:	
	la	$a0,prompt
	syscall	$print_string
	
	la	$s0,Z
	mov	$t0,$0		# index

	li	$t3,Y
	b	testWhile
	
whileLoop:
	sll	$t1,$t0,2		# mult 4
	add	$t1,$t1,$s0
	srl	$t2,$t0,2
	addi	$t2,$t2,210
	sll	$t2,$t2,4

	sub	$t2,$t3,$t2
	sw	$t2,($t1)
	
	addi	$t0,$t0,0x1
testWhile:
	blt	$t0,50,whileLoop

	lw	$a0,8($s0)
	syscall	$print_int

	syscall	$exit