# Raul Cervantes
# rvcervan

.text

updatePoint:
	#$a0, cluster_points[] points
	#$a1, int entries
	#$a2, int pos
	#$a3, coor new_p
	#$t0, 0($sp) char assignment
	lw $t0, 0($sp)
	
	addi $sp, $sp, -4
	sw $ra 0($sp)
	
	bge $a2, $a1, error
	blt $a2, $0, error
	
	move $t1, $a2 #pos
	sll $t1, $t1, 3 #mul by 8
	add $t1, $t1, $a0
	
	sb $t0, 0($t1) #points[pos][0] = assignment
	addi $t1, $t1, 4
	sw $a3, 0($t1) #points[pos][1] = new_p
	
	li $v0, 0
	j end
	
	
error:
	li $v0, -1
	j end
	
end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

printEntry:
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	#a0, cluster_points[] points
	#a1, int entries
	#a2, int pos
	bge $a2, $a1, ret
	blt $a2, $0, ret
	
	move $t0, $a2
	sll $t0, $t0, 3
	add $t0, $t0, $a0
	lb $t1, 0($t0) #c
	addi $t0, $t0, 4
	lw $t2, 0($t0) #coord
	
	move $t3, $t2
	srl $t3, $t3, 16 #x
	
	move $t4, $t2
	sll $t4, $t4, 16
	srl $t4, $t4, 16 #y
	
	li $v0, 11
	li $a0, 91 #'['
	syscall
	li $a0, 32 #' '
	syscall
	
	li $v0, 1
	move $a0, $t3 #'x'
	syscall
	li $v0, 11
	li $a0, 32 #' '
	syscall
	li $v0, 11
	li $a0, 44 #','
	syscall
	li $a0, 32 #' '
	syscall
	
	li $v0, 1
	move $a0, $t4 #'y'
	syscall
	li $v0, 11
	li $a0, 32 #' '
	syscall
	li $v0, 11
	li $a0, 44 #','
	syscall
	li $a0, 32 #' '
	syscall
	
	li $v0, 11
	move $a0, $t1 #c
	syscall	
	li $v0, 11
	li $a0, 32 #' '
	syscall
	li $a0, 93 #']'
	syscall
	
	li $a0, 10
	syscall #'\n'
	
	
ret:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
