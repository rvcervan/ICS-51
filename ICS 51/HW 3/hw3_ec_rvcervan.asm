# Raul Cervantes
# rvcervan

#.include "hw3_rvcervan.asm"

.data
filename: .asciiz "finalpoints.txt"
x_str: .asciiz "x=[\n"
bracket_str: .asciiz "]\n"

Buffer: .asciiz "01234567890123456789"
point: .word 0x00010015
assignment: .byte 2
commas: .word 1

asgnmnt: .byte 3

# Doc Example 1
# centers = [(11,11), (7,1), (0,4)]
my_centers: .word 0x000B000B, 0x00070001, 0x00000004
# point = [(10,0),(11,3),(8,11),(5,3),(12,7),(12,4),(10,0)]
my_points: .word 0x000A0000, 0x000B0003, 0x0008000B, 0x00050003, 0x000C0007, 0x000C0004, 0x000A0000
my_numPoints: .word 7
my_assignments: .byte 0,1,1,0,2,2,1

.text
#.globl main
#main:
#	la $a0, my_centers
#	la $a1, my_points
#	la $a2, my_numPoints
#	lw $a2, 0($a2)
#	la $a3, my_assignments

#	jal writePythontoFile

#	la $a0, Buffer
	
#	la $a1, point
#	lw $a1, 0($a1)
	
#	la $a2, assignment
#	lb $a2, 0($a2)
#	
#	la $a3, commas
#	lw $a3, 0($a3)
#	
#	jal stringCoord
#	move $a0, $v0
#	li $v0, 1
#	syscall

#	li $v0, 4
#	la $a0, Buffer
#	syscall	

#	li $v0, 10
#	syscall

	


stringCoord:
	#int stringCoord(char[20] buffer, coord point, byte assignment, int comma)
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp) #commas
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	sw $s2, 28($sp)

	li $s0, 0 #counter for str length

	li $t0, '['
	lw $t1, 4($sp)
	sb $t0, 0($t1)
	addi $s0, $s0, 1
	
	
	lw $t0, 8($sp)
	move $a0, $t0
	jal getCoord

	
	move $s1, $v0
	move $s2, $v1
	
	move $a0, $s1
	lw $a1, 4($sp)
	add $a1, $a1, $s0
	li $a2, 20
	
	jal itoa
	
	
	
	add $s0, $s0, $v0
	
	li $t0, ','
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	addi $s0, $s0, 1
	
	move $a0, $s2
	lw $t0, 4($sp)
	add $a1, $t0, $s0
	move $a2, $s0	

	jal itoa

	add $s0, $s0, $v0
	
	li $t0, ','
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	addi $s0, $s0, 1	
	
	lw $t0, 12($sp) 
	#lb $t0, 0($t0)
	move $a0, $t0
	lw $t0, 4($sp)
	add $a1, $t0, $s0
	move $a2, $s0
	
	jal itoa

	add $s0, $s0, $v0
	
	li $t0, ']'
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	addi $s0, $s0, 1
	
	#if comma == 0, no comma
	lw $t0, 16($sp)
	beqz $t0, no_comma
	
	li $t0, ','
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	addi $s0, $s0, 1
	
	li $t0, '\n'
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	addi $s0, $s0, 1

	li $t0, '\0'
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	
	j cont
	
no_comma:
	li $t0, '\n'
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	addi $s0, $s0, 1
	
	li $t0, '\0'
	lw $t1, 4($sp)
	add $t1, $t1, $s0
	sb $t0, 0($t1)
	
	j cont
	
cont:
	move $v0, $s0
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	lw $s2, 28($sp)

	addi $sp, $sp, 32
	jr $ra

writePythontoFile:
	#writePythonFile(coords[3] centers, coords[] points, int numPoints, byte[] assignments)
	#writes result of threeMeans() to file finalpoints.txt
	#centers and points will be outputted as a nested Python list.
	#each list is expressed as a list with 3 elements: [x,y,assignments]
	#centers are the first 3 elements of list with assignment 3.
	#points are then printed in order.
	
	#returns 0 on success, -1 on error
	#error: numPoints < 1, or any error associated with the file(opening, writing, etc).
	addi $sp, $sp, -32
	sw $ra, 0($sp) 
	sw $a0, 4($sp) #centers
	sw $a1, 8($sp) #points
	sw $a2, 12($sp) #numPoints
	sw $a3, 16($sp) #assignments
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	sw $s2, 28($sp)
	
	li $v0, -1
	ble $a2, $0, end
	
	
	li $v0, 13
	la $a0, filename
	li $a1, 9
	li $a2, 0
	syscall
	move $s0, $v0 #file descriptor
	
	li $v0, 15
	move $a0, $s0
	la $a1, x_str
	li $a2, 4
	syscall
	
	
	li $s1, 0 #counter for first loop
first_loop:
	li $t0, 3
	beq $s1, $t0, next_loop
	
	la $a0, Buffer
	
	lw $a1, 4($sp)
	move $t0, $s1
	sll $t0, $t0, 2
	add $t0, $t0, $a1
	lw $a1, 0($t0)
	
	la $a2, asgnmnt
	lb $a2, 0($a2)
	li $a3, 1
	
	jal stringCoord
	#modifies buffer
	#returns buffer length
	move $t0, $v0
	
	li $v0, 15
	move $a0, $s0
	la $a1, Buffer
	move $a2, $t0
	syscall
	
	addi $s1, $s1, 1
	j first_loop	
	
	
next_loop:

	li $s2, 0 #counter for second loop
second_loop:
	lw $t0, 12($sp)
	beq $s2, $t0, almost_done

	la $a0, Buffer
	
	lw $a1, 8($sp)
	move $t0, $s2
	sll $t0, $t0, 2
	add $t0, $t0, $a1
	lw $a1, 0($t0)
	
	lw $a2, 16($sp)
	move $t0, $s2
	add $a2, $t0, $a2
	
	lb $a2, 0($a2)
	
	lw $t0, 12($sp)
	addi $t0, $t0, -1
	beq $s2, $t0, zero_comma
	li $a3, 1
	j carry_on_then
	
zero_comma:
	li $a3, 0

carry_on_then:

	jal stringCoord
	move $t0, $v0
	
	li $v0, 15
	move $a0, $s0
	la $a1, Buffer
	move $a2, $t0
	syscall
	
	addi $s2, $s2, 1
	j second_loop

almost_done:

	li $v0, 15
	move $a0, $s0
	la $a1, bracket_str
	li $a2, 2
	syscall
	
	li $v0, 16
	move $a0, $s0

	#success
	li $v0, 0
end:	


	lw $ra, 0($sp) 
	lw $a0, 4($sp) #centers
	lw $a1, 8($sp) #points
	lw $a2, 12($sp) #numPoints
	lw $a3, 16($sp) #assignments
	lw $s0, 20($sp)
	lw $s1, 24($sp)	
	lw $s2, 28($sp)
	addi $sp, $sp, 32
	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
