	.data
array:	.word 0,2,-1,4,-3,6,-5,8,-7,10

prompt:	.asciiz	"\n the output is: "

	.globl	main
	.code
main:				# Tells assembler main is accessible outside file
	la	$a0,prompt
	syscall $print_string

	la	$a0,array
	li	$a1,10
	jal	PENO

	mov	$a0,$v0
	syscall	$print_int
	mov	$a0,$v1
	syscall	$print_int
#------------------------------------------------------------------------
# Arguments:
#	input:	(a0, a1)
# 		a0 = address pointer into the array
#		a1 = size of the array
#	output: (v0, v1)
#		v0 = sum of positive even elements
#		v1 = sum of negative odd elements
#------------------------------------------------------------------------
# Register Usage in Function:
#	  
#------------------------------------------------------------------------
# Alg. Descr. in Pseudocode
#{
#	v0 = 0;
#	v1 = 0;
#	t0 = 0;
#	while (t0 < a1) do 
#	{
#		t1 = t0 + a0;		// get absoulte address
#		t2 = * t1;		// get array element from memory
#		
#		if (t2 > 0 && t2 % 2 == 0) 
#			v0 += t2;	// sum of positive even elements
#		else if (t2 < 0 && t2 % 2 != 0)
#			v1 += t2;	// sum of negative odd elements
#		
#		t0++; 			// increment offset(index)
#	}
#}
#------------------------------------------------------------------------
# PENO(int x[]:a0, const int N:a1) return (int spe: v0, int sno: v1)
PENO:
	mov	$v0,$0
	mov	$v1,$0
	mov	$t0,$0		# Init. v0, v1, t0 to zero
	b	whileTest

whileLoop:
	sll	$t1,$t0,2
	add 	$t1,$t1,$a0
	lw	$t2,0($t1)

	slt	$t3,$0,$t2
	andi	$t4,$t2,0x1
	slti	$t4,$t4,0x1
	and	$t3,$t3,$t4
	beqz	$t3,elseIf
	add	$v0,$v0,$t2
	b	incr
elseIf:		
	slt	$t3,$t2,$0
	andi	$t4,$t2,0x1
	slt	$t4,$0,$t4
	and	$t3,$t3,$t4
	beqz	$t3,incr
	add	$v1,$v1,$t2

incr:	addi	$t0,1

whileTest:
	slt	$t7,$t0,$a1
	bnez	$t7,whileLoop	
	jr	$ra
#------------------------------------------------------------------------