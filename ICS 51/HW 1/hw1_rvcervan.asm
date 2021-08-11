# Homework 1
# Name: Raul Cervantes (e.g., John Doe)
# Net ID: rvcervan (e.g., jdoe)
.globl main

.data
str_prompt: .asciiz "Enter a ASCII string (max 8 characters): "
int_prompt: .asciiz "Enter an integer in range +/- 2^16: "
int_badinput: .asciiz "Bad Input!\n"
.align 2
inputString:   # additional label refering to the same address as 1stChar
Char1: .space 1
Char2: .space 1
Char3: .space 1
Char4: .space 1
Char5: .space 1
Char6: .space 1
Char7: .space 1
Char8: .space 1
forNewline: .space 1
forNull: .space 1

.text

main:
	#Part 1: User String Transformations
	#display prompt
	li $v0, 4
	la $a0, str_prompt
	syscall
	#user input
	li $v0, 8
	la $a0, inputString
	li $a1, 10
	syscall
	#print input
	li $v0, 4
	syscall
	
	#Part 1A: Transformation #1
	#Change case of first char to lower
	la $t0, Char1
	lb $t1, 0($t0)
	addi $t1, $t1, 32
	sb $t1, 0($t0)
	#Change case of last char to upper
	la $t0, Char8
	lb $t1, 0($t0)
	li $t3, 32
	sub $t1, $t1, $t3
	sb $t1, 0($t0)
	syscall
	#print ascii to other value
	la $t0, Char1
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 37
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	move $a0, $t0
	li $v0, 34
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	move $a0, $t0
	li $v0, 35
	syscall
	#prints newline
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall
	#Same as above but with Char5
	la $t0, Char5
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 37
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	move $a0, $t0
	li $v0, 34
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	move $a0, $t0
	li $v0, 35
	syscall
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall
	
	#Part 1B: Transformation #2
	#swap chars
	la $t0, Char1
	lb $t1, 0($t0)
	la $t2, Char5
	lb $t3, 0($t2)
	
	sb $t3, 0($t0)
	sb $t1, 0($t2)
	
	la $t0, Char2
	lb $t1, 0($t0)
	la $t2, Char6
	lb $t3, 0($t2)
	
	sb $t3, 0($t0)
	sb $t1, 0($t2)
	
	la $t0, Char3
	lb $t1, 0($t0)
	la $t2, Char7
	lb $t3, 0($t2)
	
	sb $t3, 0($t0)
	sb $t1, 0($t2)
	
	la $t0, Char4
	lb $t1, 0($t0)
	la $t2, Char8
	lb $t3, 0($t2)
	
	sb $t3, 0($t0)
	sb $t1, 0($t2)
	
	li $v0, 4
	la $a0, inputString
	syscall
	#print out remaining letters
	#z is 122
	#Z is 90
	li $v0, 11
	la $t0, Char1
	lb $t1, 0($t0)
	move $a0, $t1
	syscall
	addi $t2, $0, 122
	addi $t3, $0, 90
loop:
	beq $t1, $t2, done
	beq $t1, $t3, done
	addi $t1, $t1, 1
	move $a0, $t1
	syscall
	j loop
	
done:
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall
	#Part 2: User Integer Transformations
num_loop:
	li $v0, 4
	la $a0, int_prompt
	syscall
	#user input
	li $v0, 5
	syscall
	li $t0, -65537 #lower bound
	li $t1, 65537 #upper bound
	bge $v0, $t1, error
	ble $v0, $t0, error
	j cont
error:
	li $v0, 4
	la $a0, int_badinput
	syscall
	j num_loop
	
cont:
	move $t2, $v0 #int $t2
	move $t3, $v0 #binary $t3
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	#binary
	li $v0, 35
	move $a0, $t3
	syscall
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall
	#Part2A: Transformation #1
	#check if number is < 0, convert to 1's complement
	bge $t2, $0, skip
	#check goes here
	#
	li $t4, 1
	sub $t5, $t2, $t4 #$t2 has been changed to 1's complement, add 1 to change it to 2's
	li $v0, 1
	move $a0, $t5
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	sub $t6, $t3, $t4 #$t3 has been changed to 1's complement, add 1 to change it to 2's
	li $v0, 35
	move $a0, $t6
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	li $v0, 38
	move $a0, $t6
	syscall
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall
	j keep_going
skip:
	move $t5, $t2
	move $t4, $t3
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	li $v0, 35
	move $t6, $t3
	move $a0, $t3
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	li $v0, 38
	move $a0, $t2
	syscall
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall

keep_going:


	#Part 2B: Transformation #2
	li $v0, 39
	move $a0, $t2
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	bge $t2, $0, skip_2
	li $v0, 35
	nor $t4, $t6, $0 #flip all bits
	li $t0, 0x80000000
	xor $t4, $t4, $t0 #flip most significant bit $t4 is signed mag
	move $a0, $t4
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	li $v0, 38
	move $a0, $t6
	syscall
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall
	j more_cont
skip_2:

	li $v0, 35
	move $a0, $t6
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall
	li $v0, 38
	move $a0, $t6
	syscall
	la $t0, forNewline
	lw $t0, 0($t0)
	move $a0, $t0
	li $v0, 11
	syscall
more_cont:
	#Part 3: Exploring Representations
	xor $t0, $t2, $t5
	li $v0, 35
	move $a0, $t0
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall

	
	#count ones
	li $s1, 0 #counter
	li $t1, 1 #position
	li $t7, 0 #int i variable
	li $t8, 32
loop_ones:
	bge $t7, $t8, fin
	and $s2, $t0, $t1 #$s2 = bit
	
	beqz $s2, end_if
		addi $s1, $s1, 1 # counter++
	
end_if:
	sll $t1, $t1, 1 #00001 -> 00010 -> 00100
	addi $t7, $t7, 1 #i++
	j loop_ones	
fin:
	li $v0, 1
	move $a0, $s1
	syscall
	la $t9, forNewline
	lw $t9, 0($t9)
	move $a0, $t9
	li $v0, 11
	syscall
	
	xor $t0, $t2, $t4
	li $v0, 35
	move $a0, $t0
	syscall
	li $v0, 11 #space
	li $a0, 32
	syscall

	
	#count ones
	li $s1, 0 #counter
	li $t1, 1 #position
	li $t7, 0 #int i variable
	li $t8, 32
loop_ones2:
	bge $t7, $t8, fin2
	and $s2, $t0, $t1 #$s2 = bit
	
	beqz $s2, end_if2
		addi $s1, $s1, 1 # counter++
	
end_if2:
	sll $t1, $t1, 1 #00001 -> 00010 -> 00100
	addi $t7, $t7, 1 #i++
	j loop_ones2	
fin2:
	li $v0, 1
	move $a0, $s1
	syscall
	
	la $t9, forNewline
	lw $t9, 0($t9)
	move $a0, $t9
	li $v0, 11
	syscall
	

	li $v0, 10
	syscall

