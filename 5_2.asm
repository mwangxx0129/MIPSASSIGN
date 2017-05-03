	.data
SRC:	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10

	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10
	.word	1,2,3,4,5,6,7,8,9,10

DEST:	.word	0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0

	.word	0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0,0,0	
	.word	0,0,0,0,0,0,0,0,0,0

beginPrompt:	.asciiz	"\n Copy From SRC to DEST ..."
testValue:	.asciiz	"\n The value is:"
endPrompt:	.asciiz	"\n Have done Copy"

	.globl	main
	.code
main:	
	la	$a0,beginPrompt
	syscall	$print_string
#---------<body>--------------------------
	la	$a0,SRC
	la	$a1,DEST
	mov	$t0,$0		# index
	b 	testWhile

whileLoop:
	sll	$t1,$t0,2
	add	$t2,$t1,$a0	# t2 = src + index	
	add	$t3,$t1,$a1	# t3 = des + index
	lw	$t2,($t2)		# t2 = *(t2)
	sw	$t2,($t3)		# (*t3) = t2
	addi	$t0,$t0,0x1	# incr. step
testWhile:
	blt	$t0,100,whileLoop

testCopy:
	la	$a0,testValue
	syscall	$print_string

	lw	$a0,4($a1)	
	syscall	$print_int

	la	$a0,endPrompt
	syscall	$print_string