# Raul Cervantes
# rvcervan

.include "hw3_helpers.asm"

.data
knapSack1: .asciiz "knapSack( "
knapSack2: .asciiz "...)\n"
comma: .asciiz ", "

threeMeans1: .asciiz "------ Iteration "
threeMeans2: .asciiz " ------\n"
threeMeans3: .asciiz "New Sum: "
threeMeans4: .asciiz "Cluster "
threeMeans5: .asciiz " updated from "
threeMeans6: .asciiz " to "


.text
##############################
# PART 1 FUNCTIONS
##############################

knapSack:
	#int maxWeight: $a0
	#int[] weight: $a1
	#int[] value: $a2
	#int N: $a3
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	#printf("knapSack( %d, %d, ...)\n", maxWeight, N);
	li $v0, 4
	la $a0, knapSack1
	syscall
	
	lw $a0, 0($sp)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	li $v0, 1
	move $a0, $a3
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	li $v0, 4
	la $a0, knapSack2
	syscall
	
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	#Base Case
	#if(N == 0 || maxWeight == 0)
		#return 0;

	#bne $a3, $zero, Not_base
	#bne $a0, $zero, Not_base
	beqz $a3, Base
	beqz $a0, Base
	j Not_base

Base:	
	li $v0, 0
	jr $ra

Not_base:
	#save $ra, $a0, $a3(N-1), $s0(tempA), $s1(tempB), $a1
	addi $sp, $sp, -28
	sw $ra, 0($sp) 
	sw $a0, 4($sp) #weight
	sw $a3, 8($sp) #N
	sw $s0, 12($sp) #tempA
	sw $s1, 16($sp) #tempB
	sw $a1, 20($sp) #gets modified because I call max
	sw $a2, 24($sp)
	

	
	#if(weight[N-1] > maxWeight)
		#return knapSack(maxWeight, weight, value, N - 1);
	lw $t0, 8($sp)
	addi $t0, $t0, -1 #N-1
	sll $t0, $t0, 2
	add $t0, $t0, $a1
	lw $t0, 0($t0) #weight[N-1]
	
	bgt $t0, $a0, into_if
	#else
	
	addi $a3, $a3, -1 #N-1
	jal knapSack
	move $s1, $v0 #save tempB

	
	lw $t0, 8($sp)
	addi $t0, $t0, -1 #N-1
	sll $t0, $t0, 2
	add $t0, $t0, $a1
	lw $t0, 0($t0) #weight[N-1]
	
	sub $a0, $a0, $t0 #$a1, $a2, $a3 should be same.
	jal knapSack
	move $s0, $v0 #TempA without value[N-1]
	
	lw $t0, 8($sp)
	addi $t0, $t0, -1 #N-1
	sll $t0, $t0, 2
	add $t0, $t0, $a2
	lw $t0, 0($t0) #value[N-1]
	
	add $s0, $s0, $t0 #tempA = value[N-1] + knapSack(maxWeight - weight[N-1], weight, value, N-1)
	
	move $a0, $s0 #tempA
	move $a1, $s1 #tempB
	
	jal max #the return is already in $v0 so no need to modify it?
	
	lw $ra, 0($sp) 
	lw $a0, 4($sp) #weight
	lw $a3, 8($sp) #N-1
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $a1, 20($sp)
	lw $a2, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra
	
	
into_if:
	#return knapSack(maxWeight, weight, value, N-1);
	#maxWeight, weight, value are same. $a3: N-1 is not change since first save.
	addi $a3, $a3, -1 #N-1
	jal knapSack
	
	
	lw $ra, 0($sp) 
	lw $a0, 4($sp) #weight
	lw $a3, 8($sp) #N
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $a1, 20($sp)
	lw $a2, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra


##############################
# PART 2 FUNCTIONS
##############################
getCoord:
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	#shift right by 16 bits to get upper.
	srl $v0, $a0, 16 #x value
	
	li $t0, 65535
	beq $v0, $t0, eror
	
	#reload $a0
	lw $a0, 0($sp)
	
	#shift left 16 bits and then right 16 bits to get lower
	sll $v1 $a0, 16
	srl $v1, $v1, 16 #y value
	beq $v1, $t0, eror
	
	#v0 is x, v1 is y
	lw $a0, 0($sp)
	addi $sp, $sp, 4
    	jr $ra
    	
eror:
	li $v0, -1
	li $v1, -1
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

printCoord:
	#$a0 must have coor point so just jal
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	jal getCoord
	
	move $t0, $v0 #x
	move $t1, $v1 #y
	
	li $v0, 11
	li $a0, 40
	syscall #(
	
	li $v0, 1
	move $a0, $t0
	syscall #x
	
	li $v0, 11
	li $a0, 44
	syscall #,
	
	li $v0, 1
	move $a0, $t1
	syscall #y
	
	li $v0, 11
	li $a0, 41
	syscall #)
	
	
	
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra

