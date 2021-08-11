# Raul Cervantes
# rvcervan

.text
searchArray:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	#a0, int array[][]
	#a1, int numRows
	#a2, int numCols
	#a3, int value
	
	#[i][j]
	
	
	#int row_found = col_found = -1;
	li $s0, -1 #col_found 
	li $s1, -1 #row_found 
	li $t4, 4 #size of element in both arrays
	
	li $s2, 0 #counter for first loop c j
	
loop1:
	beq $s2, $a2, done
	li $s3, 0 #counter for second loop r i
loop2:
	beq $s3, $a1, out
	mul $t0, $s3, $a2 #i * num_cols
	add $t0, $t0, $s2 #i * num_cols + j
	sll $t0, $t0, 2 # * size of element (4)
	add $t0, $t0, $a0 #address + stuff
	lw $t0, 0($t0)
	
	beq $t0, $a3, yes
	
	
	addi $s3, $s3, 1
	j loop2
out:	
	addi $s2, $s2, 1
	j loop1
	
yes:
	move $s1, $s3
	move $s0, $s2
	addi $s3, $s3, 1
	j loop2
done:

	move $v0, $s1
	move $v1, $s0
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra
