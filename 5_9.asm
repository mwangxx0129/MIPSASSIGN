#--------------------------------------------------------------
#a0 = read_string;		// input: string
#v0 = 0				// output: integer result
#v1 = 0				// output: error decimal
#
#t1 = *(a0)
#if ( *a0 == 1) 			// negative
#{
#	t7 = 1;
#	a0 ++;
#}
#
#t1 = *(a0 ) 			// get curt char
#while (t1 >= '0' && t1 <= '9')
#{
#	t1 = *(a0 ) 		// get curt char
#	v0  *= 10		// mult 10
#	v0  +=  t1		// plus char 
#
#	//overflow
#	if (v0 > 0x7fff ffff + t7)
#	{
#		overflow
#		exit	
#	}
#	a0 ++;			// incr. t0
#} 
#
#if (t1 != '\0' && t1 != '\n' && t1 != ' ' && t1 != '\t')
#{
#	v0 = 0
#	v1 = 1;
#	print prompt isValid input, Enter again
#}
#
#if (t7 == 1) 			// two complement 's
#{
#	! v0
#	v0 ++
#}
#
#--------------------------------------------------------------

#--------------data---------------------------
	.data
buffer:		.asciiz	"abcdefgh+-09AZa z.\t\n"
overFlowOutput:	.asciiz	"\n the number is overflow"
invalidInput:	.asciiz	"\n the input is invalid"
programExit:	.asciiz "\n Exit Program\n"
programBegin:	.asciiz "\n Begin Program\n"
#--------------main---------------------------
	.globl	main
	.code
main:

	la	$a0,programBegin
	syscall	$print_string

	jal	ReadDecimal	# call ReadDecimal

	mov	$a0,$v0		# print number
	syscall	$print_int
	mov	$a0,$v1		# isValid 1:error
	syscall	$print_int
	
	la	$a0,programExit
	syscall	$print_string
	
	bgtz	$v1,main
	syscall	$exit

#--------------main---------------------------
# ReadDecimal: return int:v0, int:v1
# t0: index 	
# t7: flag of negative	
ReadDecimal:	
	la	$a0,buffer	# init memory
	li	$a1,64		# space

	syscall	$read_string	# input: string
	
	mov	$v0,$0		# clear output: int
	mov	$v1,$0		# clear	output: int
	mov	$t7,$0		# clear negative flag

	mov	$t0,$0		# clear
	mov	$t1,$0
	mov	$t2,$0
	mov	$t3,$0
	mov	$t4,$0
	mov	$t5,$0
	mov	$t6,$0
#------------isNegative------------------
	
	lb	$t1,($a0)
	li	$t2,0x2d	
	bne	$t1,$t2,1f
	li	$t7,0x1
	addi	$a0,$a0,1
1:	
	b	testWhile

whileLoop:
	addi	$t1,$t1,0-'0
	li	$t6,0xa
	mul	$v0,$v0,$t6
	#------overflow to mfhi--------
	mfhi	$t5
	bgtz	$t5,overFlow

	addu	$v0,$v0,$t1
	b	testOverflow

5:	addi	$a0,$a0,1
	
testWhile:
	lb	$t1,($a0)

	li	$t2,'0
	bgt	$t2,$t1,testInvalid
	li	$t2,'9
	bgt	$t1,$t2,testInvalid
	b	whileLoop
	b	testInvalid

testOverflow:
	li	$t6,0x7fffffff
	addu	$t6,$t6,$t7
	bleu	$v0,$t6,5b
overFlow:
	li	$v1,0x1
	li	$v0,0x0
	la	$a0,overFlowOutput
	syscall	$print_string
	b	end

testInvalid:
	li	$t2,0x20	# space
	beq	$t1,$t2,testNegative
	li	$t2,'\n		# \n
	beq	$t1,$t2,testNegative
	li	$t2,'\0		# \0
	beq	$t1,$t2,testNegative

	li	$v1,0x1
	la	$a0,invalidInput
	syscall	$print_string
	b	end

testNegative:	
	beqz	$t7,end
	not	$v0,$v0
	addiu	$v0,$v0,1
end:
	jr	$ra	