# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c
GET_MAP                 = 0xffff2040

REQUEST_PUZZLE          = 0xffff00d0  ## Puzzle
SUBMIT_SOLUTION         = 0xffff00d4  ## Puzzle

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

REQUEST_PUZZLE_INT_MASK = 0x800       ## Puzzle
REQUEST_PUZZLE_ACK      = 0xffff00d8  ## Puzzle

RESPAWN_INT_MASK        = 0x2000      ## Respawn
RESPAWN_ACK             = 0xffff00f0  ## Respawn

GET_WOOD                = 0xffff2000
GET_STONE               = 0xffff2004
GET_WOOL                = 0xffff2008

CRAFT                   = 0xffff2024

BREAK_BLOCK             = 0xffff2020

GET_INVENTORY           = 0xffff2034

.data
### Puzzle
puzzle:     .byte 0:400
solution:   .byte 0:256
#### Puzzle

scanner_result: .byte 0 0 0

has_puzzle: .word 0

inv:    .word 0:8

has_bonked:    .byte 0
# -- string literals --
.text
main:
    sub $sp, $sp, 4
    sw  $ra, 0($sp)

    # Construct interrupt mask
    li      $t4, 0
    or      $t4, $t4, TIMER_INT_MASK            # enable timer interrupt
    or      $t4, $t4, BONK_INT_MASK             # enable bonk interrupt
    or      $t4, $t4, REQUEST_PUZZLE_INT_MASK   # enable puzzle interrupt
    or      $t4, $t4, 1 # global enable
    mtc0    $t4, $12
    
    li $t1, 0
    sw $t1, ANGLE
    li $t1, 1
    sw $t1, ANGLE_CONTROL
    li $t2, 0
    sw $t2, VELOCITY
        
    # YOUR CODE GOES HERE!!!!!!

    li      $t1, 90
    sw      $t1, ANGLE
    li      $t1, 1
    sw      $t1, ANGLE_CONTROL
    li      $t1, 10
    sw      $t1, VELOCITY

    li      $t2, 16
while_one:
    lw      $t1, BOT_Y
    bge     $t1, $t2, one_end
    j       while_one
one_end:

    li      $t1, 0
    sw      $t1, ANGLE
    li      $t1, 1
    sw      $t1, ANGLE_CONTROL

    li      $t2, 288
while_two:
    lw      $t1, BOT_X
    bge     $t1, $t2, two_end
    j       while_two
two_end:

    li      $t1, 0
    sw      $t1, VELOCITY

    li      $t1, 0x00002503
    sw      $t1, BREAK_BLOCK

    li      $t1, 90
    sw      $t1, ANGLE
    li      $t1, 1
    sw      $t1, ANGLE_CONTROL
    li      $t1, 10
    sw      $t1, VELOCITY

    li      $t2, 288
while_three:
    lw      $t1, BOT_Y
    bge     $t1, $t2, three_end
    j       while_three
three_end:

    li      $t1, 0
    sw      $t1, VELOCITY

    li      $t1, 0x00002425
    sw      $t1, BREAK_BLOCK

    li      $t1, 180
    sw      $t1, ANGLE
    li      $t1, 1
    sw      $t1, ANGLE_CONTROL
    li      $t1, 10
    sw      $t1, VELOCITY

    li      $t2, 56
while_four:
    lw      $t1, BOT_X
    blt     $t1, $t2, four_end
    j       while_four
four_end:

    li      $t1, 0
    sw      $t1, VELOCITY

    li      $t1, 0x00000524
    sw      $t1, BREAK_BLOCK

    li      $t1, 7
    sw      $t1, CRAFT

    la      $t1, puzzle
    sw      $t1, REQUEST_PUZZLE

puzzle_interrupt_wait:
    lw      $t1, has_puzzle
    bne     $t1, $0, puzzle_interrupt_received
    j       puzzle_interrupt_wait

