# Raul Cervantes
# rvcervan

.text

#Determine if the value is a special number
#Return the 1 if the number is special, 0 otherwise
#A "Special Number" is a number where the sum of factorials of its digits is equal to the number itself.
isSpecial:
	#save $ra, $a0, $s1, $s2
	addi $sp, $sp, -16
	sw $s1, 12($sp)
	sw $s0, 8($sp)
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	li $s0, 0 #sum = 0
	move $s1, $a0 #value = num
isSpecial_loop:
	beq $s1, $zero, exit_isSpecial_loop #while (value != 0)
	
	#sum += factorial(value % 10);
	li $t2, 10
	div $s1, $t2
	mfhi $t3
	move $a0, $t3
	jal factorial
	add $s0, $s0, $v0
	
	#value = value / 10;
	li $t2, 10
	div $s1, $t2
	mflo $t4
	move $s1, $t4
	
	
	j isSpecial_loop
	
exit_isSpecial_loop:	
	#return (sum == num)
	#would I need to save $a0 on sp then restore it here to make comparison?
	lw $a0, 0($sp)
	beq $s0, $a0, yes
	li $v0, 0
	
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16
	jr $ra
	
yes:
	li $v0, 1
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16
	jr $ra
	

simpleStats:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	jal isOdd
	
	#lw $ra, 4($sp)
	#lw $a0, 0($sp)
	#addi $sp, $sp, 8
	
	#(num - 1)
	li $t0, 1
	sub $t1, $a0, $t0
	
	#(num & (num - 1))
	and $t2, $a0, $t1
	
	#(num & (num -1)) == 0)
	beqz $t2, second_is_zero
	li $v1, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
second_is_zero:
	
	beqz $a0, first_is_zero #num != 0	
	li $v1, 1
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
first_is_zero:
	
	li $v1, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
    	jr $ra





