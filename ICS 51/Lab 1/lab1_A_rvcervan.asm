# Raul Cervantes
# rvcervan

.data
myNum: .word 0xA9876543
value: .word 100
endl: .asciiz "\n"   # a string

.globl main
.text
main:
	la $t0, myNum
	move $a0, $t0
	li $v0, 34
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	la $t1, myNum
	lw $t1, 0($t1)
	move $a0, $t1
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	andi $t2, $t1, 0x0FFFFFFF
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	addi $t4, $t0, 2
	lb $t3, ($t4)
	move $a0, $t3
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	addi $t5, $t0, 3
	lbu $t6, ($t5)
	move $a0, $t6
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	la $t1, value
	lw $t1, 0($t1)
	sll $t2, $t1, 1
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	srl $t3, $t2, 2
	move $a0, $t3
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	li $t1, 8
	ror $t1, $t1, 4
	move $a0, $t1
	li $v0, 35
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	sra $t4, $t1, 1
	move $a0, $t4
	li $v0, 35
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	srl $t5, $t1, 1
	move $a0, $t5
	li $v0, 35
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	li $v0, 10
	syscall
# Your code goes here


