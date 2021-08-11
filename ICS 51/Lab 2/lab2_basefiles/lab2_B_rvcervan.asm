# Raul Cervantes
# rvcervan

.data
posZero_string: .asciiz "FP Value is +0.0\n"
negZero_string: .asciiz "FP Value is -0.0\n"
negInf_string: .asciiz "FP Value is -Inf\n"
posInf_string: .asciiz "FP Value is +Inf\n"
NAN_string: .asciiz "Value is NaN\n"

.text
isFPspecial:

	#arguments:
	# $a0 is value
	
	beq $a0, $0, fail1
	
	li $t1, 0x80000000
	beq $a0, $t1, fail2
	
	li $t1, 0x7F800000
	beq $a0, $t1, fail3
	
	li $t1, 0xFF800000
	beq $a0, $t1, fail4
	
	#default
	li $t2, 0x7F800000
	and $t1, $a0, $t2
	beq $t1, $t2, check2
	j else
check2:
	bgtz $t1, default
	j else

default:
	li $v0, 4
	la $a0, NAN_string
	syscall
	j special
	
else:
	li $v0, 0
	j EndFunc
	
fail1:
	li $v0, 4
	la $a0, posZero_string
	syscall
	j special
	
fail2:
	li $v0, 4
	la $a0, negZero_string
	syscall
	j special

fail3:
	li $v0, 4
	la $a0, posInf_string
	syscall
	j special
	
fail4:
	li $v0, 4
	la $a0, negInf_string
	syscall
	j special
	


special:
	li $v0, 1

EndFunc:

	# replace this line - included to run main
#	li $v0, -1111

	jr $ra

