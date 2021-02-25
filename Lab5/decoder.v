// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    reg [2:0] alu_op_reg;
    reg [1:0] alu_src2_reg, control_type_reg;
    reg rd_src_reg, writeenable_reg, except_reg, mem_read_reg, word_we_reg, byte_we_reg, byte_load_reg, lui_reg, slt_reg;

    assign alu_op = alu_op_reg;
    assign alu_src2 = alu_src2_reg;
    assign rd_src = rd_src_reg;
    assign writeenable = writeenable_reg;
    assign except = except_reg;
    assign control_type = control_type_reg;
    assign mem_read = mem_read_reg;
    assign word_we = word_we_reg;
    assign byte_we = byte_we_reg;
    assign byte_load = byte_load_reg;
    assign lui = lui_reg;
    assign slt = slt_reg;
    
    always@(opcode or funct)
    begin

    control_type_reg <= 00;
    mem_read_reg <= 0;
    word_we_reg <= 0;
    byte_we_reg <= 0;
    byte_load_reg <= 0;
    lui_reg <= 0;
    slt_reg <= 0;

    if (opcode == `OP_OTHER0 & funct == `OP0_ADD)
        begin
            alu_op_reg <= 010;
            rd_src_reg <= 0;
            alu_src2_reg <= 00;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_OTHER0 & funct == `OP0_SUB)
        begin
            alu_op_reg <= 011;
            rd_src_reg <= 0;
            alu_src2_reg <= 00;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_OTHER0 & funct == `OP0_AND)
        begin
            alu_op_reg <= 100;
            rd_src_reg <= 0;
            alu_src2_reg <= 00;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_OTHER0 & funct == `OP0_OR)
        begin
            alu_op_reg <= 101;
            rd_src_reg <= 0;
            alu_src2_reg <= 00;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_OTHER0 & funct == `OP0_NOR)
        begin
            alu_op_reg <= 110;
            rd_src_reg <= 0;
            alu_src2_reg <= 00;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_OTHER0 & funct == `OP0_XOR)
        begin
            alu_op_reg <= 111;
            rd_src_reg <= 0;
            alu_src2_reg <= 00;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_ADDI)
        begin
            alu_op_reg <= 010;
            rd_src_reg <= 1;
            alu_src2_reg <= 01;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_ANDI)
        begin
            alu_op_reg <= 100;
            rd_src_reg <= 1;
            alu_src2_reg <= 10;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_ORI)
        begin
            alu_op_reg <= 101;
            rd_src_reg <= 1;
            alu_src2_reg <= 10;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_XORI)
        begin
            alu_op_reg <= 111;
            rd_src_reg <= 1;
            alu_src2_reg <= 10;
            writeenable_reg <= 1;
            except_reg <= 0;
        end
    else if (opcode == `OP_BEQ)
        begin
            if (zero)
            begin
                control_type_reg <= 01;
            end
            else
            begin
                control_type_reg <= 00;
            end
            alu_op_reg <= -11;
            rd_src_reg <= 1;
            alu_src2_reg <= 00;
            writeenable_reg <= 0;
            except_reg <= 0;
        end
    else if (opcode == `OP_BNE)
        begin
            if (zero)
            begin
                control_type_reg <= 00;
            end
            else
            begin
                control_type_reg <= 01;
            end
            alu_op_reg <= 011;
            rd_src_reg <= 1;
            alu_src2_reg <= 00;
            writeenable_reg <= 0;
            except_reg <= 0;
        end
    else if (opcode == `OP_J)
        begin
            writeenable_reg <= 0;
            except_reg <= 0;
            control_type_reg <= 10;
        end
    else if (opcode == `OP_OTHER0 & funct == `OP0_JR)
        begin
            writeenable_reg <= 0;
            except_reg <= 0;
            control_type_reg <= 11;
        end
    else if (opcode == `OP_LUI)
        begin
            rd_src_reg <= 1;
            writeenable_reg <= 1;
            except_reg <= 0;
            lui_reg <= 1;
        end
    else if (opcode == `OP_OTHER0 & funct == `OP0_SLT)
        begin
            alu_op_reg <= 011;
            rd_src_reg <= 0;
            writeenable_reg <= 1;
            alu_src2_reg <= 00;
            except_reg <= 0;
            slt_reg <= 1;
        end
    else if (opcode == `OP_LW)
        begin
            alu_op_reg <= 010;
            rd_src_reg <= 1;
            writeenable_reg <= 1;
            alu_src2_reg <= 01;
            except_reg <= 0;
            mem_read_reg <= 1;
        end
    else if (opcode == `OP_LBU)
        begin
            alu_op_reg <= 010;
            rd_src_reg <= 1;
            writeenable_reg <= 1;
            alu_src2_reg <= 01;
            except_reg <= 0;
            mem_read_reg <= 1;
            byte_load_reg <= 1;
        end
    else if (opcode == `OP_SW)
        begin
            alu_op_reg <= 010;
            rd_src_reg <= 1;
            writeenable_reg <= 0;
            alu_src2_reg <= 01;
            except_reg <= 0;
            word_we_reg <= 1;
        end
    else if (opcode == `OP_SB)
        begin
            alu_op_reg <= 010;
            rd_src_reg <= 1;
            writeenable_reg <= 0;
            alu_src2_reg <= 01;
            except_reg <= 0;
            byte_we_reg <= 1;
        end
    else if (opcode == `OP_OTHER0 & funct == 6'h2c)
        begin
            alu_op_reg <= 010;
            rd_src_reg <= 0;
            writeenable_reg <= 1;
            alu_src2_reg <= 00;
            except_reg <= 0;
            mem_read_reg <= 1;
        end
    else
        begin
            writeenable_reg <= 0;
            except_reg <= 1;
        end;
    end
    

endmodule // mips_decode
