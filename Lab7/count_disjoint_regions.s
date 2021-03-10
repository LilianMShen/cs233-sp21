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
        jr      $ra
