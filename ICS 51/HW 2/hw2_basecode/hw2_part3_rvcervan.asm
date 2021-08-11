# Homework 2
# Name: Raul Cervantes
# Net ID: rvcervan
.include "string_input.asm"
.include "hw2_rvcervan.asm"

.globl main

.data
    # DECLARE ANY DATA NEEDED FOR PART 3 HERE
#string1
#string2

newLine: .asciiz "\n"

toLower1: .asciiz "String 1 is "
toLower1Alt: .asciiz "String 2 is "
toLower2: .asciiz " characters long, with "
toLower3: .asciiz " non-alphabetic characters."

failLower1: .asciiz " cannot be letter anagrams, the strings differ by "
failLower2: .asciiz " letters."

failLetters: .asciiz "An invalid string, cannot check for anagram."

Anagrams: .asciiz " are letter anagrams!"

Else1: .asciiz " cannot be letter anagrams, the strings do not use the same set of letters."

Error1: .asciiz " cannot be letter anagrams, the letter "
Error2: .asciiz " has a different number of appearances."

Quote: .asciiz "\""

And: .asciiz " and "

.text
main:

    # Use the data labels in string_intput.asm to access the strings and memory space in the main program
    	#first block
	la $a0, string1
	jal toLower
	move $s0, $v0 #s1len
	move $s6, $v0
	move $s1, $v1 #s1Punc

	####Gets string length	
	add $t0, $s0, $s1

	li $v0, 4
	la $a0, toLower1
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, toLower2
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, toLower3
	syscall
	la $a0, newLine
	syscall
	
	
	#second block
	
	la $a0, string2
	jal toLower
	move $s2, $v0 #s2len
	move $s7, $v0
	move $s3, $v1 #s2Punc

	add $t0, $s2, $s3
	
	li $v0, 4
	la $a0, toLower1Alt
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, toLower2
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, toLower3
	syscall
	la $a0, newLine
	syscall
	
	#third_block
	bne $s0, $s2, length_not_equal


	
	#fourth_block
	la $a0, string1
	la $a1, sorteds1
	addi $a2, $s0, 1
	jal copyLetters
	move $s4, $v0
	
	la $a0, string2
	la $a1, sorteds2
	addi $a2, $s2, 1
	jal copyLetters
	move $s5, $v0
	
	#fifth_block
	blez $s4, failCopy
	blez $s5, failCopy
	
	#sixth_block
	la $a0, sorteds1
	jal insertionSort
	la $a1, lc1
	jal letterCount
	move $s0, $v0 #lc1Len
	la $a0, string1
	jal createProjection
	move $s1, $v0 #s1Proj
	
	la $a0, sorteds2
	jal insertionSort
	la $a1, lc2
	jal letterCount
	move $s2, $v0 #lc2Len
	la $a0, string2
	jal createProjection
	move $s3, $v0 #s2Proj
	
	beq $s1, $s3, intoIf1
	j else
	
	
	j exit

intoIf1:
	la $a0, lc1
	la $a1, lc2
	move $a2, $s0
	move $a3, $s2
	jal compareLetterCount
	move $s4, $v0 #result
	move $s5, $v1 #diff
	
	beqz $s4, success
	bge $s5, $0, error
	
error:
	move $a0, $s1       #  bprojection value
	addi $s5, $s5, 1
	move $a1, $s5               # N
	
	jal searchProjection
	
	move $t0, $v0
	
	li $v0, 4
	la $a0, Quote
	syscall
	la $a0, string1
	syscall
	la $a0, Quote
	syscall
	la $a0, And
	syscall
	la $a0, Quote
	syscall
	la $a0, string2
	syscall
	la $a0, Quote
	syscall
	la $a0, Error1
	syscall
	move $a0, $t0
	li $v0, 11
	syscall
	li $v0, 4
	la $a0, Error2
	syscall
	j exit
	
	
	
success:
	li $v0, 4
	la $a0, Quote
	syscall
	la $a0, string1
	syscall
	la $a0, Quote
	syscall
	la $a0, And
	syscall
	la $a0, Quote
	syscall
	la $a0, string2
	syscall
	la $a0, Quote
	syscall
	la $a0, Anagrams
	syscall
	la $a0, newLine
	syscall
	j exit

else:
	li $v0, 4
	la $a0, Quote
	syscall
	la $a0, string1
	syscall
	la $a0, Quote
	syscall
	la $a0, And
	syscall
	la $a0, Quote
	syscall
	la $a0, string2
	syscall
	la $a0, Quote
	syscall
	la $a0, Else1
	syscall
	la $a0, newLine
	syscall
	
	j exit
	

length_not_equal:
	li $v0, 4
	la $a0, Quote
	syscall
	la $a0, string1
	syscall
	la $a0, Quote
	syscall
	la $a0, And
	syscall
	la $a0, Quote
	syscall
	la $a0, string2
	syscall
	la $a0, Quote
	syscall
	la $a0, failLower1
	syscall

	#absolute value
	sub $t0, $s0, $s2
	
	bge $t0, $0, pos
	sub $t0, $0, $t0
pos:
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, failLower2
	syscall	
	li $v0, 4
	la $a0, newLine
	syscall
	j exit
	
failCopy:
	li $v0, 4
	la $a0, failLetters
	syscall
	la $a0, newLine
	syscall
	j exit
	
	
exit:
    li $v0, 10
    syscall
