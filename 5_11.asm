#int main()
#{	
#	int t0, t1;
#	int a0[t0];
#	t1 = 56;
#	for (t0 = 0; t0 < 50; t0++)
#		a0[t0] = t1 - 16 * (t0 / 4 + 210);
#}



	.data
Z:	.space 4*50

	.code
	.globl	main
	.code
main:	
	la	$a0,Z		# pointer into the array
	mov	$t0,$0		# index
	addi	$t6,$0,56	# size
	b	testFor	

forLoop:
	sll	$t1,$t0,2	# get offset mult 4
	add	$t1,$t1,$a0	# get base + offset
	srl	$t2,$t0,2
	addi	$t2,$t2,210
	sll	$t2,$t2,4
	sub	$t2,$t6,$t2
	sw	$t2,0($t1)
	
	addi	$t0,$t0,1	# incr.
testFor:	
	slti	$t7,$t0,50
	bnez	$t7,forLoop

	lw	$a0,196($a0)	#-3496
	syscall	$print_int
	syscall	$exit

	