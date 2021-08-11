.text 

#return 1 if num is odd, 0 if even
#int isOdd(int num)
isOdd:
    move $t0, $a0       # purposely (inefficiently) using temp registers!!
    li $t2, 0x00000001
    and $t1, $t0, $t2
    move $v0, $t1
    jr $ra

#recursive factorial implementation
#int factorial(int num)
factorial: 
    # Body #1
    li   $t0, 1         # check if a0 = 1
    bgt  $a0, $t0, factorial_else  # no: go to else  
    li   $v0, 1         # yes: return 1
    jr   $ra            # return

factorial_else:   
    # Body #2   
    #Prologue
    addi $sp, $sp, -8   # make room
    sw   $a0, 4($sp)    # store $a0
    sw   $ra, 0($sp)    # store $ra

    addi $a0, $a0, -1   # n = n - 1
    jal  factorial      # recursive call

    lw   $a0, 4($sp)    # restore $a0
    mul  $v0, $a0, $v0  # n * factorial(n-1), Uses $a0 that was preserved on stack

    #Epilogue #2
    lw   $ra, 0($sp)    # restore $ra
    addi $sp, $sp, 8    # restore $sp
    jr   $ra            # return


# $a0: char[] statStr
# $a1: int value
# $a2: int total
#Print out the stat on the value
#void printStat(char[] statStr, int value, int total)
printStat:

    # use floating point registers to print the percentage
    mtc1 $a1, $f0
    mtc1 $a2, $f1
    div.s $f12, $f0, $f1
    
    li $v0, 2
    syscall

    li $v0, 4
    syscall

    li $a0, 0xFF   # Argument Regs are not guranteed to be preserved over function calls!
    li $a1, 0xFF   
    li $a2, 0xFF   

    jr $ra
