.include "lab2_A_rvcervan.asm"  # Change this to your file

.data
excessValue: .word -8   # Modify this to test other cases default 5
k: .word 5			   # Modify this to test other cases default -2
bits: .word 4          # Modify this to test other cases default 4
  
endl: .asciiz "\n"
excess_string: .asciiz "-bit excess-"
value_string: .asciiz " value "
is_string: .asciiz " represents "
decimal_string: .asciiz " in decimal\n"

.globl main
.text
main:
    # print k
    li $v0, 1
    la $t0, bits
    lw $a0, 0($t0)
    syscall


    # print string
    li $v0, 4
    la $a0, excess_string
    syscall

    # print k
    li $v0, 1
    la $t1, k
    lw $a0, 0($t1)
    syscall

    # print string
    li $v0, 4
    la $a0, value_string
    syscall

    # print value
    li $v0, 1
    la $t2, excessValue
    lw $a0, 0($t2)
    syscall

    # print string
    li $v0, 4
    la $a0, is_string
    syscall

    # load the argument registers
    lw $a0, 0($t2)
    lw $a1, 0($t1)
    lw $a2, 0($t0)
	
    # call the function
    jal excess2dec
    
   li $t0, 0x10000000
   beq $t0, $v0, exit
  
    # print return value
    move $a0, $v0
    li $v0, 1
    syscall

    # print string
    li $v0, 4
    la $a0, decimal_string
    syscall
    
    # print newline
    li $v0, 4
    la $a0, endl
    syscall

    # Exit the program
exit:
    li $v0, 10
    syscall
