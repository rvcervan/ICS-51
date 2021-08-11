# Raul Cervantes
# rvcervan

.text
swapValue:
   	addi $sp, $sp, -4
   	sw $ra, 0($sp)

   	#char array[][], $a0
   	#int numRows, $a1
   	#int numCols, $a2
   	#int r1, $a3
   	#int c2, 4($sp)
   	#int r2, 8($sp)
   	#int c1, 12($sp)
   	
   	lw $t0, 4($sp) #c2
   	lw $t1, 8($sp) #r2
   	lw $t2, 12($sp) #c1
   	
   	bge $a3, $a1, neg_one
   	bge $t1, $a1, neg_one
   	bge $t2, $a2, neg_one
   	bge $t0, $a2, neg_one
   	blt $a3, $0, neg_one
   	blt $t1, $0, neg_one
   	blt $t2, $0, neg_one
   	blt $t0, $0, neg_one
   	
   	mul $t3, $a3, $a2 #i * num_cols
	add $t3, $t3, $t2 #i * num_cols + j
	add $t3, $t3, $a0 #address + stuff
	lb $t4, 0($t3) #char temp = array[r1][c1]
	
	mul $t5, $t1, $a2 #i * num_cols
	add $t5, $t5, $t0 #i * num_cols + j
	add $t5, $t5, $a0 #address + stuff
	lb $t6, 0($t5)
	
	sb $t6, 0($t3)
	sb $t4, 0($t5)
	
	li $v0, 0
	
	
   	lw $ra, 0($sp)
   	addi $sp, $sp, 4
	jr $ra
	
	
   	
neg_one:
	li $v0, -1
   	
   	lw $ra, 0($sp)
   	addi $sp, $sp, 4
	jr $ra
