######################## Code modified from Dr. Doering  #########################
# { box class --------------------------------------------------------------------
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
boxd:	
	.ascii	"�X�T�["
	.ascii	"�U  �U"
	.ascii	"�^�T�a"
boxs:	
	.ascii	"������"
	.ascii	"��  ��"
	.ascii	"������"
boxw:	
	.ascii	"�{�{�{"
	.ascii	"�� ?"
	.ascii	"???"
boxg1:	
	.ascii	"???? ????"
boxb:	
	.ascii	"�������� ��������"
# Frame Pointer Offsets-----------------------------------------------------------
fp.ra = 4
fp.fp = 0 # may be omitted
fp.a0 = 8
fp.a1 = 12
fp.a2 = 16
fp.a3 = 20
fp.a4 = 24 # has no register counterpart
fp.a5 = 28
fp.a6 = 32
fp.a7 = 36 # user may define higher  a s
fp.s0 = -4
fp.s1 = -8
fp.s2 = -12
fp.s3 = -16
fp.s4 = -20
fp.s5 = -24
fp.s6 = -28
fp.s7 = -32
fp.loc = -36 # offsets can be added to this!
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
################################################################################
	.data
topRankFile:	.asciiz	"topRank.txt"
	.align 2
topRankNum = 6*5
topRankSize = topRankNum*4
topRankArray:	.space topRankSize
	.code
initTopRankArray:
### open ###
	la	$a0,topRankFile	# [%file name%]
	li	$a1,0		# open for reading
	li	$a2,0		
	syscall	$open		# open a file
	mov	$s6,$v0		# save the handler
### read ###
	mov	$a0,$s6		# file handler
	la	$a1,topRankArray# [%address of buffer to which to read%]
	li	$a2,topRankSize	# [%buffer length%]
	syscall	$read		# read from file
### close ###
	mov	$a0,$s6		# file handler to close
	syscall	$close		# close file
	jr	$ra
#------------------------------------------------------------------------------------------
writeTopRankToFile:
### open ###
	la	$a0,topRankFile	# [%file name%]
	li	$a1,1		# open for writing
	li	$a2,0		
	syscall	$open		# open a file
	mov	$s6,$v0		# save the handler
### read ###
	mov	$a0,$s6		# file handler
	la	$a1,topRankArray# [%address of buffer to which to read%]
	li	$a2,topRankSize	# [%buffer length%]
	syscall	$write		# read from file
### close ###
	mov	$a0,$s6		# file handler to close
	syscall	$close		# close file
	jr	$ra
################################################################################
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
### open ###
	la	$a0,fileName	# [%file name%]
	li	$a1,0		# open for reading
	li	$a2,0		
	syscall	$open		# open a file
	mov	$s6,$v0		# save the handler
### read ###
	mov	$a0,$s6		# file handler
	la	$a1,three	# [%address of buffer to which to read%]
	li	$a2,fileSize	# [%buffer length%]
	syscall	$read		# read from file
### close ###
	mov	$a0,$s6		# file handler to close
	syscall	$close		# close file
	jr	$ra
#-------------------------------------------------------------------------------
	.data
word	 =	4
	.align 2
deck:	.space	128*4
	.code
deck.clear:
	la	$t0,deck
	addi	$t1,$t0,128*word
1:	sw	$0,($t0)
	addi	$t0,$t0,word
	bne	$t1,$t0,1b
	jr	$ra
#	void ChooseWords(int N: a0)
#	source: three
#	target  deck 
ChooseWords:
	addi	$sp,$sp,-4
	sw	$ra,($sp)
	jal	deck.clear
	mov	$t9,$a0			
	mov	$t8,$0
	la	$t1,deck
	mov	$t4,$t1
