# Raul Cervantes
# rvcervan

#Notes
#Each cell in sudoku is 2 bytes (half word).
#upper 8 bits are background and foreground color information.
#lower 8 bits contains the ASCII character to be displayed in the cell.
#The MMIO region in MARS begins at address 0xffff0000

#The simulator will treat the bytes starting at 0xffff0000 as the values of a 9-column-by-9-row
#window.

#We will store the selections using a half-word of memory (2 bytes), denoted as CColor.
#This means that the upper byte of the half-word is the preset cell, a cell that has no value.
#Once you enter a value, you swap it with the lower byte, which is the game cell. 

#Row-Major order

#Cell OA is the top left cell of the board, or array [0,0]
#Given that the starting address of the board is 0xffff0000, bytes 0xffff0000 and 0xffff0001
#correspond to the cell.

#Byte 0xffff0000 (These are addresses and not values you modify) is the 8 bit value of the ASCII
#Byte 0xffff0001 is the 8 bit format for the coloring information.

.text

##########################################
#  Part #1 Functions
##########################################
checkColors:
	#(CColor, byte) checkColors (byte pc_bg, byte pc_fg, byte gc_bg, byte gc_fg,
	#			     byte err_bg)
	#err_bg: color for the background of the 
	#a0, byte pc_bg
	#a1, byte pc_fg
	#a2, byte gc_bg
	#a3, byte gc_fg
	#4($sp), byte err_bg
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	lw $t0, 4($sp) #err_bg
	#if err_bg == pc_bg or pc_fg or gc_bg or gc_fg;
	#	return error stuff
	beq $t0, $a0, colorError
	beq $t0, $a1, colorError
	beq $t0, $a2, colorError
	beq $t0, $a3, colorError
	
	#if pc_fg == gc_fg;
	#	return error stuff
	beq $a1, $a3, colorError
	
	#if pc_fg == pc_bg;
	#	return error stuff
	beq $a1, $a0, colorError
	
	#if gc_bg == gc_fg;
	#	return error stuff
	beq $a2, $a3, colorError

	#if no error, combine first 4 values and represent them as 2 bytes
	#and return (half_word, err_bg)
	li $t1, 0x0000
	or $t1, $t1, $a0
	sll $t1, $t1, 4
	or $t1, $t1, $a1
	sll $t1, $t1, 4
	or $t1, $t1, $a2
	sll $t1, $t1, 4
	or $t1, $t1, $a3
	
	move $v0, $t1
	move $v1, $t0
	j done
	
	#if error, return (0xFFFF, 0xFF)
colorError:
	li $v0, 0xFFFF
	li $v1, 0xFF
	j done

done:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

setCell:
	#int setCell (int r, int c, int val, byte cellColor)
	#a0, int r
	#a1, int c
	#a2, int val
	#a3, byte cellColor
	
	#if val is 0, cell value is '\0'
	#if val is -1, cell color is the only thing that changes.
	#lower byte of 2byte cell is the val, upper byte is the color 
	
	#for [0,0], the starting address is 0xffff0000 and this cell is 
	#0xffff0000, 0xffff0001. 
	#0xffff0000 is the 8-bit value of the ASCII char to display
	#0xffff0001 is the 8-bit format for the coloring info for the cell.
	
	#baseaddress + (r*num_cols+c)*2 is cell address
	#cell address is the val
	#cell address+1 is the color.
	
	#error checks
	li $t0, 9
	
	bltz $a0, cellError
	bge $a0, $t0, cellError
	
	bltz $a1, cellError
	bge $a1, $t0, cellError
	
	li $t1, -1
	blt $a2, $t1, cellError
	bgt $a2, $t0, cellError
	
	li $t1, 0xFFFF0000 #starting address
	
	
	mul $t2, $a0, $t0 #r * num_cols
	add $t2, $t2, $a1 # (r*num_cols) + c
	li $t3, 2
	mul $t2, $t2, $t3 #(r*num_cols+c) * 2
	
	add $t4, $t1, $t2 #base_address +  (r*num_col+c)*2
	addi $t5, $t4, 1 #cell_address + 1
	
	bltz $a2, changeCellColor
	beqz $a2, setNull
	
	
	addi $t6, $a2, 48
	sb $t6, 0($t4)
	sb $a3, 0($t5)
	
	li $v0, 0
	
	j done2
	
