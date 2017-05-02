	.data
array:	.space 4*100

prompt:	.asciiz	"\n the output is: "

	.globl	main
	.code
main:				# Tells assembler main is accessible outside file
	la	$a0,prompt
	syscall $print_string
	
	syscall	$read_int
	mov	$a0,$v0
	la	$a1,array
	jal	FIB
	
	syscall	$exit

#------------------------------------------------------------------------
# Alg. Descr. in Pseudocode
#{
#	*(a1 + 0) = t1
#	*(a1 + 1) = t2
#	t0 = 2;		// index
#	while (t0 < a1) do 
#	{
#		t4 = t0 << 2;		// get offset
#		t3 = t1 + t2;		// get t3
#		*(a1 + t4) = t3		// set a1[t1] 
#		t1 = t2;		// update t1
#		t2 = t3;		// update t2
#		t0++; 			// increment offset(index)
#	}
#}
#------------------------------------------------------------------------
# Assume N > 2
# FIB(int N: a0, int array[]: a1)
FIB:
	addi	$t0,$0,2
	mov	$t1,$0
	addi	$t2,$0,1
	sw	$t1,0($a1)
	sw	$t2,4($a1)
	b	whileTest

whileLoop:
	sll	$t4,$t0,2
	add	$t3,$t1,$t2
	add	$t4,$t4,$a1
	sw	$t3,0($t4)
	mov	$t1,$t2
	mov	$t2,$t3
	
	addi	$t0,$t0,0x1
whileTest:
	slt	$t7,$t0,$a0
	bnez	$t7,whileLoop
	jr	$ra