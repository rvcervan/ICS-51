# This file purposely has minimal comments. 
# Learning to read and follow code written by others is a skill to additionally develop. 

.text

max:
    bge $a0, $a1, max_a
    move $v0, $a1  # b is max
    jr $ra
max_a: 
    move $v0, $a0  # a is max
    jr $ra



threeArgMin:
    ble	$a0, $a1, threeArgMin_atoc
    bgt $a1, $a2, threeArgMin_cmin
    li $v0, 1    # b is min
	move $v1, $a1
    jr $ra
threeArgMin_atoc:
    ble $a0, $a2, threeArgMin_Amin
threeArgMin_cmin:    
    li $v0, 2    # c is min
	move $v1, $a2
    jr $ra
threeArgMin_Amin:
    li $v0, 0     # a is min
	move $v1, $a0
    jr $ra



printByteArray:
    bgtz $a1, printByteArray_print
    jr $ra


printByteArray_print:
	move $t2, $a0

    li $v0, 11
    li $a0, 91
    syscall     

    lbu $a0, 0($t2) 
    li $v0, 1
    syscall

    li $t0, 1
printByteArray_loop:
    beq $t0, $a1, printByteArray_done

    li $v0, 11
    li $a0, 44
    syscall     

    li $v0, 11
    li $a0, 32
    syscall     


    add $t1, $t2, $t0
    lbu $a0, 0($t1) 
    li $v0, 1
    syscall

    addi $t0, $t0, 1
    j printByteArray_loop
printByteArray_done:

    li $v0, 11
    li $a0, 93
    syscall     

	li $v0, 11
	li $a0, '\n'
	syscall

    jr $ra



# Works on positive numbers only
# Will not modify string if invalid character found
itoa:
	move $t5, $sp 
	bltz $a0, itoa_error
	bnez $a0, itoa_number
	
	li $t0, 2
	blt $a2, $t0, itoa_error  
	li $t0, '0'
	sb $t0, 0($a1) 
	sb $0, 1($a1)  

	li $v0, 1   
	jr $ra
	
itoa_number:
	li $t7, 0   
	li $t4, 10
itoa_loop:
	beqz $a0, itoa_done
	
	div $a0, $t4    
	mfhi $t1        
	addi $t1, $t1, '0'  
	addi $sp, $sp, -1   
	sb $t1, 0($sp)      
	mflo $a0		  

	j itoa_loop

itoa_done:
	sub $t3, $t5, $sp  
	addi $t3, $t3, 1	  
	bgt $t3, $a2, itoa_error  

	beq $t5, $sp, itoa_finishcopy

	lb $t0, 0($sp)	   
	sb $t0, 0($a1)      
	addi $a1, $a1, 1	  
	addi $sp, $sp, 1	  
	addi $t7, $t7, 1	  
	j itoa_done

itoa_finishcopy:
    sb $0, 0($a1)       
	move $v0, $t7       
	jr $ra

itoa_error:
	move $sp, $t5
	li $v0, -1
	jr $ra
