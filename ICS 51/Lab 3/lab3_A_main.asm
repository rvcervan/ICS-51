.include "lab3_A_rvcervan.asm"
.include "lab3_functions.asm"


.data
# example of special numbers 1,2,145
myNum: .word 145
valueis_str: .asciiz "Value: "
Special_str: .asciiz "\nThe number is Special!\n"
NotSpecial_str: .asciiz "\nThe number is not special.\n"

returns_str: .asciiz "Returns: "
.text
.globl main

main:
    li $v0, 4
	la $a0, valueis_str
	syscall
	
	la $a0, myNum
    lw $a0, 0($a0)

	li $v0, 1
	syscall	 

    jal isSpecial

    beqz $v0, main_notSpecial
    li $v0, 4
    la $a0, Special_str
    syscall
	j main_simpleStats
main_notSpecial:

    li $v0, 4
    la $a0, NotSpecial_str
    syscall


main_simpleStats:
    la $a0, myNum
    lw $a0, 0($a0)
    jal simpleStats
	move $t0, $v0
	move $t1, $v1

	li $v0, 4
	la $a0, returns_str
	syscall

	li $v0, 1
	move $a0, $t0
	syscall

	li $a0, ','
	li $v0, 11
	syscall

	li $v0, 1
	move $a0, $t1
	syscall

    li $v0, 10
    syscall

