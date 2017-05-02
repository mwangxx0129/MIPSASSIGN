SIZE	=	11
	.data
buffer:	.space	SIZE

	.globl	main
	.code
main:	
	la	$a0,buffer	# load buffer
	li	$s0,-66
	bge	$s0,$0,1f
	mov	$a1,$s0
	not	$a1,$a1
	addi	$a1,$a1,1

1:	sb	$0,10($a0)	# set '0 as end of string

	addi	$t0,$0,9	# init index, count down
doLoop:
	div	$a1,$a1,10	# cur integer
	mfhi	$t1		# reminder
	
	add	$t2,$a0,$t0	# buffer + index
	addi	$t1,$t1,48
	sb	$t1,($t2)	# *(buffer + index) = t1

	addi	$t0,$t0,-1	# count down
	bnez	$a1,doLoop	# condition
		
	srl	$t7,$s0,31	# deal with negative
	beqz	$t7,testWhile
	li	$t7,0x2d
	add	$t2,$a0,$t0	# buffer + index
	sb	$t7,($t2)
	addi	$t0,$t0,-1	# count down
	b	testWhile

whileLoop:
	li	$t1,0x20
	add	$t2,$a0,$t0	# buffer + index
	sb	$t1,($t2)	# *(buffer + index) = t1
	addi	$t0,$t0,-1	# count down
testWhile:
	bge	$t0,$0,whileLoop

end:	la	$a0,buffer
	syscall	$print_string
	syscall	$exit