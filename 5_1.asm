	.data
	.align
chico:	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
result:	.word	0
prompt:	.asciiz	"\n the sum of 100 is: "

	.globl	main
	.code
main:				# Tells assembler main is accessible outside file
	la	$a0,prompt
	syscall $print_string

	la	$a0,chico	# init base address
	li	$a1,100
	jal	getSum	
	
	lw	$t1,400($a0)	#print chico[99]
	mov	$a0,$t1
	syscall	$print_int

	mov	$a0,$v0
	syscall	$print_int
	syscall	$exit

##################################################################
# init(int *array: a0, int size: a1)
initArray:
	mov	$t0,$a0		# base 
	mov	$t1,$a1		# size
	mov	$t2,$0		# init index
	b	forInitTest

forInitLoop:			# block of loop body
	sll	$t4,$t2,2	# index = mult. 4
	add	$t4,$t4,$t0	# base + index
	addi	$t5,$t5,1
	sw	$t5,0($t4)	# chico[base + index]
	addi	$t2,$t2,1	# incr. step

forInitTest:
	slt	$t3,$t2,$t1	# test
	bnez	$t3,forInitLoop	# branch to loop body
	jr	$ra
##################################################################
 
# getsum(int *array: a0, int size: a1) return v0
getSum:
	mov	$t0,$a0		# base
	mov	$t1,$a1		# size
	b	forTest

forLoop:			# block of loop body
	sll	$t4,$t2,2	# index = mult. 4
	add	$t4,$t4,$t0	# base + index
	lw	$t5,0($t4)	# chico[base + index]
	add	$v0,$v0,$t5	# sum += chico[base + index]
	addi	$t2,$t2,1	# incr. step
forTest:
	slt	$t3,$t2,$t1	# test
	bnez	$t3,forLoop	# branch to loop body
	
	sll	$t1,$t1,2	# save sum to array[size + 1]
	add	$t1,$t1,$t0
	sw	$v0,($t1)
	jr	$ra

##################################################################

clearTempRegister:
	mov	$t0,$0		# clear
	mov	$t1,$0		# clear
	mov	$t2,$0		# clear
	mov	$t3,$0		# clear
	mov	$t4,$0		# clear
	mov	$t5,$0		# clear
	mov	$t6,$0		# clear	
	mov	$t7,$0		# clear
	jr	$ra

	