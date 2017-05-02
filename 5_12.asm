	.data
SIZE = 10
array:	.word	1,2,3,4,5,6,7,8,9,10
prompt:	.asciiz	"\n the output is: "

	.globl	main
	.code
main:	
	la	$a0,array
	addi	$a1,$0,10
	jal	MaxMin
	
	la	$a0,prompt
	syscall $print_string

	mov	$a0,$v0
	syscall $print_int

	mov	$a0,$v1
	syscall	$print_int

	syscall	$exit

# MaxMin(int *X: a0, int N: a1, int Min; v0, int Max: v1)
#v0 = *(a0)
#v1 = *(a0)
#for (int t0 = 1; t0 < a1; t0++)
#{
#	t1 = t1 + t0;
#	t1 = *(t1);
#	if (t1 < v0) 
#		v0 = t1;
#	if (v1 < t1)
#		v1 = t1;
#}
MaxMin:
	lw	$v0,0($a0)
	lw 	$v1,0($a0)
	b	testFor

forLoop:
	sll	$t1,$t0,2
	add	$t1,$t1,$a0
	lw	$t1,0($t1)
	slt	$t2,$t1,$v0
	beqz	$t2,secondIf
	mov	$v0,$t1
secondIf:
	slt	$t2,$v1,$t1
	beqz	$t2,incr
	mov	$v1,$t1
incr:	addi	$t0,$t0,0x1

testFor:
	slt	$t7,$t0,$a1
	bnez	$t7,forLoop
	jr	$ra
	
