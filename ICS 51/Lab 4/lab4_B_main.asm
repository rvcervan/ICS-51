.include "lab4_B_rvcervan.asm"

.globl main
.text
main:

	la $a0, myarray
	la $a1, numRows
	lw $a1, 0($a1)
	la $a2, numCols
	lw $a2, 0($a2)
	la $a3, myr1
	lw $a3, 0($a3)
	la $t0, myc1
	lw $t0, 0($t0)
	la $t1, myr2
	lw $t1, 0($t1)
	la $t2, myc2
	lw $t2, 0($t2)
	addi $sp, $sp, -12
	sw $t0, 8($sp)
	sw $t1, 4($sp)
	sw $t2, 0($sp)
	jal swapValue  

    # print the array as a string to find the position that was overwritten (when does it stop???)
    la $a0, myarray
    li $v0, 4
    syscall

	li $v0, 10
	syscall

.data  
# only 1st 20 letters are possible indexes, if get to numbers out of array bounds
myarray: .asciiz "abcdefghijklmnopqrst123456789" 

#set to [2][10], try [4][5], [5][4], [4][4], [2][4]
# or any combination of row*cols less than 20 for the given array
numRows: .word 5
numCols: .word 4

myr1: .word 2  
myc1: .word 1
myr2: .word 3
myc2: .word 0
