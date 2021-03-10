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

## void draw_line(unsigned int start_pos, unsigned int end_pos, Canvas* canvas) {
##     unsigned int width = canvas->width;
##     unsigned int step_size = 1;
##     // Check if the line is vertical.
##     if (end_pos - start_pos >= width) {
##         step_size = width;
##     }
##     // Update the canvas with the new line.
##     for (int pos = start_pos; pos != end_pos + step_size; pos += step_size) {
##         canvas->canvas[pos / width][pos % width] = canvas->pattern;
##     }
## }

.globl draw_line
draw_line:
    # $a0 = start_pos, $a1 = end_pos, $a2 = canvas

    sub     $sp, $sp, 16         # callee save for s0 and s1

    sw      $s0, 0($sp)
    sw      $s1, 4($sp)
    sw      $s2, 8($sp)
    sb      $s3, 12($sp)

    lw      $s0, 4($a2)         # s0 = width
    li      $s1, 1              # s1 = step_size = 1
    lw      $s2, 12($a2)        # s2 = char** canvas
    lb      $s3, 8($a2)         # s3 = pattern

    sub     $t0, $a1, $a0       # t0 = end_pos - start_pos
    ble     $t0, $s0, not_vertical
    move    $s1, $s0            # step_size = width

not_vertical:

    move    $t1, $a0            # t1 = pos = start_pos
    add     $t2, $a1, $s1       # t2 = end_pos + step_size
loop_one:
    beq     $t1, $t2, one_end

    # canvas->canvas[][] and char** canvas should be treated as a 2d array
    # 2d array indexing -> row * NUM_COLUMNS + col 
    div     $t3, $t1, $s0       # row = pos / width

    mul     $t4, $t3, 4         # row index * 4 (offset)
    add     $t4, $t4, $s2       # + memory address
    lw      $t5, 0($t4)         # array of char (in a row)

    mul     $t6, $t3, $s0       # calculating col = pos % width part 1
    sub     $t6, $t1, $t6       # col = pos % width 

    add     $t7, $t6, $t5       # col + row memory address
    sb      $s3, 0($t7)

    add     $t1, $t1, $s1       # pos += step_size
    j loop_one
one_end:

    add     $sp, $sp, 16         # callee save for s0 and s1
    lw      $s0, 0($sp)
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lb      $s3, 12($sp)

    jr      $ra
