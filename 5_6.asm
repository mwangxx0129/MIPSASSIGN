firstShift = 28
deltaShift = -4

	.code
	.globl	main
main:	
	li	$a0,'\n
	syscall	$print_char
	li	$a0,0x00b0000f	# input number
	li	$a1,0x0		# size
	mov	$s0,$a2		# store result
	jal	Print_Hex
	mov 	$a0,$s0
	syscall	$print_string
	syscall	$exit

# void Print_Hex(unsigned int x: a0, unsigned int size: a1)
# a2 is index
Print_Hex:
# --------------a1 = 0 omit leading 0--------------------
	bnez	$a1,testWhile
	mov	$t3,$0		# clear
	addi	$t0,$0,firstShift
11:	srlv	$t1,$a0,$t0
	andi	$t1,$t1,0xf
	#---------------------------
	slt	$t2,$0,$t3	# t3 is flag of non-zero
	bnez	$t2,13f

	slti	$t2,$t1,0x1	# is zero
	bnez	$t2,14f
	addi	$t3,$0,0x1
	#---------------------------
13:	slti	$t2,$t1,0xa	# condition t1 < 10
	bnez	$t2,12f
	addi	$t1,$t1,'A-'9-1
12:	addi	$t1,$t1,'0
	sb	$t1,($a2)
	addi	$a2,$a2,1
14:	addi	$t0,$t0,deltaShift
	bgez	$t0,11b
	li	$t1,'\0
	sb	$t1,($a2)
	jr	$ra
# --------------print space------------------------------
	
	b	testWhile
whileLoop:
	li	$t0,0x20
	sb	$t0,($a2)	
	addi	$a1,$a1,-1
	addi	$a2,$a2,1
testWhile:
	li	$t0,8
	slt	$t0,$t0,$a1
	bnez	$t0,whileLoop

# --------------print digit------------------------------
#	addi	$t0,$0,firstShift
	addi	$t0,$a1,-1 	
	sll	$t0,$t0,2

1:	srlv	$t1,$a0,$t0
	andi	$t1,$t1,0xf
	slti	$t2,$t1,0xa	# condition t1 < 10
	bnez	$t2,2f
	addi	$t1,$t1,'A-'9-1
2:	addi	$t1,$t1,'0
	sb	$t1,($a2)
	addi	$a2,$a2,1
	addi	$t0,$t0,deltaShift
	bgez	$t0,1b
	li	$t1,'\0
	sb	$t1,($a2)
	jr	$ra