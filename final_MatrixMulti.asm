# Midterm Exam Question 3 worth 88 points
# Matrix Multiplication (4x4)
#
# Graphic displays require the use of 4-by-4 arrays that act as Matrices 
# (plural of Matrix) to control view transformations.
# We can store a matrix into a computer's memory by filling consecutive elements
# with members of a row (horizontal) and continue with each successive row of 
# the matrix. Such an array might be declared and initialized in c++ like this:
#	    int M[4][3] = {{ 1, 2, 3, 4 },
#			   { 5, 6, 7, 8 },
#			   { 9,10,11,12 },
#			   {13,14,15,16 }};
# which we can translate to assembly like this:
	.data
M1:	.word 1,2,3,4
	.word 5,6,7,8
	.word 9,10,11,12
	.word 13,14,15,16
	
# To multiply two matrices requires that the number of rows in the right matrix,
# R[k][_], match the number of columns in the left matrix L[_][k]. The resulting
# matrix P will have the same number of rows as the left matrix, and the same 
# number of columns as the right. 
# Each element P[i][j] is the summation of the products  L[i][n] * R[n][j] where 
# n iterates from 0 to k-1;	
	
#C++ code for the matrix Global Data objects:
#include <iostream>
#using namespace std;
# int M1[4][4]={{ 1, 2, 3, 4},
#		{ 5, 6, 7, 8},
#		{ 9,10,11,12},
#		{13,14,15,16}};
# int M2[4][4]={{16,15,14,13},
#		{12,11,10, 9},
#		{ 8, 7, 6, 5},
#		{ 4, 3, 2, 1}};
#int P[4][4];
	.data
M2:	.word	16,15,14,13
	.word	12,11,10,9
	.word	8,7,6,5
	.word	4,3,2,1
P:	.space 	4*4*4
#C++ code for the matrix multiply (4x4) :
#void MatrixMult(int P[4][4], int L[4][4], int R[4][4])
#{
#	int *p = &P[0][0];
#	int *lp = &L[0][0];
#	for (int i =4; i > 4; i--, lp+=4){
#	   int *rp = &R[0][0];
#	   for (int j = 4; j >0; j--, rp+=1){
#	 	int *ll=lp;
#		int *rr=rp;
#		int sum = 0;
#		for (int k = 4;k > 0; k--, rr+=4)
#		    sum += *ll++ * *rr; 
#		*p++ = sum;
#		}
#	}
#}
	.code
# registers: p=a0  lp= a1  i= t0  j=t1 k=t2 rp=t3 ll=t4 rr=t5 sum=t6 temp=t7
MatrixMult:  #void MatrixMult(int P[4][4]:a0, int L[4][4]:a1, int R[4][4]:a2)
					#{
					#	int *p = &P[0][0];
					#	int *lp = &L[0][0];
	addi	$t0,$0,4			#	for (int i = 4; i > 0; i--, lp+=4){
loop1:	mov	$t3,$a2				#	   int *rp = &R[0][0];

	addi	$t1,$0,4	
loop2:						#	   for (int j = 4; j >0; j--, rp+=1){
	mov	$t4,$a1				#	 	int *ll=lp;
	mov	$t5,$t3				#		int *rr=rp;
	mov	$t6,$0				#		int sum = 0;
	
	addi	$t2,$0,4			#		for (int k = 4;k > 0; k--, rr+=4)
loop3: 	lw	$t7,0($t5)			#		    sum += *ll++ * *rr; 
	lw	$t8,0($t4)				#		*p++ = sum;
	mul	$t7,$t7,$t8
	add 	$t6,$t6,$t7
	addi	$t2,-1				
	addi	$t5,16
	addi	$t4,4
	bgtz	$t2,loop3	#		}
	sw	$t6,0($a0)
	addi	$a0,$a0,4	

	addi	$t1,-1			
	addi	$t3,4
	bgtz	$t1,loop2	#	}	

	addi	$t0,-1			
	addi	$a1,16
	bgtz	$t0,loop1
	jr	$ra		#}

				
############ DO NOT MODIFY ANYTHING BELOW HERE ################################
# the following is C++ code for the matrix print and main routines
# Read at your own peril. Modify and you will be awarded a zero score.
#void MatrixPrint(int m[4][4])
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
#int main()
#{
#	MatrixPrint(M1);
#	cout << "   * \n";
#	MatrixPrint(M2);
#	cout << "   = \n";
#	MatrixMult(P,M1,M2);
#	MatrixPrint(P);
#	return 0;
#}
	.globl	main
main:
	la	$a0,'\f
	syscall	$print_char
	la	$a0,M1
	jal 	MatrixPrint
	la	$a0,times
	syscall	$print_string
	la	$a0,M2
	jal	MatrixPrint
	la	$a0,equals
	syscall	$print_string
	la	$a0,P
	la	$a1,M1
	la	$a2,M2
	jal	MatrixMult
	la	$a0,P
	jal	MatrixPrint
	syscall	$exit
	.data
times: .asciiz	"   * \n"
equals: .asciiz "   = \n"