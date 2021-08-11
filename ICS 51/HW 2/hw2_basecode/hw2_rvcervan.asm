 # Homework 2
# Name: Raul Cervantes
# Net ID: rvcervan

.text

########################
#   Part 1 Functions
########################

toLower:    
	move $t0, $a0
	
	#iterate through the string
	#if letter ascii is > 64 and < 91 then add 32, then plus 1 to alphabet counter
	#else, skip char and add 1 to non alphabet counter.
	li $t1, 0 # Alphabet counter
	li $t2, 0 # non Alphabet counter
	li $t3, 0 # null terminating character
	li $t5, 64 #lower bound ascii
	li $t6, 91 #upper bound ascii
	li $t7, 123
	li $t4, 96
	
loop:
	lb $a0, 0($t0)
	beq $a0, $t3, done_1A
	ble $a0, $t5, non_alpha
	bge $a0, $t6, check
	addi $a0, $a0, 32
	sb $a0, 0($t0)
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j loop
check:
	bge $a0, $t7, non_alpha
	ble $a0, $t4, non_alpha
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j loop
	
non_alpha:
	
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j loop
		 
done_1A: 
	move $v0, $t1
	move $v1, $t2
	move $a0, $t0
	

    jr $ra

copyLetters:    	
	# $a0, source string
	# $a1, destination string
	# $a2, max length to copy
	
	move $t8, $a2
	addi $t8, $t8, -1
	li $t1, 0 # Alphabet counter
	# $t2, temp byte
	li $t3, 0 # null terminating character
	li $t5, 64 #lower bound ascii for Cap letter
	li $t6, 91 #upper bound ascii for Cap letter
	li $t7, 123 #upper bound ascii for lower letter
	li $t4, 96 #lower bound ascii for lower letter
	li $t9, 0
	move $t0, $a0
	lb $t2, 0($a0)
	beqz $t2, set_neg
loop2:
	lb $t2, 0($t0)
	beq $t2, $t3, done_1B
	beq $t1, $t8, done_1B
	# if it fails these 2 checks, letter is capital
	ble $t2, $t5, non_alpha2
	bge $t2, $t6, check2
	sb $t2, 0($a1)
	addi $a1, $a1, 1
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j loop2
check2:
	#if it fails these 2, letter is lower case
	bge $t2, $t7, non_alpha2
	ble $t2, $t4, non_alpha2
	sb $t2, 0($a1)
	addi $a1, $a1, 1
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j loop2
	
non_alpha2:
	addi $t9, $t9, 1
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j loop2
set_neg:
	li $t5, 1
	bge $t9, $t5, cont
	bgt $t1, $0, cont
	li $t1, -1
	j cont
done_1B:
	sb $t3, 0($a1)
	beq $t2, $t3, set_neg
cont:
	move $v0, $t1

    jr $ra


insertionSort:
	
	#$a0 is arg
	move $a1, $a0 #srings orginal state starting at index 0
	lb $t0, 0($a0)
	beq $t0, $0, done_1C
	
	li $t1, 1 #i
	add $a0, $a0, $t1
	lb $t3, 0($a0) #key
	
while:
	beq $t3, $0, done_1C
	addi $t2, $t1, -1 #j
	
while2:
	bge $t2, $0, check2more
check2more:
	move $a0, $a1
	add $a0, $a0, $t2 #go to index j from zero
	lb $t0, 0($a0)
	bgt $t0, $t3, continue2
	j continue

continue2:
	move $t4, $t0 #temp to hold j
	addi $a0, $a0, 1
	sb $t4, 0($a0)
	addi $t2, $t2, -1
	j while2
continue:
	addi $t2, $t2, 1
	move $a0, $a1 #reset to zero index
	add $a0, $a0, $t2
	sb $t3, 0($a0)
	
	addi $t1, $t1, 1
	move $a0, $a1
	add $a0, $a0, $t1
	lb $t3, 0($a0)
	j while
	
done_1C:
    jr $ra


########################
#   Part 2 Functions
########################

letterCount:
	#a0, str array 
	#a1 dest Array to hold counter
	move $t0, $a0 #string index 0 state
	move $t1, $a1 #dest index 0 state.
	
	#check if letter is lower case by checking ascii bounds
	#check if letter ascii is less then the second letters ascii for sortedness
	#return -1 if any of above conditions fail.
	# 97 = a, 122 = z
	li $t4, 97
	li $t5, 122
	

	li $t7, 0 #counter
loopy:
	#check 1
	lb $t3, 0($a0)
	beq $t3, $0, doneso
	blt $t3, $t4, fail
	bgt $t3, $t5, fail
	
	#check 2
	lb $t6, 1($a0)
	beq $t6, $0, continues
	bgt $t3, $t6, fail
continues:
	#inc counter in dest by one
	#if char is same, dont increment dest index.
	bne $t0, $a0, second_char_and_beyond
	lb $t8, 0($a1)
	sub $t8, $t8, $t8
	addi $t8, $t8, 1
	sb $t8, 0($a1)
	addi $a0, $a0, 1
	addi $t7, $t7, 1
	j loopy
	
second_char_and_beyond:
	lb $t8, 0($a0) # current char
	addi $a0, $a0, -1 
	lb $t9, 0($a0) # char before
	#check if current is same as char before
	beq $t8, $t9, dont_inc #don't inc string counter if same
	addi $a1, $a1, 4
	lb $t8, 0($a1)
	sub $t8, $t8, $t8
	addi $t8, $t8, 1
	sb $t8, 0($a1)
	addi $a0, $a0, 2
	addi $t7, $t7, 1
	
	j loopy
	