setNull:
	sb $a2, 0($t4)
	sb $a3, 0($t5)
	
	li $v0, 0
	
	j done2

changeCellColor:
	sb $a3, 0($t5)
	li $v0, 0
	j done2

cellError:
	li $v0, -1
	j done2
	
	
done2:
	jr $ra

getCell:
	#(byte, int) getCell(int r, int c)
	#returns (cell_color, cell_value)
	#returns (0xFF, -1) on error
	#$a0, int r
	#$a1, int c
	
	#error cases
	li $t0, 9
	bltz $a0, getCellError
	bge $a0, $t0, getCellError
	bltz $a1, getCellError
	bge $a0, $t0, getCellError
	
	li $t1, 0xFFFF0000 #starting address
	
	mul $t2, $a0, $t0 #r * num_cols
	add $t2, $t2, $a1 # (r*num_cols) + c
	li $t3, 2
	mul $t2, $t2, $t3 #(r*num_cols+c) * 2
	
	add $t4, $t1, $t2 #base_address +  (r*num_col+c)*2
	addi $t5, $t4, 1 #cell_address + 1
	
	lb $t0, 0($t4) #val
	lbu $t1, 0($t5) #color

	#check if val is 0 for null
	beqz $t0, isNull
	
	addi $t0, $t0, -48
	#error check if val is within 1-9
	li $t2, 1
	li $t3, 9
	blt $t0, $t2, getCellError
	bgt $t0, $t3, getCellError
	
	move $v0, $t1
	move $v1, $t0
	j done3
	

isNull:
	move $v0, $t1
	move $v1, $t0
	j done3
getCellError:
	li $v0, 0xFF
	li $v1, -1
	j done3
	
done3:

	jr $ra

reset:
	#int reset(CColor curColor, byte err_bg, int numConflicts)
	#a0, CColor curColor
	#a1, byte err_bg
	#a2, int numConflicts
	#calls setCell, and getCell
	#CColor is 2bytes: pc_bg, pc_fg, gc_bg, gc_fg
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	#error checking goes here
	li $t0, 0xF
	bgt $a1, $t0, resetError
	
	bltz $a2, emptyBoard
	beqz $a2, preset_only
	bgtz $a2, choose

choose:
	move $s7, $a1 #err_bg
	move $s2, $a2 #numConflict
	#iterate cells in column major order and set cells marked with color err_bg.
	#you are only allowed to change the cells as many times as numConflicts allows.
	#cells marked are changed to the color specified in curColor\
	srl $s4, $a0, 8 # preset cell color
	andi $s5, $a0, 0x00FF # game cell color
	
	li $s6, 0 #counter for numConflicts
	
	li $s1, 0 #c	
	
loop3:
	li $t4, 9 #for loop check
	bgt $s1, $t4, success
	li $s3, 0 #r
innerloop3:
	beq $s6, $s2, success
	li $t4, 9 #for loop check
	bgt $s3, $t4, innerloop3End
#################
	move $a0, $s3
	move $a1, $s1
	jal getCell
	#$v0, byte color
	#$v1, value
	srl $t0, $v0, 4 #cell retrieve bg
	#match cell retrieved bf with err_bg
	beq $t0, $s7, changeCell
	
	

cont3:
	
	
#################
	addi $s3, $s3, 1
	j innerloop3
innerloop3End:
	addi $s1, $s1, 1
	j loop3

changeCell:
	addi $s6, $s6, 1
	#compare foreground of getCell with CColor cells preset fg and game fg
	#if getCell fg == preset fg, cell is a preset cell
	#if getCell fg == game fg, cell is a game cell
	andi $t0, $v0, 0x0F #getCell fg
	andi $t1, $s4, 0x0F #preset fg
	andi $t2, $s5, 0x0F #game fg
	
	beq $t0, $t1, presetChoose
	beq $t0, $t2, gameChoose
	
	#fg color of CColor does not match fg of preset or game cell
	j resetError
gameChoose:
	move $a0, $s3
	move $a1, $s1
	move $a2, $v1
	move $a3, $s5
	jal setCell
	
	j cont3
	
