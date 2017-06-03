########################################################################
# char* DayName(unsigned int n)
#
# description:
#	returns pointer to character string that identifies the day of
#	the week, 0-6 -> Sunday-Saturday.
#
# arguments:
#	a0	day number (0-6)
# returns:
#	v0	pointer to character
# uses:
#	t0-t1, hi & lo
# pseudo code:
# {
#    static char *Days[] = {"Sunday","Monday","Tuesday","Wednesday",
#			    "Thursday","Friday","Saturday"};
#    n %= 7;
#    n += (n<0)?7:0;
#    return Days[n];
# }
#------------------------------------------------------------ 40 points max
	.data		# Constants need by this routine
Days:	.word	0f,1f,2f,3f,4f,5f,6f
	

0:	.asciiz "Sunday"
1:	.asciiz "Monday"
2:	.asciiz "Tuesday"
3:	.asciiz "Wednesday"
4:	.asciiz "Thursday"
5:	.asciiz "Friday"
6:	.asciiz "Saturday"

	.code
DayName:		# your code goes here (25 points)
	la	$v0,Days
	xori	$t7,$0,7
	div	$a0,$t7
	mfhi	$a0

	bgez	$a0,next
	addi	$a0,7
next:
	sll	$a0,$a0,2
	add	$v0,$v0,$a0
	lw	$v0,($v0)
return:	jr	$ra

########################################################################
# Main Routine is Provided below. DO NOT ALTER.
# reading this code is probably a waste of your time.
########################################################################
	.code
	.globl	main
main:	la	$a0,prompt
	syscall	$print_string
	syscall	$read_int
	mov	$a0,$v0
	jal	DayName
	move	$a0,$v0
	syscall	$print_string
	b	main
#--------------------------------------
	.data
prompt:	.asciiz	"\nEnter an integer for the day of the week: "