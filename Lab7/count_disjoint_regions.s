.text

## struct Lines {
##     unsigned int num_lines;
##     // An int* array of size 2, where first element is an array of start pos
##     // and second element is an array of end pos for each line.
##     // start pos always has a smaller value than end pos.
##     unsigned int* coords[2];
## };
## 
## struct Solution {
##     unsigned int length;
##     int* counts;
## };
## 
## // Count the number of disjoint empty area after adding each line.
## // Store the count values into the Solution struct. 
## void count_disjoint_regions(const Lines* lines, Canvas* canvas,
##                             Solution* solution) {
##     // Iterate through each step.
##     for (unsigned int i = 0; i < lines->num_lines; i++) {
##         unsigned int start_pos = lines->coords[0][i];
##         unsigned int end_pos = lines->coords[1][i];
##         // Draw line on canvas.
##         draw_line(start_pos, end_pos, canvas);
##         // Run flood fill algorithm on the updated canvas.
##         // In each even iteration, fill with marker 'A', otherwise use 'B'.
##         unsigned int count =
##                 count_disjoint_regions_step('A' + (i % 2), canvas);
##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;
##     }
## }

.globl count_disjoint_regions
count_disjoint_regions:
    # Your code goes here :)
    sub     $sp, $sp, 12         # callee save

    sw      $s4, 0($sp)
    sw      $s5, 4($sp)
    sw      $s6, 8($sp)

    move    $s4, $a0            # s4 = lines
    move    $s5, $a1            # s5 = canvas
    move    $s6, $a2            # s6 = solution

    lw      $t0, 0($s4)         # t0 = num_lines
    lw      $t1, 4($s1)         # t1 = int* coords[2]

    li      $t2, 0              # t2 = i 
for_loop:
    bge     $t2, $t0, loop_end

    addi    $t3, $t1, 4         # + memory address
    lw      $t3, 0($t3)         # t3 = start_pos

    addi    $t4, $0, 4          # int offset by 4
    add     $t4, $t4, $t1       # + memory address
    add     $t4, $t4, $t2       # + col 
    lw      $t4, 0($t4)         # t4 = end_pos

    move    $a0, $t3
    move    $a1, $t4
    move    $a2, $s5
    jal     draw_line

    andi    $t5, $t2, 1         # checks if odd or even
    beq     $t5, 1, odd_iteration
even_iteration:
    li      $t5, 'A'            # A if even
    j       skip
odd_iteration:
    li      $t5, 'B'            # B if odd
skip:
    div     $t6, $t2, 2
    mfhi    $t6                 # mod operator
    add     $t5, $t5, $t6

    move    $a0, $t5
    move    $a1, $s5

    jal     count_disjoint_regions_step

    lw      $t8, 4($s6)
    mul     $t7, $t2, 4
    add     $t7, $t8, $t7
    sw      $v0, 0($t7)

    j       for_loop
    addi    $t2, $t2, 1
loop_end:

    lw      $s4, 0($sp)
    lw      $s5, 4($sp)
    lw      $s6, 8($sp)

    add     $sp, $sp, 12

    jr      $ra
