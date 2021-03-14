.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;
##     unsigned int width;
##     // The pattern to draw on the canvas.
##     unsigned char pattern;
##     // Each char* is null-terminated and has same length.
##     char** canvas;
## };
## 
## // Count the number of disjoint empty area in a given canvas.
## unsigned int count_disjoint_regions_step(unsigned char marker,
##                                          Canvas* canvas) {
##     unsigned int region_count = 0;
##     for (unsigned int row = 0; row < canvas->height; row++) {
##         for (unsigned int col = 0; col < canvas->width; col++) {
##             unsigned char curr_char = canvas->canvas[row][col];
##             if (curr_char != canvas->pattern && curr_char != marker) {
##                 region_count ++;
##                 flood_fill(row, col, marker, canvas);
##             }
##         }
##     }
##     return region_count;
## }

.globl count_disjoint_regions_step
count_disjoint_regions_step:
    # Your code goes here :)
    sub     $sp, $sp, 20         # callee save

    sw      $s5, 0($sp)
    sw      $s6, 4($sp)
    sw      $s7, 8($sp)
    sw      $s8, 12($sp)
	sw		$ra, 16($sp)

    move    $s5, $a0
    move    $s6, $a1

    li      $t0, 0              # t0 = region_count
    li      $s7, 0              # s7 = row

    lw      $t4, 0($s6)         # t4 = height
    lw      $t5, 4($s6)         # t5 = width
	lbu     $t6, 8($s6)         # t6 = pattern
    lw      $t7, 12($s6)        # t7 = char** canvas
loop_one:
    bge     $s7, $t4, one_end

    li      $s8, 0              # s8 = col
loop_two:
    bge     $s8, $t5, two_end

	mul 	$t3, $s7, 4			# row * 4
	add		$t3, $t3, $t7		# + memory address 
	lw		$t3, 0($t3)			# array of char (in a row)
	add		$t3, $s8, $t3		# t3 = col + row memory address
    lbu     $t8, 0($t3)			# t8 = loading the current pattern

    beq     $t8, $t6, not_if
    beq     $t8, $s5, not_if
    addi    $t0, $t0, 1         # increment region_count

    move    $a0, $s7            # a0 = row
    move    $a1, $s8            # a1 = col
    move    $a2, $s5            # a2 = marker
    move    $a3, $s6            # a3 - canvas
    jal     flood_fill
not_if:

    addi    $s8, $s8, 1         # increment col
    j       loop_two
two_end:

    addi    $s7, $s7, 1         # increment row
    j       loop_one
one_end:

    lw      $s5, 0($sp)
    lw      $s6, 4($sp)
    lw      $s7, 8($sp)
    lw      $s8, 12($sp)
    lw		$ra, 16($sp)
	add     $sp, $sp, 20         # callee save

    jr      $ra
