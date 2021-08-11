.data

# centers = [(11,11), (7,1), (0,4)]
my_centers: .word 0x000B000B, 0x00070001, 0x00000004
# point = [(10,0),(11,3),(8,11),(5,3),(12,7),(12,4),(10,0)]
my_points: .word 0x000A0000, 0x000B0003, 0x0008000B, 0x00050003, 0x000C0007, 0x000C0004, 0x000A0000
my_numPoints: .word 7
my_assignments: .space 7
