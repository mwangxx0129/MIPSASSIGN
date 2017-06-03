#
################################################################################
#	Function MinMax(int* Array,int Size)
#
#
#	Arguments:	(need not be preserved)
#	a0: pointer to the array (will not be null)
#	a1: size of the array (is guaranteed to be at least one)
#
#	Returns:
#	v0: the minimum of the values of the integers in the array
#	v1: the maximum of the values of the integers in the array
#
#	Other registers used:
#	t0: holds current value from the array
#	t1: used for binary values
#	t2: address following array
#	(for the purpose of the exam, comments need not be provided.)
#----------------------------------------------------------------------------
#pseudocode:
#intPair MinMax(int* a0,unsigned int a1)
#{
#	v1 = v0 = *a0;		//initialize both return values to first element
#	t2 = a0 + 4 * a1;	//calculate stopping pointer value
#	do	{
#	t0 = *a0++;		// get the element and move the pointer
#	if (t0 < v0)	 // check for new minimum
#		v0 = t0;	// set new minimum
#	if (t0 > v1)	 // check for new maximum
#		v1 = t0;	// set the maximum
#	}while ( a0 != t2 );	// till the pointer match
#}
#-----------------------------------------------------------------------------
# 50 points 1 each for opcode and each operand, () count as 1
MinMax:
	lw	$v0,($a0)	# min
	mov	$v1,$v0	# max

	sll	$t2,$a1,2
	add	$t2,$a0,$t2	
1:	
	lw	$t0,($a0)
	bgt	$t0,$v0,2f
	mov	$v0,$t0
	b 	next

2:	blt	$t0,$v1,next
	mov	$v1,$t0

next:	addi	$a0,4
	bne	$t2,$a0,1b
	jr	$ra


##############################################################################
#	Main will ask for the array size, and for all of the elements in the
# array, call the function and display the answer.
#
#	Register Usage in main: (unimportant to the exam and should not be used)
#
#
##############################################################################
# I reccomend NOT wasting your time during the exam reading this code.
# You may not modify the code below without my express permission. 

	 .data
Prompt1: .asciiz "How many Numbers do you want to put in the Array?: "
Prompt2: .asciiz "Enter element: "
Ans:	 .asciiz "The range is: "

	.word	1
	.code
	.globl	main
main:	la	$a0,Prompt1		# do{
	li	$v0,4			#	
	syscall	$print_string		#	cout << Prompt1
	syscall	$read_int		#	cin >> N
	move	$s0,$v0		 #
	blez	$s0,main		#	} while (N<=0)
	sll	$a0,$s0,2		#
	syscall	$malloc		 # ptr = new int Arr[N]
	move	$s2,$v0		 #
	move	$t0,$s2		 #
	move	$t1,$s0		 # for (i=N; i>0; i--,ptr++)
fillLoop:		
	la	$a0,Prompt2		#	{
	li	$v0,4			#	cout>> Prompt2;
	syscall			 #
	li	$v0,5			#	cin>> *ptr;
	syscall			 #
	sw	$v0,0($t0)		#
	addi	$t0,$t0,4		#
	addi	$t1,$t1,-1		#
	bgtz	$t1,fillLoop		#
	move	$a0,$s2		 #
	move	$a1,$s0		 #
	jal	MinMax			# (min,max) = Range( ptr, size)
	nop				#
	la	$a0,Ans		 #
	syscall	$print_string		# cout << Ans;
	move	$a0,$v0		 # 
	syscall	$print_int		# cout<< min << ':' << max ;
	addi	$a0,$0,':		#
	syscall	$print_char		#
	move	$a0,$v1		 # max
	syscall	$print_int		#
	syscall	$exit			# exit