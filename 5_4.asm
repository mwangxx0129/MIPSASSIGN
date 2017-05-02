	.data
prompt:	.asciiz	"\n the output is: "
N:	.word	9,10,32666,32777,654321

	.globl	main
	.code
main:	
	la	$a1,N		# init poniter into the array
	mov	$t0,$0		# init t0 as index
	b	testWhile

whileLoop:
	la $a0,prompt
	syscall	$print_string

	sll	$a0,$t0,2
	add	$a0,$a0,$a1
	lw	$a0,0($a0)
	jal	SUM
	mov	$a0,$v0
	syscall	$print_int	
	addi	$t0,$t0,1

testWhile:
	slti	$t7,$t0,0x5
	bnez	$t7,whileLoop

	syscall	$exit

#------------------------------------------------------------------------
# Arguments:
#	input:	(a0)
# 		a0 = N
#	output: (v0, v1)
#		v0 = sum of 0-N	  
#------------------------------------------------------------------------
# Alg. Descr. in Pseudocode
#{
#	v0 = 0;
#	v0 = a0 + 1;
#	v0 = v0 * a0
#	v0 = v0 / 2;
#}
#------------------------------------------------------------------------
# SUM(const int n:a0) return (int sum: v0)
SUM:
	mov	$v0,$0
	addi	$v0,$a0,0x1
	mul	$v0,$a0,$v0
	srl	$v0,$v0,1
	jr 	$ra