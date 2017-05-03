	.data
prompt:	.asciiz	"\n The begin of program..."

	.globl	main
	.code
main:
	li	$a0,3
	li	$a1,2
	li	$a2,4
	jal	sort3Num
	syscall	$exit

sort3Num
	blt	$a0,$a1,1f
	xor	$a0,$a1,$a0
	xor	$a1,$a1,$a0
	xor	$a0,$a1,$a0

1:	
	blt	$a0,$a2,2f
	xor	$a0,$a2,$a0
	xor	$a2,$a2,$a0
	xor	$a0,$a2,$a0
2:
	blt	$a1,$a2,3f
	xor	$a1,$a2,$a1
	xor	$a2,$a2,$a1
	xor	$a1,$a2,$a1

3:
	jr	$ra