presetChoose:
	move $a0, $s3
	move $a1, $s1
	move $a2, $v1
	move $a3, $s4
	jal setCell
	j cont3

preset_only:
	#gameboard is reset to only the preset cells.
	srl $s4, $a0, 8 # preset cell color
	andi $s5, $a0, 0x00FF # game cell color
	#iterate cells and with getCell, get cell color information
	#if cell color matches game cell color, reset that cell to its preset using setCell
	#with setCell, pass in preset cell color and null value.
	li $s1, 0 #r
	li $s2, 0 #null val	
	
loop2:
	li $t4, 9 #for loop check
	bgt $s1, $t4, success
	li $s3, 0 #c
innerloop2:
	li $t4, 9 #for loop check
	bgt $s3, $t4, innerloop2End
	
	move $a0, $s1
	move $a1, $s3
	jal getCell
	beq $v0, $s5, set_to_preset
cont2:
	

	addi $s3, $s3, 1
	j innerloop2
innerloop2End:
	addi $s1, $s1, 1
	j loop2

set_to_preset:
	move $a0, $s1
	move $a1, $s3
	li $a2, 0
	move $a3, $s4
	jal setCell
	
	j cont2
	
emptyBoard:
	#sets all values to null
	#sets foreground to black and background to white
	li $s1, 0 #r
	li $s2, 0 #null val	
	
loop1:
	li $t4, 9 #for loop check
	bgt $s1, $t4, success
	li $s3, 0 #c
innerloop1:
	li $t4, 9 #for loop check
	bgt $s3, $t4, innerloop1End
	
	move $a0, $s1
	move $a1, $s3
	li $a2, 0
	li $a3, 0xf0
	jal setCell

	addi $s3, $s3, 1
	j innerloop1
innerloop1End:
	addi $s1, $s1, 1
	j loop1

success:
	beqz $s6, resetError
	li $v0, 0
	j done4

resetError:
	li $v0, -1
	j done4


done4:	
	
	
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	jr $ra

##########################################
#  Part #2 Function
##########################################

#(int, int) getBoardInfo(char[] line, int flag)
#string contains 4 chars and is terminated by \n or \0
#The first char is the row on board
#The second char is the column of board.
#The third char is the value to place in the cell on board
#The fourth char is the type of Cell: 'P' for preset, 'G' or '\n' for game.
#When '\n' is detected, the function returns 'G' as the type.

#function params
#line: starting address of char string
#flag: 0 to obtain board cell position, non-zero value to return cell value and type
#returns: (row, column) when flag == 0, (value, type) when flag != 0, (-1, -1) on error.

#Errors
#when flag == 0, length of line < 3 ('\n' counts, '\0' is not counted)
#when flag != 0, length of line < 4 ('\n' counts, '\0' is not counted)

readFile:
	#int readFile(char[] filename, CColor boardColors)
	#$a0, char[] filename
	#$a1, CColor boardColors
	addi $sp, $sp, -40 #additional space added for stack buffer
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	
	move $s0, $a0
	move $s1, $a1
	#clear board with reset.
	
	li $a0, 0xFFFF
	li $a1, 0xF
	li $a2, -1
	jal reset
	
	#openfile
	li $v0, 13
	move $a0, $s0
	li $a1, 0 #read only
	li $a2, 9
	syscall
	move $s2, $v0 #file descriptor
	
loopRead:

	#readfile
	li $v0, 14
	move $a0, $s2
	move $a1, $sp
	li $a2, 5
	syscall
	move $s3, $v0 #characters read
	
	move $a0, $sp
	li $a1, 0
	jal getBoardInfo
	move $s4, $v0 #row
	move $s5, $v1 #col
	
	move $a0, $sp
	li $a1, 1
	jal getBoardInfo
	move $s6, $v0 #val not in ascii
	move $t2, $v1 #type of cell, 80 for 'P', 71 or 0 for 'G'
	
	#setCell based on G or P
	li $t0, 80
	li $t1, 71
	beq $t2, $t0, PresetCell
	beq $t2, $t1, GameCell
	beqz $t2, GameCell
	
	#shouldn't go through, only if error
	j carry_on
continue_loop:
	
	beqz $s3, carry_on
	j loopRead
