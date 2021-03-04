.data

inventory1:
.word 6 6 3 0 0 
recipes1:
.word 3 3 0 0 0 
.word 2 0 2 0 0 
.word 0 0 0 0 0 
.word 0 0 0 0 0 
.word 0 0 0 0 0 
.word 0 0 0 0 0 
.word 0 0 0 0 0 
.word 0 0 0 0 0 
.word 0 0 0 0 0 
.word 0 0 0 0 0 
times_craftable1:
.space  40

inventory2:
.word 1 2 3 4 5 
recipes2:
.word 0 0 0 0 0 
.word 1 2 3 4 5 
.word 2 4 6 8 10 
.word 3 6 9 12 15 
.word 4 8 12 16 20 
.word 5 10 15 20 25 
.word 6 12 18 24 30 
.word 7 14 21 28 35 
.word 8 16 24 32 40 
.word 9 18 27 36 45
times_craftable2:
.space  40

inventory3:
.word 9 18 27 36 45 
recipes3:
.word 1 0 0 0 1 
.word 1 0 3 5 5 
.word 2 4 7 6 10 
.word 3 7 9 12 15 
.word 3 8 12 16 21 
.word 5 10 13 21 25 
.word 6 12 19 24 28 
.word 7 15 21 28 35 
.word 9 14 24 32 41 
.word 9 18 27 35 45 
times_craftable3:
.space  40

.text

# print_mat:
#         li      $t0, 0          # Loop index
#         move    $t1, $a0        # Array pointer

# loop:
#         bge     $t0, 50, loop_end

#         # Print current int
#         li      $v0, 1
#         lw      $a0, 0($t1)
#         syscall
#         li      $v0, 11
#         li      $a0, ' '
#         syscall

#         add     $t1, $t1, 4     # Next int
#         add     $t0, $t0, 1     # Next index

#         rem     $t2, $t0, 5
#         bne     $t2, $zero, loop
#         li      $v0, 11
#         li      $a0, ' '
#         syscall

#         j       loop

# loop_end:
#         li      $v0, 11
#         li      $a0, '\n'
#         syscall
#         jr      $ra

print_array:
        li      $t0, 0          # Loop index
        move    $t1, $a0        # Array pointer

loop:
        bge     $t0, 10, loop_end

        # Print current int
        li      $v0, 1
        lw      $a0, ($t1)
        syscall
        li      $v0, 11
        li      $a0, ' '
        syscall

        add     $t1, $t1, 4     # Next int
        add     $t0, $t0, 1     # Next index

        j       loop

loop_end:
        li      $v0, 11
        li      $a0, '\n'
        syscall
        jr      $ra


main:
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)

        # Craftable recipes tests
        # Expected Result:
        #   2 1 0 0 0 0 0 0 0 0
        la      $a0, inventory1
        la      $a1, recipes1
        la      $a2, times_craftable1
        jal     craftable_recipes

        la      $a0, times_craftable1
        jal     print_array

        # Expected Result:
        #   0 1 0 0 0 0 0 0 0 0
        la      $a0, inventory2
        la      $a1, recipes2
        la      $a2, times_craftable2
        jal     craftable_recipes

        la      $a0, times_craftable2
        jal     print_array

        # Expected Result:
        #   9 7 3 2 2 1 1 1 1 1
        la      $a0, inventory3
        la      $a1, recipes3
        la      $a2, times_craftable3
        jal     craftable_recipes

        la      $a0, times_craftable3
        jal     print_array

        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra
        





