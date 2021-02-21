// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

    reg [2:0] alu_op_reg;
    reg [1:0] alu_src2_reg;
    reg rd_src_reg, writeenable_reg, except_reg;

    assign alu_op = alu_op_reg;
    assign alu_src2 = alu_src2_reg;
    assign rd_src = rd_src_reg;
    assign writeenable = writeenable_reg;
    assign except = except_reg;

    always@(opcode or funct)
    begin
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
    else
        begin
            writeenable_reg <= 0;
            except_reg <= 1;
        end;
    end
    
    

endmodule // mips_decode
