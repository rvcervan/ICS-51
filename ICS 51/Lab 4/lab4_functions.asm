.text

printClusterPoints:
	addi $sp, $sp, -20
	sw $ra, 0($sp)		# save the ra
	sw $a0, 4($sp)		# save the points
	sw $a1, 8($sp)		# save entries
    sw $s0, 12($sp)     # item iterator 
    sw $s1, 16($sp)     # save prev s1

	li $s0, 0
    move $s1, $a1			

printClusterPoints_printnextitem:
    beq $s0, $s1, printClusterPoints_done

	lw $a0, 4($sp)
	lw $a1, 8($sp)   #entries
	move $a2, $s0	#start at index 0
	jal printEntry

	addi $s0, $s0, 1

	j printClusterPoints_printnextitem

printClusterPoints_done:

	lw $ra, 0($sp)		# restore the ra
	lw $s0, 12($sp)		# restore
	lw $s1, 16($sp)		# restore
	addi $sp, $sp, 20
    jr $ra
