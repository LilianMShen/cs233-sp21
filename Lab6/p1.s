# /**
#  * Given a table of recipes and an inventory of items, this function
#  * will populate times_craftable with the number of times each recipe
#  * can be crafted.
#  *
#  * Note: When passing arrays as parameters, the register $a0 will hold the starting
#  * address of the array, not the contents of the array.
#  */

# void craftable_recipes(int inventory[5], int recipes[10][5], int times_craftable[10]) {
#     const int NUM_ITEMS = 5;
#     const int NUM_RECIPES = 10;

#     for (int recipe_idx = 0; recipe_idx < NUM_RECIPES; recipe_idx++) {
#         times_craftable[recipe_idx] = 0x7fffffff;  // Largest positive number
#         int assigned = 0;

#         for (int item_idx = 0; item_idx < NUM_ITEMS; item_idx++) {
#             if (recipes[recipe_idx][item_idx] > 0) {
#                 // If the item is not required for the recipe, skip it
#                 // Note: There is a div psuedoinstruction to do the division
#                 // The format is:
#                 //    div   $rd, $rs, $rt
#                 int times_item_req = inventory[item_idx] / recipes[recipe_idx][item_idx];
#                 if (times_item_req < times_craftable[recipe_idx]) {
#                     times_craftable[recipe_idx] = times_item_req;
#                     assigned = 1;
#                 }
#             }
#         }

#         if (assigned == 0) {
#             times_craftable[recipe_idx] = 0;
#         }
#     }
# }

# for indexing, array[row * NUM_COLUMNS + col]

.globl craftable_recipes
craftable_recipes:

    li      $t0, 5                  # NUM_ITEMS
    li      $t1, 10                 # NUM_RECIPES

    li      $t2, 0                  # recipe_idx = 0
    li      $t3, 0                  # current address

    add     $t4, $0, 2147483647     # largest positive number

loop_one:
    bge     $t2, $t1, one_end       # dont skip as long as recipe_idx is less than NUM_RECIPES
    
    mul     $t3, $t2, 4
    add     $t3, $t3, $a2
    sw      $t4, 0($t3)             # assigning times_craftable[recipe_idx] = 0x7fffffff

    li      $t5, 0                  # assigned = 0
    li      $t6, 0                  # item_idx = 0

loop_two:
    bge     $t6, $t0, two_end       # dont skip as long as item_idx is less than NUM_ITEMS

    mul     $t7, $t2, $t0           # row * NUM_COLUMNS (recipe_idx * NUM_ITEMS)
    add     $t7, $t7, $t6           # + col (+ item_idx)
    
    ble     $t7, $0, if_end

    mul     $t3, $t6, 4
    add     $t3, $t3, $a0           #memory address of inventory[item_idx]

    mul     $t7, $t7, 4
    add     $t7, $t7, $a1           # memory address of recipes[recipe_idx][item_idx]
    
    div     $t8, $t3, $t7

    mul     $t9, $t2, 4
    add     $t9, $t9, $a2

    bge     $t8, $t9, if_end        # nested if statement
    sw      $t8, 0($t9)
    addi    $t5, $0, 1

if_end:

    addi    $t6, $t6, 1

    j loop_two

two_end:

    addi    $t2, $t2, 1

    j loop_one

one_end: 

    jr      $ra