manhattanDist:
	#int manhattanDist(coord point1, coord point2)
	#return |x1 - x2| + |y1 - y2|
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	
	jal getCoord
	move $s0, $v0 #x1
	move $s1, $v1 #y1
	
	move $a0, $a1
	jal getCoord
	move $s2, $v0 #x2
	move $s3, $v1 #y2
	
	#Math below
	
	sub $t0, $s0, $s2 # x1 - x2
	sub $t1, $s1, $s3 # y1 - y2
	
	#do absolute value of $t0 and $t1
	abs $t0, $t0
	abs $t1, $t1
	
	#add them together
	add $v0, $t0, $t1
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	addi $sp, $sp, 28

	jr $ra

assignPoints:
	#int assignPoints(coord[3] centers, coords[] points, int numPoints,
			  #byte[] assignments)
	#Must call threeArgMin() and manhattanDist()
	addi $sp, $sp, -40
	sw $ra, 0($sp)
	sw $a0, 4($sp) #centers
	sw $a1, 8($sp) #points
	sw $a2, 12($sp) #numPoints
	sw $a3, 16($sp) #assignments
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	sw $s2, 28($sp)
	sw $s3, 32($sp)
	sw $s4, 36($sp)
	
	li $s0, 0 #counter
	li $s1, 0 #sumd
for_loopy:
	beq $s0, $a2, out_loop
	#call manhattanDist 3 times
	
	li $t0, 0
	sll $t0, $t0, 2
	add $t0, $t0, $a0
	lw $a0, 0($t0) #centers[0]
	
	move $t1, $s0
	sll $t1, $t1, 2
	add $t1, $t1, $a1
	lw $a1, 0($t1) #points[i]
	
	jal manhattanDist
	move $s2, $v0
	
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
	li $t0, 1
	sll $t0, $t0, 2
	add $t0, $t0, $a0
	lw $a0, 0($t0) #centers[1]
	
	move $t1, $s0
	sll $t1, $t1, 2
	add $t1, $t1, $a1
	lw $a1, 0($t1) #points[i]
	
	jal manhattanDist
	move $s3, $v0
	
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
	li $t0, 2
	sll $t0, $t0, 2
	add $t0, $t0, $a0
	lw $a0, 0($t0) #centers[2]
	
	move $t1, $s0
	sll $t1, $t1, 2
	add $t1, $t1, $a1
	lw $a1, 0($t1) #points[i]
	
	jal manhattanDist
	move $s4, $v0
	
	move $a0, $s2
	move $a1, $s3
	move $a2, $s4
	
	jal threeArgMin
	
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	
	move $t1, $s0
	add $t1, $t1, $a3
	sb $v0, 0($t1) #assignments[i]
	
	add $s1, $s1, $v1 #sumd += min
	
	addi $s0, $s0, 1
	
	j for_loopy
	
	
out_loop:
	#return sumd
	move $v0, $s1
	
	lw $ra, 0($sp)
	lw $a0, 4($sp) #centers
	lw $a1, 8($sp) #points
	lw $a2, 12($sp) #numPoints
	lw $a3, 16($sp) #assignments
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	lw $s2, 28($sp)
	lw $s3, 32($sp)
	lw $s4, 36($sp)
	addi $sp, $sp, 40
	
	jr $ra

updateCenter:    #Should test with example 3
	#coord updateCenter(int centerIndex, coord[] points, int numPoints,
				#byte[] assignments)
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $a0, 4($sp) #int centerIndex
	sw $a1, 8($sp) #coord[] points
	sw $a2, 12($sp) #int numPoints
	sw $a3, 16($sp) #byte[] assignments
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	sw $s2, 28($sp)
	sw $s3, 32($sp)
	
	li $s0, 0 #counter and check
	li $s1, 0 #total x
	li $s2, 0 #total y
	li $s3, 0 #coords found

center_loopy:
	beq $s0, $a2, finish
	add $t0, $s0, $a3
	lb $t0, 0($t0) #assignments[i]
	
	#if assignments[i] == centerIndex
	beq $t0, $a0, get_coord
	#else
	addi $s0, $s0, 1
	j center_loopy
get_coord:
	move $t1, $s0
	sll $t1, $t1, 2
	add $t1, $t1, $a1
	lw $t1, 0($t1) # coord
	
	move $a0, $t1
	jal getCoord
	lw $a0, 4($sp)
	
	add $s1, $s1, $v0
	add $s2, $s2, $v1
	
	addi $s0, $s0, 1
	addi $s3, $s3, 1
	j center_loopy
