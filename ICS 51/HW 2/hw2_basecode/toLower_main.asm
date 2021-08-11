.include "hw2_rvcervan.asm"   # change netid

.globl main

.data
myStr: .asciiz "\0"
input_str: .asciiz "Input: "
modified_str: .asciiz "Modified Input: "
function_str: .asciiz "Function Returns ("
comma_str: .asciiz ", "
end_str: .asciiz ")\n"

.text
main:
    li $v0, 4
    la $a0, input_str
    syscall

    la $a0, myStr
    syscall

    li $v0, 11
    li $a0, '\n'
    syscall

    # load argument and call function
    la $a0, myStr
    jal toLower

    # save the return values
    move $t0, $v0 
    move $t1, $v1 

    li $v0, 4
    la $a0, modified_str
    syscall

    la $a0, myStr
    syscall

    li $v0, 11
    li $a0, '\n'
    syscall


    #print out the return values
    li $v0, 4
    la $a0, function_str
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, comma_str
    syscall

    move $a0, $t1
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, end_str
    syscall

    li $v0, 10
    syscall
