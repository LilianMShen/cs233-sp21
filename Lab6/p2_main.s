.data
map1:
.word 1 2 3 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 4 5 6 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 7 8 9 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
pattern1:
.word 1 2 3 1 1 
.word 4 5 6 1 1 
.word 7 8 9 1 1 
.word 1 1 1 1 1 
.word 1 1 1 1 1 

map2:
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
pattern2:
.word 1 2 3 1 1 
.word 4 5 6 1 1 
.word 7 8 9 1 1 
.word 1 1 1 1 1 
.word 1 1 1 1 1 

map3:
.word 1 2 3 1 1 0 0 0 0 0 0 0 0 0 0 0 
.word 4 5 6 1 1 0 0 0 0 0 0 0 0 0 0 0 
.word 7 8 9 1 1 0 0 0 0 0 0 0 0 0 0 0 
.word 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 
.word 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 
.word 0 0 0 0 0 7 8 9 8 7 0 0 0 0 0 0 
.word 0 0 0 0 0 7 8 9 8 7 0 0 0 0 0 0 
.word 0 0 0 0 0 9 9 9 9 9 0 0 0 0 0 0 
.word 0 0 0 0 0 9 9 9 9 9 0 0 0 0 0 0 
.word 0 0 0 0 0 9 9 9 9 7 8 9 8 7 0 0 
.word 0 0 0 0 0 0 0 0 0 7 7 8 7 7 0 0 
.word 0 0 0 0 0 0 0 0 0 0 0 7 8 9 8 7 
.word 0 0 0 0 0 0 0 0 0 0 0 7 7 8 7 7 
.word 0 0 0 0 0 0 0 0 0 0 0 7 7 7 7 7 
.word 0 0 0 0 0 0 0 0 0 0 0 7 7 8 7 7 
.word 0 0 0 0 0 0 0 0 0 0 0 7 8 9 8 7 
pattern3:
.word 7 8 9 8 7 
.word 7 7 8 7 7 
.word 7 7 7 7 7 
.word 7 7 8 7 7 
.word 7 8 9 8 7 

.text
main:
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)

        # Pattern match tests
        # Expected Result:
        #   0
        li      $a0, 0
        la      $a1, pattern1
        la      $a2, map1
        jal     pattern_match

        move    $a0, $v0
        li      $v0, 1
        syscall

        li      $a0, '\n'
        li      $v0, 11
        syscall

        # Expected Result:
        #   -1
        li      $a0, 0
        la      $a1, pattern2
        la      $a2, map2
        jal     pattern_match

        move    $a0, $v0
        li      $v0, 1
        syscall

        li      $a0, '\n'
        li      $v0, 11
        syscall

        # Expected Result:
        #   589833
        li      $a0, 9
        la      $a1, pattern3
        la      $a2, map3
        jal     pattern_match

        move    $a0, $v0
        li      $v0, 1
        syscall


        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra
        