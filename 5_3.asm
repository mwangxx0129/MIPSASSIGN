N 	=	9
	.data
X:	.word	-1,2,-3,4,-5,6,-7,8,-9

PEPrompt:	.asciiz	"\n The Positive Even sum is:"
NOPrompt:	.asciiz	"\n The Negative Odd  sum is:"

	.globl	main
	.code
main:	
	la	$a0,X
	li	$a1,N
	jal	PENO		# call PENO

	la	$a0,PEPrompt	
	syscall	$print_string

	mov	$a0,$v0
	syscall	$print_int
	
	la	$a0,NOPrompt
	syscall	$print_string

	mov	$a0,$v1
	syscall	$print_int
	syscall	$exit

#---------PENO--------------------------------
#if (t1 > 0 && even) 
#  v0 += t1
#if (t1 < 0 && odd)
#   v1 += t1
# PENO(int X[]: a0, int N: a1) return v0, v1

PENO:
	
init:	
	mov	$v0,$0
	mov	$v1,$0
	mov	$t0,$0		# index
	b	testWhile

whileLoop:
	sll	$t1,$t0,2		# mult 4
	add	$t1,$t1,$a0	# X + index
	lw	$t1,($t1)		# t1 = (*t1)
	
	andi	$t2,$t1,0x1	# t2 0:even 1:odd

	blt	$t1,$0,negativeDeal
	b	positiveDeal
positiveDeal:
	bnez	$t2,endDeal
	add	$v0,$v0,$t1
	b	endDeal

negativeDeal:
	beqz	$t2,endDeal
	add	$v1,$v1,$t1
	
endDeal:
	addi	$t0,$t0,0x1
	
testWhile:
	blt	$t0,$a1,whileLoop
	jr	$ra

