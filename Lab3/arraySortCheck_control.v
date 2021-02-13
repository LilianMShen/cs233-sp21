module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
    output sorted, done, load_input, load_index, select_index;
    input go, inversion_found, end_of_array, zero_length_array;
    input clock, reset;
    // State on whether algo is running
    reg loading, running, inversion_unsorted;

    // If an inversion is found or we reach the end of array, end
    // algorithm
    wire done_next = end_of_array | zero_length_array;
    // If reached end of array and no inversion was found, then sorted
    wire sorted_next = end_of_array & ~inversion_unsorted;

    wire inversion_unsorted_next = inversion_unsorted | inversion_found;
    wire loading_next = (~running & go);
    wire running_next = ((~go & loading) | ((running & ~end_of_array) & ~zero_length_array)) & ~done;

    wire load_input_next = loading | (running & ~load_input);
    wire load_index_next = loading | (running & load_input);
    wire select_index_next = running;

	// Do flip flop shit
	sdffe d1(sorted, sorted_next, clock, 1, reset);
	sdffe d2(done, done_next, clock, 1, reset);
	sdffe d3(load_input, load_input_next, clock, 1, reset);
	sdffe d4(load_index, load_index_next, clock, 1, reset);
	sdffe d5(select_index, select_index_next, clock, 1, reset);

    always@(posedge clock)
    begin
        // Manual flip flop bullshit
        if (reset == 1'b1)
        begin
            loading <= 0;
            running <= 0;
      inversion_unsorted <= 0;
        end
        else
        begin
            loading <= loading_next;
            running <= running_next;
      inversion_unsorted <= inversion_unsorted_next;
        end
    end

endmodule

// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module sdffe(q, d, clk, enable, reset);
	output q;
	reg    q;
	input  d;
	input  clk, enable, reset;

	always@(posedge clk)
	begin
   	if (reset == 1'b1)
    	q <= 0;
    if ((reset == 1'b0) && (enable == 1'b1))
    	q <= d;
	end
endmodule // dffe