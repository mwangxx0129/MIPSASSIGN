	.data
Chico:	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10

	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	0
prompt:	.asciiz	"\n the sum of first 100 is:"

	.globl	main
	.code
main:	
	la	$a0,Chico		# Chico
	mov	$t0,$0		# index
	mov	$v0,$0		# temp sum
	b	testWhile

whileLoop:
	sll	$t1,$t0,2		# mult 4
	add	$t1,$t1,$a0	# t1 = t1 + a0
	lw	$t1,($t1)		# t1 = (*t1)
	add	$v0,$v0,$t1	# v0 = v0 + t1
	addi	$t0,$t0,0x1	# incr. step
testWhile:
	blt	$t0,100,whileLoop

storeSum:
	sll	$t1,$t0,2		# mult 4
	add	$t1,$t1,$a0	# t1 = t1 + a0
	sw	$v0,($t1)

printSum:
	la	$a0,prompt
	syscall	$print_string
	mov	$a0,$v0
	syscall	$print_int