###############
carry_on:	
	#close file
	move $a0, $s2
	li $v0, 16
	syscall
	
##########count unique cells
	li $s0, 0 #r	
	li $s2, 0 #counter
	
loop4:
	li $t4, 8 #for loop check
	bgt $s0, $t4, done_read
	li $s1, 0 #c
innerloop4:
	li $t4, 8 #for loop check
	bgt $s1, $t4, innerloop4End
#################
	move $a0, $s0
	move $a1, $s1
	jal getCell
	li $t0, 1
	li $t1, 2
	li $t2, 3
	li $t3, 4
	li $t4, 5
	li $t5, 6
	li $t6, 7
	li $t7, 8
	li $t8, 9
	beq $t0, $v1, add_counter
	beq $t1, $v1, add_counter
	beq $t2, $v1, add_counter
	beq $t3, $v1, add_counter
	beq $t4, $v1, add_counter
	beq $t5, $v1, add_counter
	beq $t6, $v1, add_counter
	beq $t7, $v1, add_counter
	beq $t8, $v1, add_counter


cont4:

#################
	addi $s1, $s1, 1
	j innerloop4
innerloop4End:
	addi $s0, $s0, 1
	j loop4

done_read:
	move $v0, $s2
	
	lw $ra, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	lw $s5, 32($sp)
	lw $s6, 36($sp)
	addi $sp, $sp, 40

	jr $ra

PresetCell:

	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	srl $a3, $s1, 8
	andi $a3, $a3, 0x00FF
	jal setCell

	j continue_loop
GameCell:

	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	andi $a3, $s1, 0x00FF
	jal setCell
	
	j continue_loop
	
add_counter:
	addi $s2, $s2, 1
	j cont4

##########################################
#  Part #3 Functions
##########################################

rowColCheck:
	#(int, int) rowColCheck(int row, int col, int value, int flag)
	#$a0, int row
	#$a1, int col
	#$a2, int val
	#$a3, int flag
	
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	sw $s2, 12($sp)
	
	#error checks
	li $t0, 9
	bltz $a0, noConflict1
	bge $a0, $t0, noConflict1
	
	bltz $a1, noConflict1
	bge $a1, $t0, noConflict1
	
	li $t1, -1
	blt $a2, $t1, noConflict1
	bgt $a2, $t0, noConflict1
	
	#if flag == 0 check row
	#else check col
	beqz $a3, rowCheck
	j colCheck
	
Finish_rowColCheck:
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra

colCheck:
	move $s1, $a1 #col
	move $s2, $a0 #row to check against so that I can skip it.
	li $s0, 0 #to increment row
colLoop:
	li $t0, 9
	beq $s0, $t0, noConflict1
	beq $s0, $s2, skip_row #if current row matches the arg row, skip it.
	move $a0, $s0
	move $a1, $s1
	jal getCell
	beq $v1, $a2, cellConflict1
skip_row:
	
	addi $s0, $s0, 1
	j colLoop

rowCheck:
	move $s0, $a0 #row
	move $s2, $a1 #col to check against so that I can skip it.
	li $s1, 0 #to increment col
rowLoop:
	li $t0, 9
	beq $s1, $t0, noConflict1
	beq $s2, $s1, skip_col #if current col matchs with arg col, skip it.
	move $a0, $s0
	move $a1, $s1
	jal getCell
	beq $v1, $a2, cellConflict1
skip_col:
	addi $s1, $s1, 1
	j rowLoop

cellConflict1:
	move $v0, $s0
	move $v1, $s1
	
	j Finish_rowColCheck
	
noConflict1:
	li $v0, -1
	li $v1, -1
	
	j Finish_rowColCheck

squareCheck:
	#(int, int) squareCheck(int row, int col, int value)
	#$a0, int row
	#$a1, int col
	#$a2, int val
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s5, $a0 #preserved row
	move $s6, $a1 #preserved col
	
	#error
	li $t0, 9
	li $t1, -1
	bltz $a0, squareCon
	bge $a0, $t0, squareCon
	
	bltz $a1, squareCon
	bge $a1, $t0, squareCon
	
	blt $a2, $t1, squareCon
	bgt $a2, $t0, squareCon

	#row to square
	li $t0, 3
	blt $a0, $t0, square_x_zero
	
	li $t0, 5
	bgt $a0, $t0, square_x_two
	
	#else square_x_one
	
	li $s0, 1
	
