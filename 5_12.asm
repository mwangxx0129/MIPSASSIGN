N	= 	10
	.data
X	.word	1,2,3,4,5,6,7,8,9,10

	.globl	main
	.code
main:	
	la	$a0,X
	li	$a1,N
	jal	MaxMin

	syscall	$exit

MaxMin:
init:	lw	$v0,($a0)
	lw	$v1,($a0)
	mov	$t0,$0		# clear index
	b	testWhile

whileLoop:
	sll	$t1,$t0,0x2	mult 4
	add	$t1,$t1,$a0
	lw	$t1,($t1)
	#----update min-----
	blt	$v0,$t1,1f
	mov	$v0,$t1

1:	
	blt	$t1,$v1,2f
	mov	$v1,$t1
2:
	addi	$t0,$t0,1
testWhile:	
	blt	$t0,$a1,whileLoop
	jr	$ra