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
        jr      $ra