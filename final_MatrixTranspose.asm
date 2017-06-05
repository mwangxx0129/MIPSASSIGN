	.data
M1:	.word 1,2,3,4
	.word 5,6,7,8
	.word 9,10,11,12
	.word 13,14,15,16

transpose:
	.word 0,0,0,0
	.word 0,0,0,0
	.word 0,0,0,0
	.word 0,0,0,0
prompt:	.asciiz	"\n|----------After transpose-----------|\n"
	.globl	main
	.code
main:
	li	$a0,'\f		# clear screen
	syscall	$print_char

	la	$a0,M1	# print	# print original matrix
	jal	MatrixPrint

	la	$a1,M1		# transpose
	la	$a2,transpose
	addi	$s0,$0,4
	addi	$s1,$0,4
	jal	Matrix.transpose

	la	$a0,prompt
	syscall	$print_string

	la	$a0,transpose	# print transpose matrix
	jal	MatrixPrint
	syscall	$exit

############ DO NOT MODIFY ANYTHING BELOW HERE ################################
# the following is C++ code for the matrix print and main routines
# Read at your own peril. Modify and you will be awarded a zero score.
#void MatrixPrint(int m[4][4] : a0)
#{
#	for (int i=0;i<4;i++)
#	{
#		for (int j=0;j<4;j++)
#			cout<< m[i][j]<< '\t' ;
#		cout << '\n';
#	}
#}
MatrixPrint: 
	mov	$t0,$a0
	addi	$t2,$0,4
1:	addi	$t3,$0,4
2:	lw	$a0,($t0)
	addi	$t0,$t0,4
	syscall	$print_int
	addi	$a0,$0,'\t
	syscall	$print_char
	addi	$t3,$t3,-1
	bgtz	$t3,2b
	addi	$a0,$0,'\n
	syscall	$print_char
	addi	$t2,$t2,-1
	bgtz	$t2,1b
	jr	$ra


#############################################################################################
	.code
Matrix.transpose:	# transpose(int M1[s0][s1] : a1, int M2[s1][s0] : a2)
	mov	$t1,$0	# row
loop1:	mov	$t2,$0	# col
loop2:	
				# M2[t2][t1] = M1[t1][t2]
	mul	$t3,$t1,$s1	# t3 = t1 * M1.col + t2	
	add	$t3,$t3,$t2
	sll	$t3,$t3,2		# t3 *= 4
	add	$t3,$a1,$t3	# t3 = a1 + t3
	lw	$t3,($t3)

	mul	$t4,$t2,$s0	# t4 = t2 * M2.col + t1
	add	$t4,$t4,$t1
	sll	$t4,$t4,2		# t4 *= 4
	add	$t4,$a2,$t4	# t4 = a2 + t4	
	sw	$t3,($t4)		
	
	addi	$t2,$t2,1	# col ++
	blt	$t2,$s1,loop2	

	addi	$t1,$t1,1	# row ++
	blt	$t1,$s0,loop1
	jr	$ra
#############################################################################################	