puzzle_interrupt_received:

    la      $t1, puzzle
    add     $t2, $t1, 16
    move    $a0, $t2
    move    $a1, $t1

    la      $t1, solution
    add     $t2, $t1, 8
    sw      $t2, 4($a2)
    
    jal     count_disjoint_regions

    la      $t1, solution
    add     $t1, $t1, 8
    sw      $t1, SUBMIT_SOLUTION

    li      $t1, 7
    sw      $t1, CRAFT
    

loop_inf: # Once done, enter an infinite loop so that your bot can be graded by QtSpimbot once 10,000,000 cycles have elapsed
    j loop_inf
    
count_disjoint_regions:
        # Your code goes here :)
        sub     $sp, $sp, 20
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)

        move    $s0, $a0                # line
        move    $s1, $a1                # canvas
        move    $s2, $a2                # solution

        li      $s3, 0                  # unsigned int i = 0;
loop:
        lw	$t0, 0($s0)		# $t0 = lines->num_lines
        bge     $s3, $t0, end           # i < lines->num_lines : fallthrough
        
        #lines->coords[0][i];
        lw	$t1, 4($s0)		# $t1 = &(lines->coords[0][0])
        lw	$t2, 8($s0)		# $t2 = &(lines->coords[1][0])

        mul     $t3, $s3, 4             # i * sizeof(int*)
        add     $t1, $t3, $t1           # $t1 = &(lines->coords[0][i])
        add     $t2, $t3, $t2           # $t2 = &(lines->coords[1][i])

        lw      $a0, 0($t1)             # $a0 = lines->coords[0][i] = start_pos
        lw      $a1, 0($t2)             # $a1 = lines->coords[0][i] = end_pos
        move    $a2, $s1                # $a2 = canvas
        jal     draw_line               # draw_line(start_pos, end_pos, canvas);

        li      $a0, 65                 # Immediate value A
        rem     $t1, $s3, 2             # i % 2
        add     $a0, $a0, $t1           # 'A' or 'B'
        move    $a1, $s1
        jal     count_disjoint_regions_step  # count_disjoint_regions_step('A' + (i % 2), canvas);
        # $v0 = count_disjoint_regions_step('A' + (i % 2), canvas);

        lw      $t0, 4($s2)             # &counts = &counts[0]
        mul     $t1, $s3, 4             #  i * sizeof(unsigned int)
        add     $t0, $t1, $t0           # *counts[i]
        sw      $v0, 0($t0)

##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;


        add     $s3, $s3, 1             # i++
        j       loop
end:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        add     $sp, $sp, 20
        jr      $ra

count_disjoint_regions_step:
        # Your code goes here :)
        sub	$sp, $sp, 24
	sw	$ra, 0 ($sp)
	sw	$s0, 4 ($sp)                    # marker
        sw      $s1, 8 ($sp)                    # canvas
        sw      $s2, 12($sp)                    # region_count
        sw      $s3, 16($sp)                    # row
        sw      $s4, 20($sp)                    # col
	
        move    $s0, $a0
        move    $s1, $a1
	li	$s2, 0			        # unsigned int region_count = 0;
        
        
        li      $s3, 0                          # row = 0
outer_loop:                                     # for (unsigned int row = 0; row < canvas->height; row++) {
        lw      $t0, 0($s1)                     # canvas->height
        bge     $s3, $t0, end_outer_loop        # row < canvas->height : fallthrough

        li      $s4, 0                          # col = 0
