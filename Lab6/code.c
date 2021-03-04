/**
 * Given a table of recipes and an inventory of items, this function
 * will populate times_craftable with the number of times each recipe
 * can be crafted.
 *
 * Note: When passing arrays as parameters, the register $a0 will hold the starting
 * address of the array, not the contents of the array.
 */

void craftable_recipes(int inventory[5], int recipes[10][5], int times_craftable[10]) {
    const int NUM_ITEMS = 5;
    const int NUM_RECIPES = 10;

    for (int recipe_idx = 0; recipe_idx < NUM_RECIPES; recipe_idx++) {
        times_craftable[recipe_idx] = 0x7fffffff;  // Largest positive number
        int assigned = 0;

        for (int item_idx = 0; item_idx < NUM_ITEMS; item_idx++) {
            if (recipes[recipe_idx][item_idx] > 0) {
                // If the item is not required for the recipe, skip it
                // Note: There is a div psuedoinstruction to do the division
                // The format is:
                //    div   $rd, $rs, $rt
                int times_item_req = inventory[item_idx] / recipes[recipe_idx][item_idx];
                if (times_item_req < times_craftable[recipe_idx]) {
                    times_craftable[recipe_idx] = times_item_req;
                    assigned = 1;
                }
            }
        }

        if (assigned == 0) {
            times_craftable[recipe_idx] = 0;
        }
    }
}

/**
 * This function matches a 5x5 pattern across the map using 2D convolution.
 * If the correlation between the pattern and a 5x5 patch of the map is above the
 * given threshold, then the left hand corner of the patch will be returned.
 * If no match was found, then -1 is returned.
 */
int pattern_match(int threshold, int pattern[5][5], int map[16][16]) {
    const int PATTERN_SIZE = 5;
    const int EDGE = 16 - 5 + 1;

    for (int row = 0; row < EDGE; row++) {
        for (int col = 0; col < EDGE; col++) {
            int sum = 0;
            for (int pat_row = 0; pat_row < PATTERN_SIZE; pat_row++) {
                for (int pat_col = 0; pat_col < PATTERN_SIZE; pat_col++) {
                    if (pattern[pat_row][pat_col] == map[row + pat_row][col + pat_col]) {
                        sum += 1;
                    }
                    if (sum > threshold) {
                        return (row << 16) | col;
                    }
                }
            }
        }
    }
    return -1;
}

