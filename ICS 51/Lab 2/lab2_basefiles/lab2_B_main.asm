.include "lab2_B_rvcervan.asm"  # Change this to your file

.data
value: .word  0x11ABC000   # Modify this value to test different cases
notSpecial_string: .asciiz "Value is Not Special\n"

.globl main
.text
main:

	la $t0, value
	lw $t0, 0($t0)

	move $a0, $t0
	li $v0, 34
	syscall
	
	li $a0, ' '
	li $v0, 11
	syscall

	move $a0, $t0
	li $v0, 35
	syscall

	li $a0, ' '
	li $v0, 11
	syscall

	move $a0, $t0
	li $v0, 1
	syscall

	li $a0, '\n'
	li $v0, 11
	syscall

	move $a0, $t0	
	jal isFPspecial

	bnez $v0, main_done

	la $a0, notSpecial_string
	li $v0, 4
	syscall

main_done:
	li $v0, 10
	syscall