inner_loop:                                     # for (unsigned int col = 0; col < canvas->width; col++) {
        lw      $t0, 4($s1)                     # canvas->width
        bge     $s4, $t0, end_inner_loop        # col < canvas->width : fallthrough

        
        # unsigned char curr_char = canvas->canvas[row][col];
        lw      $t1, 12($s1)                    # &(canvas->canvas)
        mul     $t2, $s3, 4                     # $t2 = row * 4
        add     $t2, $t2, $t1                   # $t2 = canvas->canvas + row * sizeof(char*) = canvas[row]
        lw	$t1, 0($t2)		        # $t1 = &char = char* = & canvas[row][0]
        add	$t1, $s4, $t1           	# $t1 = &canvas[row][col]
        lb	$t1, 0($t1)		        # $t1 = canvas[row][col] = curr_char

        lb      $t2, 8($s1)                     # $t2 = canvas->pattern 

        # temps:        $t1 = curr_char         $t2 = canvas->pattern

        # if (curr_char != canvas->pattern && curr_char != marker) {
        beq     $t1, $t2, endif                 # if (curr_char != canvas->pattern) fall
        beq	$t1, $s0, endif                 # if (curr_char != marker)          fall
        
        add     $s2, $s2, 1                     # region_count ++;
        move    $a0, $s3                        # (row,
        move    $a1, $s4                        #  col,
        move    $a2, $s0                        #  marker,
        move    $a3, $s1                        #  canvas);
        jal     flood_fill                      # flood_fill(row, col, marker, canvas);
 
endif:


        add     $s4, $s4, 1                     # col++
        j       inner_loop                      # loop again
end_inner_loop:


        add     $s3, $s3, 1                     # row++
        j       outer_loop                      # loop again
end_outer_loop:

	move	$v0, $s2		# Copy return val
	lw	$ra, 0($sp)
	lw	$s0, 4 ($sp)                    # marker
        lw      $s1, 8 ($sp)                    # canvas
        lw      $s2, 12($sp)                    # region_count
        lw      $s3, 16($sp)                    # row
        lw      $s4, 20($sp)                    # col

	add	$sp, $sp, 24
	jr      $ra


draw_line:
        lw      $t0, 4($a2)     # t0 = width = canvas->width
        li      $t1, 1          # t1 = step_size = 1
        sub     $t2, $a1, $a0   # t2 = end_pos - start_pos
        blt     $t2, $t0, cont
        move    $t1, $t0        # step_size = width;
cont:
        move    $t3, $a0        # t3 = pos = start_pos
        add     $t4, $a1, $t1   # t4 = end_pos + step_size
        lw      $t5, 12($a2)    # t5 = &canvas->canvas
        lbu     $t6, 8($a2)     # t6 = canvas->pattern
for_loop:
        beq     $t3, $t4, end_for
        div     $t3, $t0        #
        mfhi    $t7             # t7 = pos % width
        mflo    $t8             # t8 = pos / width
        mul     $t9, $t8, 4		# t9 = pos/width*4
        add     $t9, $t9, $t5   # t9 = &canvas->canvas[pos / width]
        lw      $t9, 0($t9)     # t9 = canvas->canvas[pos / width]
        add     $t9, $t9, $t7
        sb      $t6, 0($t9)     # canvas->canvas[pos / width][pos % width] = canvas->pattern
        add     $t3, $t3, $t1   # pos += step_size
        j       for_loop
        
end_for:
        jr      $ra

flood_fill:
        # Your code goes here :)
	blt	$a0, $zero, end_ff		# row < 0 
	blt	$a1, $zero, end_ff		# col < 0
	lw	$t0, 0($a3)		# $t0 = canvas->height
	bge	$a0, $t0, end_ff		# row >= canvas->height
	lw	$t0, 4($a3)		# $t0 = canvas->width
	bge	$a1, $t0, end_ff		# col >= canvas->width
	j 	recur			# NONE TRUE

recur:
	# Find curr
	lw	$t0, 12($a3)		# canvas->canvas
	mul	$t1, $a0, 4		# row * sizeof(char*)
	add	$t1, $t1, $t0		# $t1 = canvas->canvas + row * sizeof(char*) = canvas[row]
	lw	$t2, 0($t1)		# $t2 = &char = char* = & canvas[row][0]
	add	$t2, $a1, $t2		# $t2 = &canvas[row][col]
	lb	$t3, 0($t2)		# $t3 = curr
	
	lb	$t4, 8($a3)		# $t4 = canvas->pattern
	
	beq	$t3, $t4, end_ff		# curr == canvas->pattern : break 
	beq	$t3, $a2, end_ff		# curr == marker          : break
	
	#FLOODFILL
	sb	$a2, ($t2) 
	
	# Save depenedecies
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	move	$s0, $a0
	move	$s1, $a1
	
	sub	$a0, $s0, 1
	move	$a1, $s1
	jal	flood_fill

	move	$a0, $s0
	add	$a1, $s1, 1
	jal	flood_fill

	add	$a0, $s0, 1
	move	$a1, $s1
	jal	flood_fill

	move	$a0, $s0
	sub	$a1, $s1, 1
	jal	flood_fill
	
	# Restore VARS
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
end_ff:
	jr 	$ra


