.include "hw3_rvcervan.asm"

.data
function_str: .asciiz "Function Returns: "
end_str: .asciiz "\n"

# First example in Doc
my_points: .word 0x00000000, 0x00020002, 0x00000002, 0x00020000
my_numPoints: .word 4
my_assignments: .byte 0,0,0,0

# Second example in Doc
#my_points: .word 0x00020002, 0x000C0001, 0x000D0006, 0x00050007, 0x00020007, 0x000E0008, 0x000A0009
#my_numPoints: .word 7
#my_assignments: .byte 2,2,2,2,2,1,0

.text
.globl main

main:

	li $a0, 0
	la $a1, my_points
	la $a2, my_numPoints
	lw $a2, 0($a2)
	la $a3, my_assignments

    jal updateCenter

    # save the return value
    move $t0, $v0 

    #print out the return values
    li $v0, 4
    la $a0, function_str
    syscall

	move $a0, $t0
	jal printCoord

    li $v0, 4
    la $a0, end_str
    syscall

    li $v0, 10
    syscall