1:
	jal	Random
	
	la	$t0,three
			
	li	$t2,611			# index = random % (610 - i)
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
###############################################################################-
# card * card.new(int x:a0, int y:a1, wordString w:a2, bool faceup:a3)
# argument:
#	a0 : x
#	a1 : y
#	a2 : word
#	a3 : faceup	
# returns:
#	s0(v0) : this pointer
# uses:
#	t0
#	v0
#-------------------------------------------------------------------------------
# pseudocode
#-------------------------------------------------------------------------------
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
###############################################################################-
# void card.draw(card * s0)
# argument:
#	s0 : pointer to card
# returns:
#	void
# uses:
#	a0,a1,a2
#	t0,t1
#-------------------------------------------------------------------------------
# pseudocode
# 
# if (hide)
#	draw blank
# else if (!faceup)
#	draw facedown
# else 
#	draw faceup 
#	draw string
#
#-------------------------------------------------------------------------------
card.draw:
	addi	$sp,$sp,-24	# allocate space on the stack 
	sw	$fp,4($sp)	# save previous frame pointer
	addi	$fp,$sp,4	# create new frame pointer
	sw	$ra,fp.ra($fp)	# save return address
	sw	$s0,fp.s0($fp)	# save s0
	sw	$a0,fp.a0($fp)	# save a0
	sw	$a1,fp.a1($fp)  # save a1
	sw	$a2,fp.a2($fp)	# save a2	
	lw	$s0,fp.s0($fp)	# get card pointer
	lb	$a0,card.x($s0)	# draw(int x:a0, int y:a1, int w:a2, int h:a3,box *this:s0)-
	lb	$a1,card.y($s0)
	li	$a2,3			# width of middle of box
	li	$a3,1			# height of middle of box
	lb	$t0,card.faceup($s0)
	lb	$t1,card.hide($s0)
	beqz	$t1,2f	
	la	$s0,boxBlank	# draw blank
	jal	box.draw 
	b	1f
2:	bnez	$t0,3f
	la	$s0,boxd	# draw facedown
	jal	box.draw
	b	1f
3:	
	la	$s0,boxs	# draw faceup
	jal	box.draw
	lw	$s0,fp.s0($fp)	# draw string
	lb	$a0,card.x($s0)
	lb	$a1,card.y($s0)
	addi	$a0,1		# move cursor
	addi	$a1,1
	syscall	$xy
	lw	$s0,fp.s0($fp)
	mov	$a0,$s0		# get pointer of card
	syscall	$print_string
1:	lw	$a0,fp.a0($fp)	# restore a registers
	lw	$a1,fp.a1($fp)
	lw	$a2,fp.a2($fp)
	lw	$s0,fp.s0($fp)	# restore s register
	lw	$ra,fp.ra($fp)	# restore the return address
	lw	$fp,0($fp)	# restore previous Frame Pointer
	addi	$sp,$sp,24	# deallocate stack space
	jr	$ra
###############################################################################-
# void card.click(card * this : s0)
# argument:
#	s0 : pointer to card
# returns:
#	void
# uses:
#	a0 : flag used as faceup or hide
#       a1 : pointer to 1st global card
#	a2 : pointer to 2nd global card
#	t0,t1,t2,t4
#-------------------------------------------------------------------------------
card.click:	#void card.click(card * this : s0)
	.extern state,word		# static int state = 0
	.extern card1,word		# card pointer to 1st exposed card
	.extern card2,word		# card pointer to 2nd exposed card
	.extern turns,word		# count of card turne over (plays)
	.data
	.align 2
# state table:	not equal exposed; equal to exposed
stateTable:
0:	.word	1,card.expose1,0,card.error
1:	.word	2,card.expose2,0,card.cover1
2:	.word 	1,card.matchExp1,0,card.match
	.code
	lb	$t0,card.hide($s0)	#if this card no longer in the game
	bnez	$t0,card.error
	lw	$t0,state($gp)
	lw	$a1,card1($gp)
	lw	$a2,card2($gp)
	la	$t4,stateTable
	sll	$t0,$t0,4
	add	$t4,$t4,$t0		
	beq	$a1,$s0,3f
	bne	$a2,$s0,4f
3:	addi	$t4,$t4,word*2
4:	lw	$t0,($t4)		# load nex state
	lw	$t3,word($t4)		# load action routine
	sw	$t0,state($gp)		# save the new state
	addi	$a0,$0,1		# pass true 
	jr	$t3			# go to t3 routinue
card.expose1:
	sw	$s0,card1($gp)
5:	sb	$a0,card.faceup($s0)
	lw	$t0,turns($gp)
	addi	$t0,$t0,1
	sw	$t0,turns($gp)
	j	card.draw		# let you go, never come back
card.expose2
	sw	$s0,card2($gp)
	b	5b
card.cover1
	sw	$0,card1($gp)
	sb	$0,card.faceup($s0)
	j	card.draw