.kdata
chunkIH:    .space 40
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
    move    $k1, $at        # Save $at
                            # NOTE: Don't touch $k1 or else you destroy $at!
.set at
    la      $k0, chunkIH
    sw      $a0, 0($k0)        # Get some free registers
    sw      $v0, 4($k0)        # by storing them to a global variable
    sw      $t0, 8($k0)
    sw      $t1, 12($k0)
    sw      $t2, 16($k0)
    sw      $t3, 20($k0)
    sw      $t4, 24($k0)
    sw      $t5, 28($k0)

    # Save coprocessor1 registers!
    # If you don't do this and you decide to use division or multiplication
    #   in your main code, and interrupt handler code, you get WEIRD bugs.
    mfhi    $t0
    sw      $t0, 32($k0)
    mflo    $t0
    sw      $t0, 36($k0)

    mfc0    $k0, $13                # Get Cause register
    srl     $a0, $k0, 2
    and     $a0, $a0, 0xf           # ExcCode field
    bne     $a0, 0, non_intrpt



interrupt_dispatch:                 # Interrupt:
    mfc0    $k0, $13                # Get Cause register, again
    beq     $k0, 0, done            # handled all outstanding interrupts

    and     $a0, $k0, BONK_INT_MASK     # is there a bonk interrupt?
    bne     $a0, 0, bonk_interrupt

    and     $a0, $k0, TIMER_INT_MASK    # is there a timer interrupt?
    bne     $a0, 0, timer_interrupt

    and     $a0, $k0, REQUEST_PUZZLE_INT_MASK
    bne     $a0, 0, request_puzzle_interrupt

    and     $a0, $k0, RESPAWN_INT_MASK
    bne     $a0, 0, respawn_interrupt

    li      $v0, PRINT_STRING       # Unhandled interrupt types
    la      $a0, unhandled_str
    syscall
    j       done

bonk_interrupt:
    sw      $0, BONK_ACK
    la      $t0, has_bonked
    li      $t1, 1
    sb      $t1, 0($t0)
    #Fill in your bonk handler code here
    j       interrupt_dispatch      # see if other interrupts are waiting

timer_interrupt:
    sw      $0, TIMER_ACK
    li $s7, 1
    j        interrupt_dispatch     # see if other interrupts are waiting

request_puzzle_interrupt:
    sw      $0, REQUEST_PUZZLE_ACK
    #Fill in your puzzle interrupt code here
    li      $t1, 1
    sw      $t1, has_puzzle
    j       interrupt_dispatch

respawn_interrupt:
    sw      $0, RESPAWN_ACK
    #Fill in your respawn handler code here
    j       interrupt_dispatch

non_intrpt:                         # was some non-interrupt
    li      $v0, PRINT_STRING
    la      $a0, non_intrpt_str
    syscall                         # print out an error message
    # fall through to done

done:
    la      $k0, chunkIH

    # Restore coprocessor1 registers!
    # If you don't do this and you decide to use division or multiplication
    #   in your main code, and interrupt handler code, you get WEIRD bugs.
    lw      $t0, 32($k0)
    mthi    $t0
    lw      $t0, 36($k0)
    mtlo    $t0

    lw      $a0, 0($k0)             # Restore saved registers
    lw      $v0, 4($k0)
    lw      $t0, 8($k0)
    lw      $t1, 12($k0)
    lw      $t2, 16($k0)
    lw      $t3, 20($k0)
    lw      $t4, 24($k0)
    lw      $t5, 28($k0)

.set noat
    move    $at, $k1        # Restore $at
.set at
    eret
