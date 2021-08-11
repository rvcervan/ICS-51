# DO NOT ADD NEW DECLARATIONS HERE!!!
# Change the strings of s1 & s2 (not the labels) to test part 3 locally.
# The intialization values will be replaced with different values for testing in the autograder
# The labels for each of the items WILL NOT change. 

.data

# These string can be any length
string1: .asciiz "ABADCAFE"
string2: .asciiz "FACEBEAD"

# The space for copied and sorted strings is guaranteed to be declared with length >= length of input strings 
sorteds1: .space 10
sorteds2: .space 10

# to align the memory for the integer arrays (starting address must be a multiple of 4)
.align 2

# int[26] arrays 
lc1: .word -1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26  # all 26 entires initalized
lc2: .space 104  # 26 * 4 bytes per integer, initialized to 0
