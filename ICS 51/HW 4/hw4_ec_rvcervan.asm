# Raul Cervantes
# rvcervan

.text

##########################################
#  Part #1 Functions
##########################################
setWinBoard:
	#void setWinBoard(CColor c)
	#make a star pattern on the board.
	#left byte is for horizontal and vertical
	#right byte is for diagonals
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	
	move $s0, $a0 #CColor c
	
	li $s1, 0 #counter for the row/col
	#$s2 not used
	li $s3, 1 #counter for the down angle
	li $s4, 7 #counter for the up angle
	
	srl $s5, $s0, 8
	andi $s5, $s5, 0xFF #Color for vert and hori
	
	
	andi $s6, $s0, 0xFF #color for diag
	
loopWinRowCol:
	li $t0, 9
	beq $s1, $t0, ContinueWin
	#iterates through columns
	
	li $a0, 4
	move $a1, $s1
	li $a2, -1
	move $a3, $s5
	jal setCell
	
	move $a0, $s1
	li $a1, 4
	li $a2, -1
	move $a3, $s5
	jal setCell
	
	addi $s1, $s1, 1
	j loopWinRowCol
	
ContinueWin:
	
loopWinDiag:
	#skip 4
	li $t0, 8
	beq $s3, $t0, FinishWin
	
	li $t1, 4
	beq $s3, $t1, skip4
	
	move $a0, $s3
	move $a1, $s3
	li $a2, -1
	move $a3, $s6
	jal setCell
	
	move $a0, $s4
	move $a1, $s3
	li $a2, -1
	move $a3, $s6
	jal setCell
	
skip4:
	addi $s3, $s3, 1
	addi $s4, $s4, -1
	j loopWinDiag
FinishWin: 
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra

saveBoard:
	#(int, int) saveBoard(char[] filename, CColor playerColors)
	addi $sp, $sp, -40
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp) 
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	sw $a1, 36($sp)
	
	li $s0, 0 #counter for gamecell
	li $s1, 0 #counter for presetCell
	
	#open file

	li $a1, 1
	li $a2, 0
	li $v0, 13
	syscall
	bltz $v0, saveError
	move $s4, $v0 #file descriptor
	
	li $s6, 0 #counts how many cells have value
	
#count how many cells have value on the board.
	li $s2, 0 #row
loopCount:
	li $t0, 9
	beq $s2, $t0, leaveIt
	li $s3, 0 #col
innerCount:
	li $t0, 9
	beq $s3, $t0, outInnerCount
	
	move $a0, $s2
	move $a1, $s3
	jal getCell
	beqz $v1, dontCount
	addi $s6, $s6, 1
	
dontCount:
	
	addi $s3, $s3, 1
	j innerCount
outInnerCount:
	addi $s2, $s2, 1
	j loopCount
leaveIt:

	
	li $s7, 0 #counter for how many times we write
	li $s2, 0 #row
loopSave:
	li $t0, 9
	beq $s2, $t0, getOut
	li $s3, 0 #col
innerSave:
	li $s5, 0 #to store string
	li $t0, 9
	beq $s3, $t0, outInner
	
	
	move $a0, $s2
	move $a1, $s3
	jal getCell
	move $t8, $v0
	beqz $v1, skipAdding_toFile
	addi $s7, $s7, 1
	addi $t0, $s2, 48 #row in ascii
	
	addi $sp, $sp, -4
	sb $t0, 0($sp)
	
	#write to file
	move $a0, $s4
	move $a1, $sp
	li $a2, 1
	li $v0, 15
	syscall
	bltz $v0, saveError
	
	addi $sp, $sp, 4
	
	addi $t1, $s3, 65 #col in ascii

	addi $sp, $sp, -4
	sb $t1, 0($sp)
	
	#write to file
	move $a0, $s4
	move $a1, $sp
	li $a2, 1
	li $v0, 15
	syscall
	bltz $v0, saveError
	
	addi $sp, $sp, 4	

	addi $t2, $v1, 48 #val in ascii
	
	addi $sp, $sp, -4
	sb $t2, 0($sp)
	
	#write to file
	move $a0, $s4
	move $a1, $sp
	li $a2, 1
	li $v0, 15
	syscall
	bltz $v0, saveError
	
	addi $sp, $sp, 4
	
