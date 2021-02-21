// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] rs_data, rt_data, m2_out, a1_out, a2_out;
    wire [4:0] rd_data;
    wire [2:0] alu_op;
    wire [1:0] alu_src2;
    wire rd_src, writeenable, except, a1_overflow, a1_zero, a1_negative, a2_overflow, a2_zero, a2_negative;

    register #(32) PC_reg(PC, a2_out, clock, 1'b1, reset);

    instruction_memory im(inst, PC[31:2]);

    wire [15:0] immediate = inst[15:0];
    wire [31:0] signExtImm = $signed(immediate);
    wire [31:0] zeroExtImm = {16'b0, immediate};

    regfile rf (rs_data, rt_data, inst[25:21], inst[20:16], rd_data, a1_out, writeenable, clock, reset);

    /* add other modules */
    mux2v m1(rd_data, inst[15:11], inst[20:16], rd_src);

    mux3v m2(m2_out, rt_data, signExtImm, zeroExtImm, alu_src2);

    alu32 a1(a1_out, a1_overflow, a1_zero, a1_negative, rs_data, m2_out, alu_op);

    alu32 a2(a2_out, a2_overflow, a2_zero, a2_negative, PC, 32'b100, `ALU_ADD);

    mips_decode d1(rd_src, writeenable, alu_src2, alu_op, except, inst[31:26], inst[5:0]);

endmodule // arith_machine
