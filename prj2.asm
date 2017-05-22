######################## Code modified from Dr.Doering  #########################
# { box class
box:	.struct
ul:	.byte	0			# upper left
top:	.byte	0
ur:	.byte	0			# upper right
left:	.byte	0
middle:	.byte	0
right:	.byte	0
ll:	.byte	0   			# lower left
bot:	.byte	0			# bottom
lr:	.byte	0			# lower right
	.data
# { instances of box}
boxBlank:
	.ascii	"         "
boxd:	.ascii	"ÉÍ»"
	.ascii	"º°º"
	.ascii	"ÈÍ¼"
boxs:	.ascii	"ÚÄ¿"
	.ascii	"³ ³"
	.ascii	"ÀÄÙ"
boxw:	.ascii	"ÜÜÜ"
	.ascii	"İ Ş"
	.ascii	"ßßß"
boxg1:	.ascii	"°°°° °°°°"
boxb:	.ascii	"ÛÛÛÛ ÛÛÛÛ"

#-------------------------------------------------------------------------------

# void box::draw(int x:a0, int y:a1, int w:a2, int h:a3,box *this:s0)
	.code
box.draw:
	mov	$t9,$a0			# save x for re-use
	syscall	$xy			#
	lb	$a0,box.ul($s0)
	syscall	$print_char
	lb	$a0,box.top($s0)
	mov	$t0,$a2
	b	2f
1:	syscall	$print_char
	addi	$t0,$t0,-1
2:	bgtz	$t0,1b
	lb	$a0,box.ur($s0)
	syscall $print_char
	mov	$a0,$t9
	addi	$a1,$a1,1
	syscall	$xy
	b	4f
3:	lb	$a0,box.left($s0)
	syscall $print_char
	lb	$a0,box.middle($s0)	#
	mov	$t0,$a2
	b	2f
1:	syscall	$print_char
	addi	$t0,$t0,-1
2:	bgtz	$t0,1b
	lb	$a0,box.right($s0)
	syscall	$print_char
	mov	$a0,$t9
	addi	$a1,$a1,1
	syscall	$xy
	addi	$a3,$a3,-1
4:	bgtz	$a3,3b
	lb	$a0,box.ll($s0)
	syscall	$print_char
	lb	$a0,box.bot($s0)
	mov	$t0,$a2
	b	2f
1:	syscall	$print_char
	addi	$t0,$t0,-1
2:	bgtz	$t0,1b
	lb	$a0,box.lr($s0)
	syscall $print_char
	jr	$ra
#
Randomize:
	.extern lfsr, word
	.code
	
	syscall	$random	
	beqz	$v0,Randomize
	sw	$v0,lfsr($gp)
	jr	$ra
	
Random:
#	unsigned int LFSRPRNG() 
#    lfsr = (lfsr >> 1) ^ (-(signed int)(lfsr & 1) & 0xd0000001u); 
taps	= 1<<1|1<<2|1<<28|1
	lw	$t0,lfsr($gp)
	li	$v0,taps
	andi	$a0,$t0,1
	neg	$a0,$a0
	and	$v0,$v0,$a0
	srl	$t0,$t0,1
	xor	$v0,$v0,$t0
	sw	$v0,lfsr($gp)
	jr	$ra
#-------------------------------------------------------------------------------
	.data
fileName:	.asciiz	"dictionary3.txt"
	.align 2
words = 611
fileSize = words*4
three:	.space fileSize

	.code
### loadFromFileToMem(File * filename: fileName) return a1 as the address of three
FileRead:
### open save handle
	li	$v0,13		# system call for open file
	la	$a0,fileName	# file name
	li	$a1,0		# open for reading
	li	$a2,0		
	syscall			# open a file
	mov	$s6,$v0		# save the handler

### read ###
	li	$v0,14		#system call for read from file
	mov	$a0,$s6		# file handler
	la	$a1,three	# address of buffer to which to read
	li	$a2,fileSize	# buffer length
	syscall			#read from file

### close
	li	$v0,16		# system call for close file
	mov	$a0,$s6		# file handler to close
	syscall			# close file
	
	jr	$ra

#-------------------------------------------------------------------------------
	.data

word	 =	4
	.align 2
deck:	.space	128*4
	.code
#	void ChooseWords(int N: a0)
#	source: three
#	target  deck 

ChooseWords:
	addi	$sp,$sp,-4
	sw	$ra,($sp)

	mov	$t9,$a0			
	mov	$t8,$0

#	la	$t0,three
#	mov	$t0,$a1
	la	$t1,deck
	mov	$t4,$t1
