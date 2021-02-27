// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
    wire [31:0] rs_data, rt_data, m2_out, a1_out, a2_out, a3_out, control_out, lui_out, mem_read_out,
       slt_out, byte_load_out, data_mem_out;
    wire [29:0] control_input_two;
    wire [7:0] byte_select_out;
    wire [4:0] rd_data;
    wire [2:0] alu_op;
    wire [1:0] alu_src2, control_type;
    wire rd_src, writeenable, except, a1_overflow, a1_zero, a1_negative, a2_overflow, a2_zero, 
      a2_negative, a3_overflow, a3_zero, a3_negative, lui, slt, byte_load, 
      mem_read, word_we, byte_we, addm;

    register #(32) PC_reg(PC, control_out, clock, 1'b1, reset);

    instruction_memory im(inst, PC[31:2]);

    wire [15:0] immediate = inst[15:0];
    wire [31:0] signExtImm = $signed(immediate);
    wire [31:0] zeroExtImm = {16'b0, immediate};
    wire [31:0] shiftImm = {signExtImm[29:0], 2'b00};

    regfile rf (rs_data, rt_data, inst[25:21], inst[20:16], rd_data, lui_out, writeenable, clock, reset);

    // One going into W_addr
    mux2v #(5) m1(rd_data, inst[15:11], inst[20:16], rd_src);

    // Outputs into alu_op 
    mux3v m2(m2_out, rt_data, signExtImm, zeroExtImm, alu_src2);

    // lui mux2v
    mux2v m3(lui_out, mem_read_out, {immediate, 16'b0}, lui);

    // slt mux2v
    mux2v m4(slt_out, a1_out, {31'b0, a1_negative}, slt);

    assign control_input_two = {a2_out[31:28], inst[25:0]};

    // controltype mux4v
    mux4v m5(control_out, a2_out, a3_out, {control_input_two, 2'b00}, rs_data, control_type);

    // mem_read mux2v
    mux2v m6(mem_read_out, slt_out, byte_load_out, mem_read);

    // byte_load mux2v
    mux2v m7(byte_load_out, data_mem_out, {24'b0, byte_select_out}, byte_load);

    // byte selection mux4v
    mux4v #(8) m8(byte_select_out, data_mem_out[7:0], data_mem_out[15:8], data_mem_out[23:16], data_mem_out[31:24], a1_out[1:0]);

    // data memory
    data_mem dm1(data_mem_out, a1_out, rt_data, word_we, byte_we, clock, reset);

    // Alu coming out of register file
    alu32 a1(a1_out, a1_overflow, a1_zero, a1_negative, rs_data, m2_out, alu_op);

    // PC alu1
    alu32 a2(a2_out, a2_overflow, a2_zero, a2_negative, PC, 32'b100, `ALU_ADD);

    // alu coming out of of pc alu
    alu32 a3(a3_out, a3_overflow, a3_zero, a3_negative, a2_out, shiftImm, `ALU_ADD);

    // Decoder
    mips_decode d1(alu_op, writeenable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, inst[31:26], inst[5:0], a1_zero);

endmodule // full_machine
