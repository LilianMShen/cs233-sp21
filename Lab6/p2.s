# /**
#  * This function matches a 5x5 pattern across the map using 2D convolution.
#  * If the correlation between the pattern and a 5x5 patch of the map is above the
#  * given threshold, then the left hand corner of the patch will be returned.
#  * If no match was found, then -1 is returned.
#  */
# int pattern_match(int threshold, int pattern[5][5], int map[16][16]) {
#     const int PATTERN_SIZE = 5;
#     const int EDGE = 16 - 5 + 1;

#     for (int row = 0; row < EDGE; row++) {
#         for (int col = 0; col < EDGE; col++) {
#             int sum = 0;
#             for (int pat_row = 0; pat_row < PATTERN_SIZE; pat_row++) {
#                 for (int pat_col = 0; pat_col < PATTERN_SIZE; pat_col++) {
#                     if (pattern[pat_row][pat_col] == map[row + pat_row][col + pat_col]) {
#                         sum += 1;
#                     }
#                     if (sum > threshold) {
#                         return (row << 16) | col;
#                     }
#                 }
#             }
#         }
#     }
#     return -1;
# }

.globl pattern_match
pattern_match:
    

    li      $s0, 5          # PATTERN_SIZE
    li      $s1, 12         # EDGE

    li      $t0, 0          # int row = 0
loop_one:
    bge     $t0, $s1, one_end

    li      $t1, 0          # int column = 0
loop_two:
    bge     $t1, $s1, two_end

    li      $t2, 0          # int sum = 0

    li      $t3, 0          # int pat_row = 0
loop_three:
    bge     $t3, $s0, three_end

    li      $t4, 0          # int pat_col = 0
loop_four:
    bge     $t4, $s0, four_end

    # int threshold = a0, int pattern[5][5] = a1, int map[16][16] = a2
    # for indexing 2d arrays, array[row * NUM_COLUMNS + col]
    mul     $t5, $t3, $s0   # pat_row * PATTERN_SIZE
    add     $t5, $t5, $t4   # + pat_col
    mul     $t5, $t5, 4     # multiply by 4
    add     $t5, $t5, $a1   # memory address of pattern[pat_row][pat_col]
    lw      $s2, 0($t5)     # value of pattern[pat_row][pat_col]

    add     $t7, $t0, $t3   # row_index = row + pat_row
    add     $t8, $t1, $t4   # col_index = col + pat_col
    mul     $t7, $t7, 16    # row_index * NUM_COLUMNS
    add     $t7, $t7, $t8   # + col_index
    mul     $t7, $t7, 4     # multiply by 4
    add     $t7, $t7, $a2   # memory address of map[row + pat_row][col + pat_col]
    lw      $s3, 0($t7)     # value of map[row + pat_row][col + pat_col]

    bne     $s2, $s3, if_one
    addi    $t2, $t2, 1     # increment sum
if_one:

    ble     $t2, $a0, if_two
    sll     $t9, $t0, 16    # row << 16
    or      $v0, $t9, $t1   # | col
    j       end
if_two:

    addi    $t4, $t4, 1
    j       loop_four
four_end:

    addi    $t3, $t3, 1
    j       loop_three
three_end:

    addi    $t1, $t1, 1
    j       loop_two
two_end:

    addi    $t0, $t0, 1
    j       loop_one
one_end:

    li      $v0, -1

end:
    jr      $ra