continue_for_y:
	#col to square
	li $t0, 3
	blt $a1, $t0, square_y_zero
	
	li $t0, 5
	bgt $a1, $t0, square_y_two
	
	#else square_y_one
	
	li $s1, 1

continue_with_square:
	#$s0 is square x region
	#$s1, is square y region
	li $t0, 3
	mul $s0, $s0, $t0
	mul $s1, $s1, $t0
	
	addi $s2, $s0, 2 #x+2
	addi $s3, $s1, 2 #y+2
	
squareLoop:
	bgt $s0, $s2, noConflictSquare
	move $s4, $s1
innerSquare:
	bgt $s4, $s3, contSquare
	#s5, r
	#s6, c
	beq $s0, $s5, check_col

not_same_cont:
	move $a0, $s0
	move $a1, $s4
	jal getCell
	beq $v1, $a2, cellConflictSquare
same_row_col_skip:
	
	addi $s4, $s4, 1
	j innerSquare
contSquare:
	addi $s0, $s0, 1
	j squareLoop
	
cellConflictSquare:
	move $v0, $s0
	move $v1, $s4
	
	j squareFinish

check_col:
	beq $s4, $s6, same_row_col_skip
	j not_same_cont
	
noConflictSquare:
	li $v0, -1
	li $v1, -1
	
	j squareFinish
	
squareFinish:
	
	
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
	
square_y_zero:
	li $s1, 0
	j continue_with_square
	
square_y_two:
	li $s1, 2
	j continue_with_square

square_x_zero:
	li $s0, 0
	j continue_for_y

square_x_two:
	li $s0, 2
	j continue_for_y

squareCon:
	li $v0, -1
	li $v1, -1
	j squareFinish


check:
	#int check(int row, int col, int value, byte err_color, int flag)
	#$a0, int row
	#$a1, int col
	#$a2, int value
	#$a3, byte err_color
	#32($sp), int flag
	
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp) #reserved for error x
	sw $s6, 28($sp) #reserved for error y
	
	move $s0, $a0 #row
	move $s1, $a1 #col
	move $s2, $a2 #value
	move $s3, $a3 #err_color background
	
	#check for errors
	li $t0, -1
	li $t1, 9
	bltz $a0, checkError
	bge $a0, $t1, checkError
	
	bltz $a1, checkError
	bge $a1, $t1, checkError
	
	blt $a2, $t0, checkError
	bgt $a2, $t1, checkError
	
	li $t0, 0xF
	bgt $a3, $t0, checkError
	
	#if flag is 1, the bg color of all conflicting cells are changed
	li $t0, 1
	lw $t1, 32($sp)
	beq $t1, $t0, flag_one
	
	#if flag is 0, count the errors but don't chang the bg?
	beqz $t1, flag_zero
	
	
	
checkFinish:

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

checkError:
	li $v0, -1
	j checkFinish
	
flag_zero:
	#same as flag one but you dont change the color
	li $s4, 0 #counter for errors
	
	#check row
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	li $a3, 0
	jal rowColCheck
	li $t0, -1
	beq $v0, $t0, skip_add1
	addi $s4, $s4, 1
skip_add1:
	
	#check col
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	li $a3, 3
	jal rowColCheck
	li $t0, -1
	beq $v0, $t0, skip_add2
	addi $s4, $s4, 1
skip_add2:

	#check square
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal squareCheck
	li $t0, -1
	beq $v0, $t0, skip_add3
	addi $s4, $s4, 1
skip_add3:
	
	move $v0, $s4
	j checkFinish

flag_one:

	li $s4, 0 #counter for errors
	
	#check row
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	li $a3, 0
	jal rowColCheck
	li $t0, -1
	bne $v0, $t0, change_bg1 #if v0 is not -1, then there is an error cell.
continue_check1:
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	li $a3, 5
	jal rowColCheck
	li $t0, -1
	bne $v0, $t0, change_bg2
continue_check2:

	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal squareCheck
	li $t0, -1
	bne $v0, $t0, change_bg3
continue_check3:
	move $v0, $s4
	j checkFinish

