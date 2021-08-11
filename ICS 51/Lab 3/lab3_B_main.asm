.include "lab3_A_rvcervan.asm"
.include "lab3_B_rvcervan.asm"
.include "lab3_functions.asm"

.data
numCount: .word 4
myNumbers: .word 1,16,5,2

.text
.globl main

main:

	la $a0, myNumbers
	la $t0, numCount
	lw $a1, 0($t0)
	jal myStats

	li $v0, 10
	syscall

