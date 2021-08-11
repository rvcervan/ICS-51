.include "hw2_rvcervan.asm"   # change netid

.globl main

.data
#LC1Array: .word 1,2,3,4,4  
#LC2Array: .word 1,2,3,4,4

LC1Array: .asciiz "ABADCAFE"
LC2Array: .asciiz "FACEBEAD"
function_str: .asciiz "Function Returns: ("
comma_str: .asciiz ","
end_str: .asciiz ")\n"

.text
main:

    # load argument and call function
    la $a0, LC1Array	
	la $a1, LC2Array
	li $a2, 8   # len of LC1Array
	li $a3, 8   # len of LC2Array
    jal compareLetterCount

    # save the return values
    move $t0, $v0 
    move $t1, $v1 

    #print out the return values
    li $v0, 4
    la $a0, function_str
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

	la $a0, comma_str
    li $v0, 4
	syscall 

    move $a0, $t1
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, end_str
    syscall

    li $v0, 10
    syscall