change_bg3:
	move $s5, $v0 #error x
	move $s6, $v1 #error y
	move $a0, $v0
	move $a1, $v1
	jal getCell
	#(cell_color, cell_value)
	#change bg of cell
	andi $t1, $v0, 0x0F #gets rid of current bg of cell
	sll $t2, $s3, 4 #shifts color to be in bg position.
	or $t1, $t1, $t2 #new bg with same fg
	
	move $a0, $s5
	move $a1, $s6
	move $a2, $v1
	move $a3, $t1
	jal setCell
	
	addi $s4, $s4, 1
	j continue_check3

change_bg2:
	move $s5, $v0 #error x
	move $s6, $v1 #error y
	move $a0, $v0
	move $a1, $v1
	jal getCell
	#(cell_color, cell_value)
	#change bg of cell
	andi $t1, $v0, 0x0F #gets rid of current bg of cell
	sll $t2, $s3, 4 #shifts color to be in bg position.
	or $t1, $t1, $t2 #new bg with same fg
	
	move $a0, $s5
	move $a1, $s6
	move $a2, $v1
	move $a3, $t1
	jal setCell
	
	addi $s4, $s4, 1
	j continue_check2

change_bg1:
	move $s5, $v0 #error x
	move $s6, $v1 #error y
	move $a0, $v0
	move $a1, $v1
	jal getCell
	#(cell_color, cell_value)
	#change bg of cell
	andi $t1, $v0, 0x0F #gets rid of current bg of cell
	sll $t2, $s3, 4 #shifts color to be in bg position.
	or $t1, $t1, $t2 #new bg with same fg
	
	move $a0, $s5
	move $a1, $s6
	move $a2, $v1
	move $a3, $t1
	jal setCell
	
	addi $s4, $s4, 1
	j continue_check1
	

makeMove:
	#(int, int) makeMove(char[] move, CColor playerColors, byte err_color)
	#$a0, char[] move
	#$a1, CColor playerColors
	#$a2, byte err_color
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0 #char[] move
	move $s1, $a1 #CColor playerColors
	move $s2, $a2 #byte err_color

	#(row, col) = getBoardInfo(move, 0);
	move $a0, $s0
	li $a1, 0
	jal getBoardInfo
	move $s3, $v0 #row
	move $s4, $v1 #col
	li $t0, -1
	beq $v0, $t0, return_negOne_zero
	
	move $a0, $s0
	li $a1, 3
	jal getBoardInfo
	move $s5, $v0 #moveValue
	move $s6, $v1 #type
	li $t0, -1
	beq $v0, $t0, return_negOne_zero
	
	move $a0, $s3
	move $a1, $s4
	jal getCell
	#$v0, cellColor
	#$v1, curvalue
	
	beq $v1, $s5, noAction
	beqz $v1, checkSecond
go_to_else:
	#get Preset cell from CColor
	srl $t0, $s1, 8
	andi $t0, $t0, 0x00FF
	beq $v0, $t0, return_negOne_zero
	
	beqz $s5, set_the_Cell
	
	#check conflicts
	move $a0, $s3
	move $a1, $s4
	move $a2, $s5
	move $a3, $s2
	addi $sp, $sp, -4
	li $t0, 1
	sw $t0, 0($sp)
	jal check
	bnez $v0, returnConflicts
	addi $sp, $sp, 4

	move $a0, $s3
	move $a1, $s4
	move $a2, $s5
	move $a3, $s1
	andi $a3, $a3, 0x00FF
	jal setCell
	li $v0, 0
	li $v1, -1
	
Finish_makeMove:
	
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

returnConflicts:
	move $v1, $v0
	li $v0, -1
	j Finish_makeMove

set_the_Cell:
	move $a0, $s3
	move $a1, $s4
	li $a2, 0
	move $a3, $s1
	andi $a3, $a3, 0x00FF
	jal setCell
	j newCellSet

return_negOne_zero:
	li $v0, -1
	li $v1, 0
	j Finish_makeMove

newCellSet:
	li $v0, 0
	li $v1, 1
	j Finish_makeMove

noAction:
	li $v0, 0
	li $v0, 0
	j Finish_makeMove

checkSecond:
	beqz $s5, noAction
	j go_to_else