1:
	jal	Random
	
	la	$t0,three
			
	li	$t2,610			# index = random % (610 - i)
	sub	$t2,$t2,$t8
	divu	$v0,$t2
	mfhi	$t5			# index t5
	
	sll	$t3,$t5,2		# index * 4
	add	$t3,$t0,$t3		# (three + index * 4)
	lw	$t3,($t3)		# * (three + index * 4)
	
	sw	$t3,($t4)		# *(deck + i * 4) = * (three + index * 4)
	sw	$t3,word($t4)		# save two copies of the word into deck
	addi	$t4,$t4,2*word
	
	sll	$t6,$t2,2		# times 4
	add	$t6,$t0,$t6
	lw	$t6,($t6)

	sll	$t3,$t5,2		# index * 4
	add	$t3,$t0,$t3		# (three + index * 4)
	sw	$t6,($t3)		# * (three + index * 4) = *(three + 610 - i)

	addi	$t8,2
	blt	$t8,$t9,1b

	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr	$ra

#-------------------------------------------------------------------------------
#	void Shuffle(int array[ ]:a0, int N:a1)
Shuffle:
	addi	$sp,$sp,-4
	sw	$ra,($sp)

	mov	$t8,$a0
	mov	$t9,$a1

1:	jal	Random
	divu	$v0,$t9		
	mfhi	$t0		# index
	
	sll	$t0,$t0,2	# times 4
	add	$t1,$t8,$t0	
	lw	$t2,($t1)

	addi	$t9,$t9,-1
	sll	$t4,$t9,2
	add	$t4,$t8,$t4
	lw	$t3,($t4)
	
	sw	$t3,($t1)
	sw	$t2,($t4)
	bgtz	$t9,1b
	
	lw	$ra,($sp)
	addi	$sp,$sp,4

	jr	$ra
#-------------------------------------------------------------------------------

#{ card class ------------------------------------------------------
card: 	.struct
word:	.word
x:	.byte 	0
y:	.byte 	0
hide:	.byte 	0
faceup: .byte   0
	.code

#{ card.new(int x:a0, int y:a1, wordString w:a2, bool faceup:a3)
card.new:
	mov	$t0,$a0		# save $a0
	addi	$a0,$0,card	# card is size
	syscall	$malloc
	mov	$a0,$t0
	mov	$s0,$v0		# save the address of allocated memory

card.card:
	sb	$a0,card.x($s0)
	sb	$a1,card.y($s0)
	sw	$a2,card.word($s0)
	sb	$0,card.word+3($s0)
	sb	$a3,card.faceup($s0)
	sb	$0,card.hide($s0)
	jr 	$ra
#{ card.draw(card * this:s0)
card.draw:
	syscall	$xy
	mov	$a0,$s0
	mov	$a1,$0
	mov	$a2,$0
	syscall	$print_string
	jr	$ra
# }

#-------------------------------------------------------------------------------
	.data
prompt:	.asciiz	"\fPlease enter the level of difficulty (1-6): "  
exit:	.asciiz	" Press Enter to continue, x to exit: "
                                                                 
  	.code
	.globl	main
main:
#{ project 2
	jal	FileRead		# get the word list
#}
	la	$a0,prompt
	syscall	$print_string
	syscall	$read_int
	beqz	$v0,main		#
	sltiu	$t0,$v0,7		# check for out-of-range
	beqz	$t0,main		# try again 
	addi	$a0,$0,'\f		# clear the screen
	syscall	$print_char
	li	$s1,2			# initial boxes wide
	li	$s2,1			# initial boxes tall
	andi	$t0,$v0,1		# odd?
	srl	$v0,$v0,1		# divided by 2
	sllv	$s1,$s1,$v0
	add	$v0,$v0,$t0
	sllv	$s2,$s2,$v0
#{ project 2
	mul	$s3,$s2,$s1		# calculate N
	jal	Randomize
	mov	$a0,$s3
	jal	ChooseWords
	la	$a0,deck
	mov	$a1,$s3
	jal	Shuffle

	la	$s5,deck
	mov	$s4,$0			# working counters y
	mov	$s3,$0			#                  x	
	
#}
	la	$s0,boxs
	mov	$s4,$0			# working counters y
	mov	$s3,$0			# 		   x
2:	li	$a2,3			# width of middle of box
	li	$a3,1			# height of middle of box
	sll	$a0,$s3,2
	add	$a0,$a0,$s3		# x = 5 * s3
	sll	$a1,$s4,1
	add	$a1,$a1,$s4		# y = 3 * s4
	la	$s0,boxs
	jal	box.draw
	
	#--------------------

	# card.new(int x:a0, int y:a1, wordString w:a2, bool faceup:a3)
	
	sll	$a0,$s3,2
	add	$a0,$a0,$s3		# x = 5 * s3
	sll	$a1,$s4,1
	add	$a1,$a1,$s4		# y = 3 * s4

	addi	$a0,1
	addi	$a1,1
	lw	$a2,($s5)
	addi	$s5,$s5,4
	addi	$a3,$0,0x1		# faceup

	jal	card.new
	jal	card.draw
	
	#--------------------

	addi	$s3,$s3,1		
	bne	$s3,$s1,2b
	mov	$s3,$0
	addi	$s4,$s4,1
	bne	$s4,$s2,2b
	la	$a0,exit
	syscall	$print_string
	syscall	$read_char
	bne	$v0,'x,main
	syscall	$exit
	                                                                              
                                                                                