card.matchExp1:
	addi	$sp,$sp,-4		# allocate space on the stack 
	sw	$ra,($sp)
	mov	$s1,$s0			# save it as temp or save to stack, recover later
	sb	$a0,card.faceup($s0)
	jal	card.draw
	jal	card.isMatch
	sw	$s1,card1($gp)		# s1 come back, worked as card1 
	lw	$t0,turns($gp)
	addi	$t0,$t0,1
	sw	$t0,turns($gp)
	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr	$ra
card.error:
	jr	$ra
card.match:
	addi	$sp,$sp,-4
	sw	$ra,($sp)
	jal	card.isMatch
	lw	$ra,($sp)
	addi	$sp,$sp,-4
	jr	$ra
###############################################################################-
# void card.isMatch(card * a1, card * a2)
# argument:
#	a1 : pointer to card
#	a2 : pointer to card
# returns:
#	void
# uses:
#       a1 : pointer to 1st global card
#	a2 : pointer to 2nd global card
#
#-------------------------------------------------------------------------------
# pseudocode
# 
# if (*a1 ==  *a2)
#	card1.hide = 1
#	card2.hide = 1
# else 
#	card1.faceup = 0
#	card2.faceup = 0
# draw card1, card2
# card1 , card2 = null
# 
#-------------------------------------------------------------------------------
card.isMatch:
	addi	$sp,-8
	sw	$ra,($sp)
	sw	$s0,4($sp)
	lw	$t1,($a1)
	lw	$t2,($a2)
	bne	$t1,$t2,1f
	addi	$t0,$0,1		# set two cards to hide	
	sb	$t0,card.hide($a1)
	sb	$t0,card.hide($a2)
	jal	pair.minusOne
	b	2f
					
1:	sb	$0,card.faceup($a1)	# set two cards to face down
	sb	$0,card.faceup($a2)	
	
2:	mov	$s0,$a1			# draw the first global card
	jal	card.draw	
	mov	$s0,$a2			# draw the second global card
	jal	card.draw
	sw	$0,card1($gp)		# two cards will hide or faceup
	sw	$0,card2($gp)
	lw	$s0,4($sp)
	lw	$ra,($sp)
	addi	$sp,8
	jr	$ra
# ---------------------------------------------------------------------
	.code
IO_Devices:	= 0xa0000000		#{
keyboard.int 	= 2	#Keyboard Device {
keyboard:	.struct IO_Devices #start from hardware base address
flags:		.byte 0
mask:		.byte 0
		.half 0
keypress:	.byte 0,0,0
presscon:	.byte 0
keydown:	.half 0
shiftdown:	.byte 0
downcon:	.byte 0
keyup:		.half 0
upshift:	.byte 0
upcon:		.byte 0
		.data 			# Flag and mask bit mask values
KEY_PRESS 	= 0b00000001 		# these may be ored if needed
KEY_DOWN 	= 0b00000010
KEY_UP	 	= 0b00000100
KEY_SHIFT 	= 0b00000001 		# Shift flag values
KEY_ALT		= 0b00000010
KEY_CTRL 	= 0b00000100		#}
console.int 	= 3			#{
console:	.struct 0xa0000010 # start from console base address
flags:		.byte 0 	# only bit zero is used as ready
mask:		.byte 0 	# only bit zero used.
		.half 0 	# unused
char: 		.byte 0 	# ASCII data to screen
col: 		.byte 0 	# read: current; write: set
row: 		.byte 0 	# read: current; write: set
con: 		.byte 0 	# read: current; write: set }
mouse.int 	= 4			#{
md: 		.struct
x: 		.half 0 	# x data; 16 bits
y: 		.half 0 	# y data; 16 bits
shift: 		.byte 0 	# shift and button bits
con: 		.byte 0 	# Console number
wheel: 		.half 0 	# signed mouse wheel count
		.data
mouse: 		.struct 0xa0000018 # start from mouse base address
flags: 		.byte 0 	# 1 = move; 2 = down; 4 = up;...
mask: 		.byte 0 	# 8 = wheel; mask same as flags
unused: 	.half 0,0,0
move: 		.space	md 	# mouse move data
down: 		.space	md 	# mouse button down data
up: 		.space	md 	# mouse button up data
wheel: 		.space	md 	# mouse wheel data
wheeldn: 	.space	md 	# mouse wheel down data
wheelup: 	.space	md 	# mouse wheel up data }
		.data 
