# Raul Cervantes
# rvcervan

.globl main
.text
main:

	la $t0, num
	move $a0, $t0
	li $v0, 4
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 12
	syscall
	la $t2, num
	move $t6, $v0
	sb $v0,0($t2)
	
	li $v0, 4
	la $a0, endl
	syscall
	
	
	la $t2, num
	move $a0, $t2
	syscall # first print
	li $v0, 4
	la $a0, endl
	syscall # newline
	addi $t2, $t2, 2
	lb $t3,0($t2) # $t3 is register A
	addi $t3, $t3, 32
	sb $t3,0($t2)
	li $v0, 4
	la $t0, num
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	la $t0, num
	lw $t2, 0($t0) # $t2 is register B
	srl $t2, $t2, 8
	
	sll $t3, $t3, 24
	add $t5, $t3, $t2
	sw $t5, 0($t0)
	li $v0, 4
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	la $t0, num
	addi $t0, $t0, 4
	sb $zero, ($t0)
	li $v0, 4
	la $a0, num
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	la $t0, num 
	lw $t1, 0($t0) # $t0 is register A
	ror $t1, $t1, 4
	li $v0, 4
	la $a0, num
	syscall #step 11, don't know if did it right
	
	li $v0, 4
	la $a0, endl
	syscall
	
	sw $t1 ($t0)
	li $v0, 4
	la $a0, num
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	ror $t1, $t1, 4
	sw $t1, ($t0)
	li $v0, 4
	la $a0, num
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	li $v0, 4
	la $a0, myspace
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	la $t0, myspace
	lw $t2, 0($t0) # $t2 is register A
	add $t1, $t2, $t6
	sw $t1, 0($t0)
	li $v0, 4
	la $a0, myspace
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	addi $t1, $t1, 1
	la $t0, myspace
	addi $t0, $t0, 1
	sb $t1, 0($t0)
	li $v0, 4
	la $a0, myspace
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	
	li $v0, 10
	syscall

.data
prompt: .asciiz "Enter a lowercase letter: "
endl: .asciiz "\n"
.align 2
num: .word 0x44434241
myspace: .byte '#', 0x00, '@', '%' 
stop: .byte 0x00

