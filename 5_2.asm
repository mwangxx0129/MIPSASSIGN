	.data
prompt:	.asciiz		"\n Copy from SRC to DEST..."

SRC:	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
	.word 0,1,2,3,4,5,6,7,8,9
DES:	.space 4*100


	.code
	.globl	main
main:	
	la	$a0,prompt
	syscall	$print_string

	la	$a0,SRC		# 1st parameter
	la	$a1,DES		# 2nd parameter
	addi	$a2,$0,100	# 3rd parameter
	jal	copyWords	# call copyWords
	
	lw	$a0,44($a1)
	syscall	$print_int
	syscall	$exit

##################################################################
 
# copyWords(const int *src: a0, const int *des: a1, int size: a2)
copyWords:
	mov	$t0,$a0		# src
	mov	$t1,$a1		# des	
	mov	$t2,$a2		# size
	mov	$t3,$0		# index
	b	forTest

forLoop:			# block of loop body
	sll	$t4,$t3,2	# offset = index * 4
	add	$t5,$t4,$t0	# src + index
	lw	$t6,0($t5)	# t6 = *(src + offset)
	add	$t5,$t4,$t1	# des + index
	sw	$t6,0($t5)	# *(des + offset) = t6
	addi	$t3,$t3,1	# incr. step

forTest:
	slt	$t7,$t3,$t2	# test
	bnez	$t7,forLoop	# branch to loop body

	jr	$ra

##################################################################