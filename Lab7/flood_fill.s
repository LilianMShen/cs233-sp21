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
## // Mark an empty region as visited on the canvas using flood fill algorithm.
## void flood_fill(int row, int col, unsigned char marker, Canvas* canvas) {
##     // Check the current position is valid.
##     if (row < 0 || col < 0 ||
##         row >= canvas->height || col >= canvas->width) {
##         return;
##     }
##     unsigned char curr = canvas->canvas[row][col];
##     if (curr != canvas->pattern && curr != marker) {
##         // Mark the current pos as visited.
##         canvas->canvas[row][col] = marker;
##         // Flood fill four neighbors.
##         flood_fill(row - 1, col, marker, canvas);
##         flood_fill(row, col + 1, marker, canvas);
##         flood_fill(row + 1, col, marker, canvas);
##         flood_fill(row, col - 1, marker, canvas);
##     }
## }

.globl flood_fill
flood_fill:
	lw      $t0, 0($a3)         # t0 = canvas->height
    lw      $t1, 4($a3)         # t1 = canvas->width

	blt		$a0, $0, base_case
	blt		$a1, $0, base_case
	bge		$a0, $t0, base_case
	bge		$a1, $t1, base_case
	j 		not_basecase

base_case:
	jr		$ra

not_basecase:
	sub     $sp, $sp, 12         # callee save

    sw      $s0, 0($sp)
    sw      $s1, 4($sp)
	sw		$ra, 8($sp)

    lw      $t4, 0($a3)         # t4 = height
    lw      $t5, 4($a3)         # t5 = width
	lbu     $t6, 8($a3)         # t6 = pattern
    lw      $t7, 12($a3)        # t7 = char** canvas

	mul 	$t0, $a0, 4			# row * 4
	add		$t0, $t0, $t7		# + memory address 
	lw		$t1, 0($t0)			# array of char (in a row)
	add		$t2, $a1, $t1		# col + row memory address
    lbu     $t3, 0($t2)			# loading the current pattern


	beq		$t3, $t6, already_marked
	beq		$t3, $a2, already_marked

	sb		$a2, 0($t2)			# canvas->canvas[row][col] = marker
	move	$s0, $a0
	move	$s1, $a1

	move	$a1, $s1
	sub		$a0, $s0, 1
	jal		flood_fill

	move 	$a0, $s0
	sub		$a1, $s1, 1
	jal		flood_fill

	move	$a1, $s1
	addi	$a0, $s0, 1
	jal		flood_fill
	
	move 	$a0, $s0
	addi	$a1, $s1, 1
	jal		flood_fill

already_marked:
    
    lw      $s0, 0($sp)
    lw      $s1, 4($sp)
	lw		$ra, 8($sp)

	add     $sp, $sp, 12         # callee save)

	jr 		$ra
