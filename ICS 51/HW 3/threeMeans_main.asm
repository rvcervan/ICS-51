.include "hw3_rvcervan.asm"
.include "threeMeans_example4.asm"

.data
function_str: .asciiz "Function Returns: "
end_str: .asciiz "\n"

.text
.globl main

main:

	la $a0, my_centers
	la $a1, my_points
	la $a2, my_numPoints
	lw $a2, 0($a2)
	la $a3, my_assignments

    jal threeMeans

    # save the return value
    move $t0, $v0 

    #print out the return values
    li $v0, 4
    la $a0, function_str
    syscall

	li $v0, 1
	move $a0, $t0
	syscall

    li $v0, 4
    la $a0, end_str
    syscall

    li $v0, 10
    syscall
