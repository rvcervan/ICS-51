# Raul Cervantes
# rvcervan

.include "lab2_A_rvcervan.asm"  # Change this to your file
.include "lab2_B_rvcervan.asm"  # Change this to your file

.data
# Define  data items here

endl: .asciiz "\n"
specialCPart1: .asciiz "There were "
specialCPart2: .asciiz " special values\n"
input: .asciiz "Enter Value in Decimal: "
toBinary: .asciiz "Value in Binary is: "
negOne: .asciiz "Value is -1."
posOne: .asciiz "Value is +1."
powerC: .asciiz "*2^"
percentD: .asciiz "\n"

memory: .space 5
int: .word

.globl main
.text
main:

	li $s0, 0 #count
	li $s1, 0 #i
	li $s2, 5 # the five for the conditional in the loop
forLoop:
	bge $s1, $s2, end
	#input
	li $v0, 4
	la $a0, input
	syscall
	li $v0, 5
	syscall
	move $s3, $v0 #contains input number
	#print in decimal

	#print in binary
	li $v0, 4
	la $a0, toBinary
	syscall
	li $v0, 35
	move $a0, $s3
	syscall
	li $v0, 4
	la $a0, endl
	syscall
	#call isFPspecial function from lab2_B_rvcervan
	move $a0, $s3
	jal isFPspecial
	move $t0, $v0 #contains return value from function
	
	li $t1, 1
	beq $t0, $t1, increment_count
	j elseC
increment_count:
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j forLoop
elseC:
	blt $s3, $0, printLess
	li $v0, 4
	la $a0, posOne
	syscall
continue:
	li $t1, 0x007FFFFF
	and $t0, $s3, $t1
	li $v0, 35
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, powerC
	syscall
	
	li $t1, 0x7F800000
	and $t0, $s3, $t1
	srl $t0, $t0, 23
	move $a0, $t0
	li $a1, 127
	li $a2, 8
	jal excess2dec
	move $t1, $v0
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, percentD
	syscall
	
	addi $s1, $s1, 1
	j forLoop



printLess:
	li $v0, 4
	la $a0, negOne
	syscall
	j continue	
	
end:
	li $v0, 4
	la $a0, specialCPart1
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, specialCPart2
	syscall
	
	li $v0, 10
	syscall

