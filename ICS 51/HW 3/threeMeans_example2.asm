.data

# centers = [(5,9), (12,6), (6,11)]
my_centers: .word 0x00050009, 0x000C0006, 0x0006000B
# point = [(8,14),(10,14),(1,5),(4,0),(13,1),(11,13),(12,10)]
my_points: .word 0x0008000E, 0x000A000E, 0x00010005, 0x00040000, 0x000D0001, 0x000B000D, 0x000C000A
my_numPoints: .word 7
my_assignments: .space 7