MOUSEMOVE	= 1
MOUSEDOWN	= 2
MOUSEUP		= 4
MOUSEWHEEL	= 8
# md.shift also contains KEY_SHIFT, KEY_ALT & KEY_CTRL 
mouseleft 	= 8
mouseright 	= 16
mousemiddle 	= 32
doubleclick 	= 64
timer.int	= 	6
timer:		.struct	0xa0000050
flags:		.byte	0
mask:		.byte	0
		
		.half	0
# timer registers: set periods by writing, clear flags by reading1
t1:		.word	0
t2:		.word	0
t3:		.word	0
t4:		.word	0
t5:		.word	0
t6:		.word	0
t7:		.word	0
		.data			#
		.align 2		# force word alignment }
mouseMap:	.space	16*9*word
		.code
mouseMap.clear:
	la	$t0,mouseMap
	addi	$t1,$t0,16*9*word
1:	sw	$0,($t0)
	addi	$t0,$t0,word
	bne	$t1,$t0,1b
	jr	$ra
	#}
ReadChar:		# char ReadChar() {
	la	$a0,keyboard.flags	# address of flag
	addi	$a1,$0,1		# request 1 byte
1:	syscall	$IO_read
	andi	$t0,$v0,KEY_PRESS	# wait for keyPressFlag
	beqz	$t0,1b			# allow random to progress
	addi	$a0,$a0,keyboard.keypress
	syscall	$IO_read
	jr	$ra			# }
###############################################################################-
# getMatrixSize(int n : v0) return (x : s1 , y : s2)
getMatrixSize:
	addi	$t0,$v0,0x1
	andi	$t7,$t0,0x1	# flag of even or odd
	srl	$t1,$t0,0x1	# div 2
	li	$s2,0x1
	sll	$s2,$s2,$t1
	sll	$s1,$s2,$t7	# mult 1 or 2
	jr	$ra
###############################################################################-
initStateTable:
	sw	$0,state($gp)
	sw	$0,card1($gp)
	sw	$0,card2($gp)
	sw	$0,turns($gp)
	jr	$ra
###############################################################################-
initMouseFlag:
	la	$a0,mouse.flags		# init the mouse flag
	addi	$a1,$0,1
	mov	$a2,$0
	syscall	$IO_write
	jr	$ra
###############################################################################-
# initMouseMap(int x : s3, int y : s4, card * ptr : s0)
#-------------------------------------------------------------------------------
initMouseMap:	
	sll	$t0,$s4,word		# mouseMap[y * 16 + x] = s0
	add	$t0,$t0,$s3
	sll	$t0,$t0,2		# word
	la	$t1,mouseMap
	add	$t0,$t0,$t1
	sw	$s0,($t0)
	jr	$ra
###############################################################################-
# initPairNum:(int n : s3)
# pairNum = s3 / 2
#-------------------------------------------------------------------------------
pair.init:
	srl	$t0,$s3,1		# size / 2
	sw	$t0,pairNum($gp)
	jr	$ra
#-------------------------------------------------------------------------------
pair.minusOne:
	lw	$t0,pairNum($gp)
	addi	$t0,-1
	sw	$t0,pairNum($gp)
	jr	$ra
#------------------------------------------------------------------------------	
##################################################################################################
# Delete all the cards, when the game is over. Clear the mouse Map and the shuffle array.
gameOver.deleteAllCards: #(card * deck)
	addi	$sp,-4
	sw	$ra,($sp)
	jal	mouseMap.clear
	la	$t0,deck
	lw	$t1,num($gp)
	sll	$t1,$t1,2		# times 4
	add	$t1,$t0,$t1
1:	lw	$a0,($t0)
	syscall	$free
	addi	$t0,$t0,word
	bne	$t1,$t0,1b
	lw	$ra,($sp)
	addi	$sp,4
	jr	$ra
##################################################################################################
	.data
win:	.asciiz	"You are NOT so coocoo :)"
	.code
pair.checkWin: # return $v0  1: win
	lw	$t0,pairNum($gp)
	mov	$v0,$0
	bnez	$t0,1f
	addi	$a0,$0,0
	addi	$a1,$0,0
	syscall	$xy
	la	$a0,win
	syscall	$print_string
	addi	$t0,$0,1
	mov	$v0,$t0
1:	
	jr	$ra
# { main -------------------------------------------------------------------------------
	.data
