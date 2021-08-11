# Raul Cervantes
# rvcervan

.data
range_Error: .asciiz "a value out of range for excess-"
k_Error: .asciiz "an invalid value. k value must be positive."
bits_Error: .asciiz "an invalid value. bits value must be between [1,31]."
space: .asciiz "\n"

.text
excess2dec:

	# 3 Arguments
	# $a0: int excessValue
	# $a1: int k
	# $a2: int bits
	# $v1: return register
	
	#condition 1: if true continue else jump
	bge $a1, $0, valid1
	#if block
	li $v0, 4
	la $a0, k_Error
	syscall

	li $v0, 0x10000000
	j func1_done
	
valid1:
	#condition 2: if true continue else jump. Also, it should be || (or), not && (and).
	li $t0, 31
	ble $a2, $0, falsebit
	bgt $a2, $t0, falsebit
	j valid2
falsebit:	
	li $v0, 4
	la $a0, bits_Error
	syscall

	li $v0, 0x10000000
	j func1_done

valid2:
	#condition 3: if true continue else jump
	li $t2, 2 # 2 power
	li $t3, 0 # counter
	li $t4, 2 # previous total
	li $t1, 0 # total
power:
	bge $t3, $a2, cont
	mult $t4, $t2
	mflo $t7
	add $t1, $t1, $t7
	addi $t3, $t3, 1
	j power 
	
cont:
	li $t6, 1
	sub $t1, $t1, $t6
	
	# $t1 = (2^bits)-1
	blt $a0, $0, falseExcess
	bgt $a0, $t1, falseExcess
	j valid3
	
falseExcess:

	li $v0, 4
	la $a0, range_Error
	syscall
	li $v0, 1
	move $a0, $a1
	syscall

	li $v0, 0x10000000
	j func1_done

valid3:
	#return statement
	move $t1, $a0
	move $t2, $a1
	sub $t1, $t1, $t2
	move $v0, $t1
func1_done:
	
	# replace this line - included to run main
#	li $v0, -1111

	jr $ra









