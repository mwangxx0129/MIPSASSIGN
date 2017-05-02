
#	if (a1 < a0) 
#		swap a0 a1
#	if (a2 < a0)
#		swap a0 a2
#	else if (a2 < a1)
#		swap a1 a2
	.globl	main
	.code
main:	
	li	$a0,9
	li	$a1,71
	li	$a2,8
	jal	sort3Num
	syscall	$exit

sort3Num:
	slt	$t0,$a1,$a0
	beqz	$t0,secondIf
	xor	$a0,$a0,$a1
	xor	$a1,$a0,$a1
	xor	$a0,$a0,$a1
	
secondIf:
	slt	$t0,$a2,$a0
	beqz	$t0,thirdIf
	xor	$a0,$a0,$a2
	xor	$a2,$a0,$a2
	xor	$a0,$a0,$a2

thirdIf:
	slt	$t0,$a2,$a1
	beqz	$t0,end
	xor	$a1,$a1,$a2
	xor	$a2,$a1,$a2
	xor	$a1,$a1,$a2
end:
	jr 	$ra

	
