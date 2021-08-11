.include "hw2_rvcervan.asm"   # change netid

.globl main

.data
myStr: .asciiz "Zot! Zot! Anteaters!"
input_str: .asciiz "Input:"
sorted_str: .asciiz "Sorted Input:"

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
    la $a0, myStr	# address of src
    jal insertionSort

    li $v0, 4
    la $a0, sorted_str
    syscall

    la $a0, myStr
    syscall

    li $v0, 11
    li $a0, '\n'
    syscall

    li $v0, 10
    syscall
