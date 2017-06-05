		.data
zero:		.float 0.0
one:		.float 1.0
two:		.float 2.0
four:		.float 4.0
neg:		.float -1.0
		.globl main
		.code

main:	
		li $t0,0 
		l.s $f0,neg
		l.s $f2,two
		l.s $f4,one
		l.s $f6,one
		l.s $f12,zero
		
lup: 			
		div.s $f10,$f4,$f6
		add.s $f12,$f12,$f10
		mul.s $f4,$f4,$f0
		add.s $f6,$f6,$f2
		addi $t0,$t0,1
loop:		
		blt $t0,500000,lup
		l.s $f8,four	
		mul.s $f12,$f12,$f8
		syscall $print_float
exit:	syscall $exit		