finish:
	
	beqz $s3, no_points_found
	
	div $s1, $s3
	mflo $t0
	div $s2, $s3
	mflo $t1
	
	sll $t0, $t0, 16
	add $v0, $t0, $t1
	
	lw $ra, 0($sp)
	lw $a0, 4($sp) #int centerIndex
	lw $a1, 8($sp) #coord[] points
	lw $a2, 12($sp) #int numPoints
	lw $a3, 16($sp) #byte[] assignments
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	lw $s2, 28($sp)
	lw $s3, 32($sp)
	addi $sp, $sp, 36
	jr $ra
no_points_found:
	li $v0, -1
	li $v1, -1
	
	lw $ra, 0($sp)
	lw $a0, 4($sp) #int centerIndex
	lw $a1, 8($sp) #coord[] points
	lw $a2, 12($sp) #int numPoints
	lw $a3, 16($sp) #byte[] assignments
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	lw $s2, 28($sp)
	lw $s3, 32($sp)
	addi $sp, $sp, 36
	jr $ra

	

threeMeans:
	#int threeMeans(coords[3] centers, coords[]points, int numPoints,
			#byte[] assignments)
	li $t0, 1
	blt $a2, $t0, err
			
	addi $sp, $sp, -40
	sw $ra, 0($sp)
	sw $a0, 4($sp) #centers
	sw $a1, 8($sp) #points
	sw $a2, 12($sp) #numPoints
	sw $a3, 16($sp) #assignments
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	sw $s2, 28($sp)
	sw $s3, 32($sp)
	sw $s4, 36($sp)
	
	li $s0, 0x7FFFFFFF #old_sumd
	li $s1, 0 #i counter for loop
three_loopy:
	li $t0, 5
	beq $s1, $t0, fin
	#print("------ Iteration " + i + " ------\n")
	li $v0, 4
	la $a0, threeMeans1
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, threeMeans2
	syscall
	
	lw $a0, 4($sp)
	#new_sumd = assignPoints(centers, points, numPoints, assignments)
	jal assignPoints
	move $s2, $v0 #new_sumd
	
	#if new_sumd == old_sumd:
		#return new_sumd
	beq $s2, $s0, new
	
	#print("New Sum: " + new_sumd + "\n")
	li $v0, 4
	la $a0, threeMeans3
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	lw $a0, 4($sp)
	move $a0, $a3
	move $a1, $a2
	jal printByteArray
	
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
	li $s3, 0 #j counter
nested_loopy:
	li $t3, 3
	beq $s3, $t3, exit_nest
	
	move $a0, $s3
	#$a1 has $a1, points
	#$a2 has $a2, numPoints
	#$a3 has $a3, assignments
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	jal updateCenter
	#lw $a0, 4($sp)
	move $s4, $v0 #newCenter
	#(-1, -1) = 0xFFFFFFFF
	#if newCenter != (-1,-1)
	li $t4, 0xFFFFFFFF
	bne $s4, $t4, into_print_if
	addi $s3, $s3, 1
	j nested_loopy
into_print_if:
	#print("Cluster " + j + "updated from " + printCoord(centers[j]) + 
		#" to " + printCoord(newCenter) + "\n")
	li $v0, 4
	la $a0, threeMeans4
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, threeMeans5
	syscall
	lw $a0, 4($sp)
	
	move $t0, $s3
	sll $t0, $t0, 2
	add $t0, $t0, $a0
	lw $a0, 0($t0)
	jal printCoord
	
	li $v0, 4
	la $a0, threeMeans6
	syscall
	
	move $a0, $s4
	jal printCoord
	
	li $v0, 11
	li $a0, 10
	syscall
	
	lw $a0, 4($sp)
	
	#centers[j] = newCenter
	move $t0, $s3
	sll $t0, $t0, 2
	add $t0, $t0, $a0
	sw $s4, 0($t0)
	
	addi $s3, $s3, 1
	j nested_loopy
	
exit_nest:
	#old_sumd = new_sumd
	move $s0, $s2
	
	addi $s1, $s1, 1
	
	j three_loopy

new:
	move $v0, $s2
	
	lw $ra, 0($sp)
	lw $a0, 4($sp) #centers
	lw $a1, 8($sp) #points
	lw $a2, 12($sp) #numPoints
	lw $a3, 16($sp) #assignments
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	lw $s2, 28($sp)
	lw $s3, 32($sp)
	lw $s4, 36($sp)
	addi $sp, $sp, 40
	jr $ra
	
	
fin:	
	move $v0, $s0
	
	lw $ra, 0($sp)
	lw $a0, 4($sp) #centers
	lw $a1, 8($sp) #points
	lw $a2, 12($sp) #numPoints
	lw $a3, 16($sp) #assignments
	lw $s0, 20($sp)
	lw $s1, 24($sp)
	lw $s2, 28($sp)
	lw $s3, 32($sp)
	lw $s4, 36($sp)
	addi $sp, $sp, 40
	jr $ra
	
err:
	li $v0, -1
	jr $ra
