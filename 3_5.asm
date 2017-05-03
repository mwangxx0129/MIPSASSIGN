
	.data
array:	.space	4*21
prompt:	.asciiz	"\n Begin Fib..."

	.globl	main
	.code
main:
	la	$a0,prompt
	syscall	$print_string

	li	$a0,20
	la	$a1,array
	jal	FIB
	
	syscall	$exit
#-------------------------------------------------
# Assume N >= 2
FIB:
init:
	li	$t0,0x2		# index
	mov	$t1,$0
	sw	$0,($a1)		# 1st element

	addi	$t2,$0,0x1
	sw	$t2,4($a1)	# 2st element

	b	testWhile

whileLoop:
	sll	$t4,$t0,2
	add	$t4,$t4,$a1
	add	$t3,$t1,$t2
	sw	$t3,($t4)
	mov	$t1,$t2
	mov	$t2,$t3

	addi	$t0,$t0,0x1
testWhile:
	ble	$t0,$a0,whileLoop
	
	
