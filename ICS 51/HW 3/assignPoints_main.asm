.include "hw3_netid.asm"

.data
function_str: .asciiz "Function Returns: "
end_str: .asciiz "\n"

# First example in Doc
#my_centers: .word 0x00010001, 0x00050005, 0x00090009
#my_points: .word 0x00010002, 0x00020001, 0x00050005, 0x00050006, 0x000A0009, 0x0009000A
#my_numPoints: .word 6
#my_assignments: .byte -1,-1,-1,-1,-1,-1

# Second example in Doc
my_centers: .word 0x000A000E, 0x000E000A, 0x000D0004
my_points: .word 0x00020002, 0x000C0001, 0x000D0006, 0x00050007, 0x00020007, 0x000E0008, 0x000A0009
my_numPoints: .word 7
my_assignments: .byte -1,-1,-1,-1,-1,-1,-1

.text
.globl main

main:

	la $a0, my_centers
	la $a1, my_points
	la $a2, my_numPoints
	lw $a2, 0($a2)
	la $a3, my_assignments

    jal assignPoints

    # save the return values
    move $t0, $v0 

    #print out the return values
    li $v0, 4
    la $a0, function_str
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, end_str
    syscall

	la $a0, my_assignments
	la $a1, my_numPoints
	lw $a1, 0($a1)
	jal printByteArray

    li $v0, 10
    syscall
