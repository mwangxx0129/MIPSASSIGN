	.globl	main
	.code
main:
	# code here
	li	$a0,'\f		# clear screen
	syscall	$print_char

	addi	$a0,$0,0x9	# input
	jal	countBits	# call countBits
	mov	$a0,$v0		# output
	syscall	$print_int
	syscall	$exit

############################################################
# countBits(int a0)	return v0
countBits:		
	li	$t9,32
	mov	$t1,$0		# index t1 
	mov	$v0,$0		# count v0
loop:
	andi	$t0,$a0,0x1
	beqz	$t0,test
	addi	$v0,1		# count

test:
	srl	$a0,$a0,1
	addi	$t1,1		# index
	bne	$t1,$t9,loop
	jr	$ra