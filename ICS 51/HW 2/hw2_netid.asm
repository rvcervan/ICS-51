# Homework 2
# Name: MY_FIRSTNAME MY_LASTNAME (e.g., John Doe)
# Net ID: MY_NET_ID (e.g., jdoe)

.text

########################
#   Part 1 Functions
########################

toLower:    
    # Remove these lines - included to assemble with provided mains
    li $v0, -99
    li $v1, -99

    jr $ra

copyLetters:    
    # Remove - included to assemble with provided mains
    li $v0, -99

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
	bge $t2, $0, check2
check2:
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
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	j looptyloop

different:
	li $v0, -1
	move $v1, $t0
	jr $ra
finish:
	

    jr $ra

createProjection:
	#$a0, src string
	#a = 97, z = 122
	#A = 65, Z = 90
	li $t0, 97
	li $t1, 122
	li $t2, 65
	li $t3, 90
	li $t5, 0 #result
	li $t6, 0 #0 if it is first char of string, 1 if is not
	#$t7 reserved for previous char holder
	
lopsy:	
	lb $t4, 0($a0)
	beq $t4, $0, fin
	#check if capital or lower case
	bge $t4, $t2, check2
check2:
	ble $t4, $t3, Capital
	bge $t4, $t0, check3
check3:
	ble $t4, $t1, lower
	#if no checks pass, char is not a letter.
	addi $a0, $a0, 1
	j lopsy
Capital:
	beqz $t6, first_C

first_C:
	addi $t4, $t4, -65
	move $t7, $t4 #holds previous char in alpha index
	li $t8, 0 #counter to hold power loop
	li $t9, 1 #result of power
	j power
power:
	beqz $t4, power0
	bgt $t8, $t4, add_totalpower_to_result
	mult 
	
power0:
	addi $t5, $t5, 1
	j lopsy
	
add_totalpower_to_result:
	add $t5, $t5, $t9
	j lopsy
	
fin:
	
    jr $ra

searchProjection:
    # Remove - included to assemble with provided mains
    li $v0, -99

    jr $ra
