box:	.struct
ul:	.byte	0	
um:	.byte 	0
ur:	.byte	0
ml:	.byte	0
mm:	.byte	0
mr:	.byte	0
bl:	.byte	0
bm:	.byte	0
br:	.byte	0

	.data
boxd: 	.ascii	"…Õª"
	.ascii	"∫ ∫"
	.ascii	"»Õº"

boxs:	.ascii	"⁄ƒø"
	.ascii	"≥ ≥"
	.ascii	"¿ƒŸ"
prompt:	.asciiz	"\nPlease enter a n(1-6): "

	.globl	main
	.code	
main:
	li	$a0,'\f		# clear screen
	syscall	$print_char
	la	$a0,prompt
	syscall	$print_string
	syscall	$read_int
	mov	$a0,$v0

	jal	calSize		

	li	$a0,'\f		
	syscall	$print_char
	li	$a0,0
	li	$a1,0
	li	$a2,5
	li	$a3,3	
	la	$s0,boxd

	add	$s6,$0,$v1
	add	$s5,$0,$v0

	li	$s1,0
	b	mainOutLoopTest
mainOutLoop:	
	sll	$a1,$s1,1	
	add	$a1,$a1,$s1
	mov	$s4,$a1		

	li	$s2,0
	b	mainInLoopTest
mainInLoop:
	sll	$a0,$s2,2	
	add	$a0,$a0,$s2
	mov	$a1,$s4		
	jal	DrawBox
	mov	$a1,$s4
	addi	$s2,$s2,1
mainInLoopTest:	
	blt	$s2,$s6,mainInLoop	

	addi	$s1,$s1,1
mainOutLoopTest:

	blt	$s1,$s5,mainOutLoop	

	syscall	$exit

# box.draw(int x:a0, int y:a1, int width:a2, int height:a3, box * b:s0)
DrawBox:
	########clear register#################
	mov	$t9,$0
	mov	$t8,$0
	mov	$t7,$0
	mov	$t6,$0
	mov	$t5,$0
	mov	$t4,$0
	mov	$t3,$0
	mov	$t2,$0
	mov	$t1,$0
	mov	$t0,$0
	###############…Õª#####################
	mov 	$t9,$a0		# backup x

	syscall	$xy		# (0,0)print up left
	lb	$a0,box.ul($s0)
	syscall	$print_char

	add	$t8,$t9,$a2	# (0, width)
	addi	$t8,$t8,-1	# (0, width - 1)
	mov	$t0,$t9		# x
	b	test
	
1:	mov	$a0,$t0
	syscall	$xy
	lb	$a0,box.um($s0)
	syscall	$print_char			
test:	
	addi	$t0,$t0,0x1
	bne	$t0,$t8,1b	

	mov	$a0,$t0
	syscall $xy		
	lb	$a0,box.ur($s0)
	syscall	$print_char
	mov	$a0,$t9
	###############∫ ∫#####################
	mov	$t9,$a0		
	mov	$t8,$a1		
	add	$t7,$t9,$a2		
	addi	$t7,$t7,-1	
	add	$t6,$t8,$a3
	addi	$t6,$t6,-1	

	mov	$t1,$t8
	b	testoutLoop
outLoop:
	mov	$t0,$t9		
	mov	$a1,$t1		

	mov	$a0,$t0
	syscall	$xy
	lb	$a0,box.ml($s0)
	syscall	$print_char
	b	testInLoop
inLoop:
	mov	$a0,$t0
	syscall	$xy
	lb	$a0,box.mm($s0)
	syscall	$print_char
testInLoop:
	addi	$t0,$t0,0x1
	bne	$t7,$t0,inLoop

	mov	$a0,$t7
	syscall	$xy
	lb	$a0,box.mr($s0)
	syscall	$print_char
		
testoutLoop:	
	addi	$t1,$t1,0x1	
	bne	$t6,$t1,outLoop
##############»Õº#################################
	mov	$a1,$t6
	mov	$a0,$t9
	syscall	$xy
	lb	$a0,box.bl($s0)
	syscall	$print_char

	add	$t7,$t9,$a2
	addi	$t7,$t7,-1	
	mov	$t0,$t9		
	b	testB
	
b:	mov	$a0,$t0
	syscall	$xy
	lb	$a0,box.bm($s0)
	syscall	$print_char			
testB:	
	addi	$t0,$t0,0x1
	bne	$t0,$t7,b	

	mov	$a0,$t0
	syscall $xy		
	lb	$a0,box.br($s0)
	syscall	$print_char
	mov	$a0,$t9

	jr	$ra

###########calSize(int n: a0) return (v0, v1)#########
## a little bit trick, be careful#####################
calSize:
	addi	$t0,$a0,0x1
	andi	$t7,$t0,0x1	# flag of even or odd
	srl	$t1,$t0,0x1	# div 2
	li	$v0,0x1
	sll	$v0,$v0,$t1
	sll	$v1,$v0,$t7	# mult 1 or 2

	jr	$ra