prompt:	.asciiz	"\fPlease enter the level of difficulty (1-6): " 
confirmExitPrompt:	.asciiz	"Please input enter to continue, x to exit: " 
exit:	.asciiz	"Game Over, Exit!!!"
	.extern pairNum,word		# static int state = s3 * s4 >>> 2
	.extern level,word
	.extern num,word                                                                 
  	.code
	.globl	main
main:
	jal	FileRead		# get the word list
	jal	initTopRankArray	# get topRank
	
	la	$a0,topRankArray
	li	$t0,0xFFFFFFFF
	sw	$t0,4($a0)
	la	$a0,prompt
	syscall	$print_string
	jal	ReadChar		# syscall $read_int
	mov	$a0,$v0
	syscall	$print_char
	addi	$v0,$v0,0-'0		# convert to digit
	sw	$v0,level($gp)		# save level	
	beqz	$v0,main		#
	sltiu	$t0,$v0,7		# check for out-of-range
	beqz	$t0,main		# try again 
	addi	$a0,$0,'\f		# clear the screen
	syscall	$print_char		# return v0
	jal	getMatrixSize		# getMatrixSize(int n : v0) return (x : s1 , y : s2)
	mul	$s3,$s2,$s1		# calculate N
	sw	$s3,num($gp)	
	jal	pair.init
	jal	Randomize
	mov	$a0,$s3
	jal	ChooseWords
	jal	mouseMap.clear
	la	$a0,deck
	mov	$a1,$s3
#	jal	Shuffle
	la	$s5,deck
	mov	$s4,$0			# working counters y
	mov	$s3,$0			#                  x	
2:	sll	$a0,$s3,2
	add	$a0,$a0,$s3		# x = 5 * s3
	sll	$a1,$s4,1
	add	$a1,$a1,$s4		# y = 3 * s4	
	lw	$a2,($s5)		# string of card
	mov	$a3,$0			# set face down
					# card.new(int x:a0, int y:a1, wordString w:a2, bool faceup:a3)
	jal	card.new		# return s0 as current pointer
	jal	card.draw
	
	sw	$s0,($s5)		# replace string with pointer
	jal	initMouseMap		# initMouseMap(int x : s3, int y : s4, card * ptr : s0)
		
	addi	$s5,$s5,word
	addi	$s3,$s3,1		
	bne	$s3,$s1,2b
	mov	$s3,$0
	addi	$s4,$s4,1
	bne	$s4,$s2,2b
	jal	initStateTable
	jal	initMouseFlag
	jal	button.draw
	jal	ClockStart
# ---------------------------------------------------------------------
	.data
	.align 2	
	.code	
# ---------------------------------------------------------------------
polling:
	la	$a0,mouse.flags
	addi	$a1,$0,1
3:	syscall	$IO_read
	andi	$t0,$v0,MOUSEUP
	beqz	$t0,3b	      
	addi	$a0,$a0,mouse.up-mouse.flags                                                                        
	addi	$a1,$0,4
	syscall	$IO_read
	andi	$a0,$v0,0xffff		# split into x, y
	div	$a0,$a0,5		# divide x by card width
	srl	$a1,$v0,16
	div	$a1,$a1,3		# divide y by card height
	sll	$a1,$a1,4
	add	$a0,$a0,$a1
					# a0 = y * 16 + x
	addi	$t0,$0,128		# new button
	addi	$t1,$0,129		# exit button
	beq	$a0,$t0,main
	beq	$a0,$t1,exitGame
	sll	$a0,$a0,2				
	la	$a1,mouseMap		# s0 = mouseMap(y * 16 + x)
	add	$a0,$a0,$a1
	lw	$s0,($a0)
	beqz	$s0,polling
	
	jal	card.click
	jal	track.draw
	jal	pair.checkWin
	beqz	$v0,polling
	addi	$a0,$0,0
	addi	$a1,$0,1
	syscall	$xy
confirmExit:
	la	$a0,confirmExitPrompt
	syscall	$print_string
	jal	ReadChar
	bne	$v0,'x,main
exitGame:
	jal	gameOver.deleteAllCards	# free heap
	jal	writeTopRankToFile
	addi	$a0,$0,'\f		# clear the screen
	syscall	$print_char
	la	$a0,exit
	syscall	$print_string
	syscall	$exit	
# ---------------------------------------------------------------------
	.data