#	or $s5, $s5, $t0
#	sll $s5, $s5, 4
#	or $s5, $s5, $t1
#	sll $s5, $s5, 4
#	or $s5, $s5, $t2
	
	lw $t0, 36($sp)
	andi $t3, $t0, 0xFF #gets game cell byte
	
	srl $t4, $t0, 8
	andi $t4, $t4, 0xFF #gets preset Cell byte
	
	beq $t8, $t3, Its_gameCell
	#else its preset cell
	#preset cell ascii: 80
	addi $s1, $s1, 1
	li $t0, 80
	
	addi $sp, $sp, -4
	sb $t0, 0($sp)
	
	#write to file
	move $a0, $s4
	move $a1, $sp
	li $a2, 1
	li $v0, 15
	syscall
	bltz $v0, saveError
	
	addi $sp, $sp, 4

	j contSave
	
Its_gameCell:
	#gameCell ascii: 71
	addi $s0, $s0, 1
	li $t0, 71
	
	addi $sp, $sp, -4
	sb $t0, 0($sp)
	
	#write to file
	move $a0, $s4
	move $a1, $sp
	li $a2, 1
	li $v0, 15
	syscall
	bltz $v0, saveError
	
	addi $sp, $sp, 4

contSave:
	#check here if newLine needs to be added or null
	beq $s6, $s7, getOut_addNull
	li $t3, 10 #adds newline at end
	
	addi $sp, $sp, -4
	sb $t3, 0($sp)
	
	#write to file
	move $a0, $s4
	move $a1, $sp
	li $a2, 1
	li $v0, 15
	syscall
	bltz $v0, saveError
	
	addi $sp, $sp, 4
	
	
	
skipAdding_toFile:
	addi $s3, $s3, 1
	j innerSave
	
outInner:
	
	addi $s2, $s2, 1
	j loopSave

getOut:
	#closeFile
	li $v0, 16
	move $a0, $s4
	syscall
	
	move $v0, $s1
	move $v1, $s0
leaveWithError:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp) 
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 40
	jr $ra
	
getOut_addNull:
	li $t0, 0
	
	addi $sp, $sp, -4
	sb $t0, 0($sp)
	
	move $a0, $s4
	move $a1, $sp
	li $a2, 1
	li $v0, 15
	syscall
	bltz $v0, saveError
	
	addi $sp, $sp, 4
	j getOut

saveError:
	li $v0, -1
	li $v1, -1
	j leaveWithError

hint:
	#halfword hint(char[] move, CColor playerColors)
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	move $a0, $s0
	li $a1, 0
	jal getBoardInfo
	bltz $v0, hintError
	move $s2, $v0
	move $s3, $v1
	
	#compare the byte with CColor to see if it is a preset cell
	move $a0, $s2
	move $a1, $s3
	jal getCell
	
	srl $t0, $s1, 8
	andi $t0, $t0, 0xFF
	beq $v0, $t0, hintError
	
	li $s4, 1
	
	li $s5, 0 #bits that get flipped
	li $s6, 2
loopHint:
	li $t0, 10
	beq $s4, $t0, leaveLoopHint
	move $a0, $s2
	move $a1, $s3
	move $a2, $s4 # 1-9
	li $a3, 0xD
	li $t0, 1
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal check
	addi $sp, $sp, 4
	beqz $v0, add_bit
	sll $s6, $s6, 1
	
loopHintCont:
	
	addi $s4, $s4, 1
	j loopHint
leaveLoopHint:
	
	move $v0, $s5
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 32
	jr $ra
	
add_bit:
	or $s5, $s5, $s6
	sll $s6, $s6, 1
	j loopHintCont
	
hintError:
	li $v0, 0xFFFF
	j leaveLoopHint
