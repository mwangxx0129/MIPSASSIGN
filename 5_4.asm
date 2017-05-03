	.data
N:	.word	9,10,32666,32777,654321
prompt:	.asciiz	"\n The sum is:"

	.globl	main
	.code
main:
	la	$s0,N
	mov	$t0,$0
	b	testWhile

whileLoop:
	sll	$t1,$t0,2		# mult 4
	add	$t1,$t1,$s0
	lw	$t1,($t1)

	mov	$a0,$t1
	jal	SUM

	la	$a0,prompt
	syscall	$print_string

	mov	$a0,$v0
	syscall	$print_int

	addi	$t0,$t0,1
testWhile:
	blt	$t0,0x5,whileLoop

	syscall	$exit

SUM:
	addi	$v0,$a0,0x1
	mul	$v0,$v0,$a0	
	srl	$v0,$v0,0x1		# div 2
	jr	$ra