dont_inc:
	lb $t8, 0($a1)
	addi $t8, $t8, 1
	sb $t8, 0($a1)
	addi $a0, $a0, 2
	
	j loopy
	
fail:
	li $v0, -1
	jr $ra

doneso:
	move $v0, $t7
    jr $ra

compareLetterCount:
	#$a0 array1
	#$a2 array1 length
	
	#$a1 array2
	#$a3 array2 length
	
	#checks if length is same or < 0
	bne $a2, $a3, bad
	blt $a2, $0, bad
	blt $a3, $0, bad
	
	li $t0, 0 #array1 current index
	li $t1, 0 #array2 current index
	
	li $t4, 97
	li $t5, 122
	li $t2, 65
	li $t3, 90
	
	li $s3, 0
	
	lb $t6, 0($a0)
	
	bge $t6, $t2, another_check
	j looptyloop
another_check:
	ble $t6, $t5, letters

letters:
	li $s3, 1 #flag indicating that array is chars

looptyloop:
	beq $t0, $a2, finish
	lb $t2, 0($a0)
	lb $t3, 0($a1)
	
	blt $t2, $0, bad
	blt $t3, $0, bad
	
	beq $t2, $t3, good
	bne $t2, $t3, different
	j finish #not sure what to put on this line
bad:
	#return (-1, -1)
	li $v0, -1
	li $v1, -1
	jr $ra
good:
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	
	bnez, $s3, inc_by_1
	j inc_by_4
inc_by_1:
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j looptyloop
inc_by_4:	
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	j looptyloop

different:
	li $v0, -1
	move $v1, $t0
	jr $ra
finish:
	move $v0, $0
	move $v1, $0

    jr $ra

createProjection:
	#$a0, src string
	#store used letters in $a1 array
	#a = 97, z = 122
	#A = 65, Z = 90
	li $t5, 0 #result
	#$t7 reserved for previous char holder
	
lopsy:	
	li $t0, 97
	li $t1, 122
	li $t2, 65
	li $t3, 90
	lb $t4, 0($a0)
	beq $t4, $0, fin
	#check if capital or lower case
	bge $t4, $t2, check5
	addi $a0, $a0, 1
	j lopsy
check5:
	ble $t4, $t3, Capital
	bge $t4, $t0, check3
check3:
	ble $t4, $t1, lower
	#if no checks pass, char is not a letter.
	addi $a0, $a0, 1
	j lopsy
	
lower:
	addi $t4, $t4, -97
	li $t8, 0 #counter to hold power loop
	li $t9, 1 #result of power
	li $t0, 2
	j power
	
Capital:
	addi $t4, $t4, -65
	#check bit by and the total and current values
	#if value returns 0, continue. Else skip.
	li $t8, 0 #counter to hold power loop
	li $t9, 1 #result of power
	li $t0, 2
	j power
	
same_from_before:
	addi $a0, $a0, 1
	j lopsy

first_C:
	addi $t6, $t6, 1
	li $t8, 0 #counter to hold power loop
	li $t9, 1 #result of power
	li $t0, 2
	beqz $t4, power0
	j power
power:
	bge $t8, $t4, add_totalpower_to_result
	mult $t9, $t0
	mflo $t1
	move $t9, $t1
	addi $t8, $t8, 1
	j power
	
power0:
	move $t7, $t4 #holds previous char in alpha index
	addi $t5, $t5, 1
	
	addi $a0, $a0, 1
	j lopsy
	
add_totalpower_to_result:
#	move $t7, $t4 #holds previous char in alpha index
	#check if power total bit is 1 in result total
	and $t6, $t5, $t9
	bnez $t6, same_bit
	add $t5, $t5, $t9
	addi $a0, $a0, 1
	j lopsy

same_bit:
	addi $a0, $a0, 1
	j lopsy
fin:
	move $v0, $t5
    jr $ra

searchProjection:
	#a0 bProjection value
	#a1 N
	#first count bits and get value
	move $t0, $a0
	li $s1, 0 #counter
	li $t1, 1 #position
	li $t7, 0 #int i variable
	li $t8, 32
loop_ones:
	bge $t7, $t8, rest_of_the_program
	and $s2, $t0, $t1 #$s2 = bit
	
	beqz $s2, end_if
	addi $s1, $s1, 1 # counter++
	
end_if:
	sll $t1, $t1, 1 #00001 -> 00010 -> 00100
	addi $t7, $t7, 1 #i++
	j loop_ones	
rest_of_the_program:
	li $t0, 26
	#$s1 holds bit count
	blt $s1, $a1, bad_end
	ble $a1, $0, bad_end
	bgt $a1, $t0, bad_end
	
	li $t0, 0 #counter to hold power loop
	li $t1, 1 #result of power
	li $t2, 2
	beqz $a1, power0New
	j powerNew
powerNew:
	bge $t0, $a1, compare
	mult $t1, $t2
	mflo $t3
	move $t1, $t3
	addi $t0, $t0, 1
	j powerNew
power0New:
	addi $t1, $t1, 1
	j compare
compare:
	and $t5, $t1, $a0
	bnez $t5, bit_matches
	j bad_end
bad_end:
	li $v0, 255
	jr $ra
	#return int value 255
bit_matches:
	addi $t6, $a1, 97
	move $v0, $t6
    jr $ra
