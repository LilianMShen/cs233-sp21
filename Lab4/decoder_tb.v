module decoder_test;
    reg [5:0] opcode, funct;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

             opcode = `OP_OTHER0; funct = `OP0_ADD; // try addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // try subtraction
        // add more tests here!

        # 10 opcode = `OP_OTHER0; funct = `OP0_AND;
        # 10 opcode = `OP_OTHER0; funct = `OP0_OR;
        # 10 opcode = `OP_OTHER0; funct = `OP0_NOR;
        # 10 opcode = `OP_OTHER0; funct = `OP0_XOR;
        # 10 opcode = `OP_ADDI; funct = `OP0_SUB;
        # 10 opcode = `OP_ANDI; funct = `OP0_NOR;
        # 10 opcode = `OP_ORI; funct = `OP0_AND;
        # 10 opcode = `OP_XORI; funct = `OP0_OR;
        # 10 opcode = `OP_OTHER0; funct = 6'h00;

        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire [1:0] alu_src2; 
    wire       rd_src, writeenable, except;
    mips_decode decoder(rd_src, writeenable, alu_src2, alu_op, except,
                        opcode, funct);
endmodule // decoder_test
