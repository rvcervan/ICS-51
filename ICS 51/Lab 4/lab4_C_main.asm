.include "lab4_C_rvcervan.asm"
.include "lab4_functions.asm"

.globl main
.text
main:

	# print point
    la $a0, myPoints
    la $a1, myEntries
    lw $a1, 0($a1)
	jal printClusterPoints

	# Modify a point 
    la $a0, myPoints
    la $a1, myEntries
    lw $a1, 0($a1)
    li $a2, 3				# load the position to store the data into
    li $a3, 0x00FF0222		# coord to store

    li $t0, '2'             # cluster assignment
    addi $sp, $sp, -4		# pass the 5th argument
    sw $t0, 0($sp)
	jal updatePoint
	addi $sp, $sp, 4        # move the stack back!

    bgez $v0, success1
    la $a0, updatePointError
    li $v0, 4
    syscall

success1:
	la $a0, updatePointSuccess
	li $v0, 4
	syscall

	# print modified point
    la $a0, myPoints
    la $a1, myEntries
    lw $a1, 0($a1)
	jal printClusterPoints

	# Try to modify the List with an invalid position
    la $a0, myPoints
    la $a1, myEntries
    lw $a1, 0($a1)
    li $a2, 20				# load the position to store the data in the map
    li $a3, 0x00770022		# point to store

    li $t0, 'c'             # point assignment 
    addi $sp, $sp, -4		# pass the 5th argument
    sw $t0, 0($sp)
	jal updatePoint
	addi $sp, $sp, 4

    bgez $v0, success2
    la $a0, updatePointError
    li $v0, 4
    syscall
	j main_done
success2:
	# print point
    la $a0, myPoints
    la $a1, myEntries
    lw $a1, 0($a1)
	jal printClusterPoints

main_done:
	li $v0, 10
	syscall


.data
myEntries: .word 10
myPoints: .word 0xAABBCC63, 0x000B000B, 0x00000063, 0x00070001, 0x11111163, 0x00000004, 0x61616130, 0x000A0000, 0x10101031, 0x000B0003, 0x43415231, 0x0008000B, 0x7E7E7E30, 0x00050003, 0x7E7E7E32, 0x000C0007, 0x00000032, 0x000C0004, 0x44444431, 0x000A0000,
                -1, -1, -1, -1, -1, -1, -1, -1   # should never access these!
updatePointError: .asciiz "ERROR: Update entry returned error.\n"
updatePointSuccess: .asciiz "Success: Update entry succeeded.\n"
