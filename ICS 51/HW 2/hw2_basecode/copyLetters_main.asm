.include "hw2_rvcervan.asm"   # change netid

.globl main

.data
myStr: .asciiz "\0"
dstStr: .asciiz "@@@@@@"  # 20 characters of junk!
mylen: .word 6
src_str: .asciiz "src: "
dst_str: .asciiz "modified dst: "
function_str: .asciiz "Function Returns: "
end_str: .asciiz "\n"

.text
main:
    li $v0, 4
    la $a0, src_str
    syscall

    la $a0, myStr
    syscall

    li $v0, 11
    li $a0, '\n'
    syscall

    # load argument and call function
    la $a0, myStr	# address of src
	la $a1, dstStr  # address of dst
	la $a2, mylen
	lw $a2, 0($a2)  # maxlen value 
    jal copyLetters

    # save the return values
    move $t0, $v0 

    li $v0, 4
    la $a0, dst_str
    syscall

    la $a0, dstStr
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
    la $a0, end_str
    syscall

    li $v0, 10
    syscall