newButton:	.asciiz	"<New>"
exitButton:	.asciiz "<Ext>"
	.code	
button.draw:
	addi	$sp,-8
	lw	$a0,($sp)
	lw	$a1,4($sp)
	
	addi	$a0,$0,0
	addi	$a1,$0,24
	syscall	$xy
	la	$a0,newButton
	syscall	$print_string
	
	addi	$a0,$0,5
	addi	$a1,$0,24
	syscall	$xy
	la	$a0,exitButton
	syscall	$print_string
	
	sw	$a0,($sp)
	sw	$a1,4($sp)
	addi	$sp,8
	jr	$ra
##################################################################################################
	.data
pairNumLeft:	.asciiz	"pairs#:"
turnsNum:		.asciiz	"turns#:"
	.code
track.draw:
	addi	$sp,-8
	lw	$a0,($sp)
	lw	$a1,4($sp)
	addi	$a0,$0,10
	addi	$a1,$0,24
	syscall	$xy
	la	$a0,turnsNum
	syscall	$print_string
	lw	$a0,turns($gp)
	syscall	$print_int
	
	addi	$a0,$0,22
	addi	$a1,$0,24
	syscall	$xy
	la	$a0,pairNumLeft
	syscall	$print_string
	lw	$a0,pairNum($gp)
	syscall	$print_int
	sw	$a0,($sp)
	sw	$a1,4($sp)
	addi	$sp,8
	jr	$ra	
##################################################################################################
#####################################################################################
#------------------------------------------------------------------------------------
	.data
	.extern time,word	
minStr:	.asciiz	"sec:"
	.code
ClockStart:
	xori	$a0,$0,40
	xori	$a1,$0,24
	syscall	$xy
	la	$a0,minStr
	syscall	$print_string
	sw	$0,time($gp)	# init the clock ?
	la	$a0,timer.t7	# timer 7 address
	addi	$a1,$0,4	# the size of timer 4 bytes = 1 word
	addi	$a2,$0,1000	# data
	syscall	$IO_write	# init timer 7 for 1 sec.
	la	$a0,timer.t6	# timer 6
	addi	$a1,$0,4
	addi	$a2,$0,2000
	syscall	$IO_write
	la	$a0,timer.service
	ori	$a1,$0,timer.int# ?
	syscall	$callback	# register callback function
	
	ori	$a2,$0,0xC0	# mask bit for timer 7 and timer 6
	ori	$a1,$0,1	# byte sized
	la	$a0,timer.mask
	syscall	$IO_write	# enable interrupt for timer 7 and timer 6 only!
	jr	$ra
#------------------------------------------------------------------------------------
# Interrupt service function
timer.service:
	addi	$sp,$sp,-24
	sw	$at,0($sp)
	sw	$a0,4($sp)
	sw	$a1,8($sp)
	sw	$a2,12($sp)
	sw	$a3,16($sp)
	sw	$v0,20($sp)
	la	$a0,timer.flags
	addi	$a1,$0,1	# one byte
	syscall	$IO_read	# get the flags
	#--------------- check which timer interrupt--------------
	andi	$a3,$v0,0x80	# check for t7
	beqz	$a3,NOT_t7	# other interrupt
	addi	$a0,$a0,4*7	# timer.t7
	syscall	$IO_read	# clear the flag
	lw	$a2,time($gp)
	addi	$a2,1
	sw	$a2,time($gp)
				
	la	$a0,console.char# save cursor
	addi	$a1,$0,4
	syscall	$IO_read
	mov	$a3,$v0	
	
	addi	$a0,$0,45	
	addi	$a1,$0,24
	syscall	$xy
	mov	$a0,$a2
	syscall	$print_int	
	srl	$a0,$a3,8	# recover cursor
	andi	$a0,$a0,0xff
	srl	$a1,$a3,16
	andi	$a1,$a1,0xff
	syscall	$xy
1:	lw	$at,0($sp)
	lw	$a0,4($sp)
	lw	$a1,8($sp)
	lw	$a2,12($sp)
	lw	$a3,16($sp)
	lw	$v0,20($sp)
	addi	$sp,$sp,16
	jr	$ra
NOT_t7:	# timer 6 service
	addi	$a0,$a0,4*6	# timer.t6
	syscall	$IO_read	# clear the flag
	jal	card.click	# click
	b	1b
