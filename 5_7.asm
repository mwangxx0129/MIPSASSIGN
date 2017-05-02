SIZE =	9	#Length of string buffer for inputting name.
	.data
prompt1:	.asciiz	"\n Enter your Hex:"

YourName	.asciiz	"\n Your Num is:"
buffer:		.space	SIZE

		.globl	main
		.code
main:	la	$a0,prompt1
	syscall	$print_string
	la	$a0,buffer
	li	$a1,SIZE
	syscall	$read_string	# get input

	mov	$a0,$v0		# the num of input
	syscall	$print_int
	
	la	$a0,buffer	# print input
	syscall	$print_string
	
	la	$a0,buffer	
	addi	$a1,$v0,0
	jal	getNumFromHexString
	
	mov	$a0,$v0
	syscall	$print_int
	syscall	$exit

# getNumFromHexString(void * buffer: a0, int size: a1) 
getNumFromHexString:
	mov	$t0,$0
	mov	$v0,$0	#clear
init:
	b	testFor
forLoop:	
	sll	$v0,$v0,0x4	# v0<< 4
	add	$t2,$t0,$a0
	lb	$t2,($t2)
	
	bgt	$t2,57,1f
	addi	$t2,$t2,-48
	b	3f
	
1:	bgt	$t2,70,2f
	addi	$t2,$t2,-55
	b	3f

2:	
	addi	$t2,$t2,-87

3:	add	$v0,$v0,$t2	# t2 + (v0 << 4)
	addi	$t0,$t0,1
testFor:
	slt	$t2,$t0,$a1
	bnez	$t2,forLoop
	jr	$ra
	
	