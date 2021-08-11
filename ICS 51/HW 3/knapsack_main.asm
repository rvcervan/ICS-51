.include "hw3_rvcervan.asm"

.data
function_str: .asciiz "Function Returns: "
end_str: .asciiz "\n"

EX1_weight: .word 1,2,3,4,5,6,7,8,9
EX1_value: .word 9,8,7,6,5,4,3,2,1
EX1_maxWeight: .word 25
EX1_N: .word 9

EX2_weight: .word 2,4,5,3
EX2_value: .word 5,2,10,4
EX2_maxWeight: .word 5
EX2_N: .word 4

.text
.globl main

main:
    la $a0, EX1_maxWeight   # maxWeight
    lw $a0, 0($a0)

    la $a1, EX1_weight   # address of weight array
    la $a2, EX1_value    # address of value array

    la $a3, EX1_N        # N
    lw $a3, 0($a3)

    jal knapSack
    # save the return values
    move $t0, $v0 

    #print out the return values
    li $v0, 4
    la $a0, function_str
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, end_str
    syscall

    li $v0, 10
    syscall
