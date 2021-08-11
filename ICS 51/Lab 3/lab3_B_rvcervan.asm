# Raul Cervantes
# rvcervan

.data

odd_str: .asciiz " are odd numbers.\n"
pow2_str: .asciiz " are power of 2 numbers.\n"
mul8_str: .asciiz " are multiples of 8.\n"
special_str: .asciiz " are special numbers.\n"
min_str: .asciiz "The minimum value is: "
max_str: .asciiz "The maximum value is: "
ave_str: .asciiz "The integer average of the values is: "

.text

myStats:
	addi $sp, $sp, -48
	sw $ra, 0($sp)
	sw $a0, 4($sp) #int array (numbers)
	sw $a1, 8($sp) #int (totalNumbers)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)
	
	#using s registers here, don't know if I need to save these on the stack.
	li $s0, 0 #total_odd
	li $s1, 0 #total_pow2
	li $s2, 0 #total_isMul8
	li $s3, 0 #total_special
	li $s4, 0 #average
	li $s5, 0 #max
	li $s6, 0x7FFFFFFF #min
	
	li $t6, 0 #counter for loop
	
	
	li $s7, 0 #counter for traversing the array
loopy:
	bge $t6, $a1, exit_loop 
	sw $t6, 44($sp)
	
	lw $a0, 4($sp)
	add $a0, $a0, $s7
	lb $t0, 0($a0) #t0, is num
	move $a0, $t0
	jal simpleStats
	add $s0, $s0, $v0 #breakpoint here
	add $s1, $s1, $v1
	
	lw $a0, 4($sp)
	add $a0, $a0, $s7
	lb $t0, 0($a0)
	move $a0, $t0
	jal isSpecial
	
	add $s3, $s3, $v0
	
	lw $a0, 4($sp)
	add $a0, $a0, $s7
	lw $t0, 0($a0)
	
	li $t3, 8
	div $t0, $t3
	mfhi $t4
	#total_isMul8 += isMul8(num);
	beqz $t4, is_mul8
resume:
	
	add $s4, $s4, $t0 #average += num;
	
	bgt $t0, $s5, max_is_num
hop:	
	blt $t0, $s6, min_is_num

	j cont
	
max_is_num:
	move $s5, $t0
	j hop
min_is_num:
	move $s6, $t0
	j cont

cont:
	lw $t6, 44($sp)
	addi $t6, $t6, 1
	addi $s7, $s7, 4	
	j loopy
	
	
exit_loop:
	lw $s7, 8($sp)	#breakpoint here
	la $a0, odd_str
	move $a1, $s0
	move $a2, $s7
	jal printStat
	
	la $a0, pow2_str
	move $a1, $s1
	move $a2, $s7
	jal printStat
	
	la $a0, mul8_str
	move $a1, $s2
	move $a2, $s7
	jal printStat
	
	la $a0, special_str
	move $a1, $s3
	move $a2, $s7
	jal printStat
	
	li $v0, 4
	la $a0, min_str
	syscall
	li $v0, 1
	move $a0, $s6
	syscall
	
	li $v0, 11
	li $a0, 10 #newline
 	syscall
 	
	li $v0, 4
	la $a0, max_str
	syscall
	li $v0, 1
	move $a0, $s5
	syscall	
	
	li $v0, 11
	li $a0, 10 #newline
 	syscall
	
	div $s4, $s7
	mflo $t0
	li $v0, 4
	la $a0, ave_str
	syscall
	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 11
	li $a0, 10 #newline
 	syscall
	
	lw $ra, 0($sp)
	lw $a0, 4($sp) #int array (numbers)
	lw $a1, 8($sp) #int (totalNumbers)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	lw $s5, 32($sp)
	lw $s6, 36($sp)
	lw $s7, 40($sp)
	addi $sp, $sp, 48


    	jr $ra
is_mul8:
	
	addi $s2, $s2, 1
	j resume
