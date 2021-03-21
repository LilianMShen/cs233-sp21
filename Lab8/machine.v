module machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0]  inst;

   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];

   wire [4:0]   wr_regnum;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, memRTemp, memWTemp, RegDst, MFC0, MTC0, ERET;
   wire         PCSrc, zero, negative;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

   //Your extra wires go here
   wire TimerInterrupt, TakenInterrupt, TimerAddress, NotIO;
   wire [31:0] c0rdData, m3Out;
   wire [29:0] EPC, m1Out, m2Out;
   wire [31:0] m2In = 32'b10000000000000000000000110000000;

   register #(30, 30'h100000) PC_reg(PC[31:2], m2Out, clk, /* enable */1'b1, reset);
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;

   instruction_memory imem (inst, PC[31:2]);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET,
                      inst);

   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, m3Out,
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
   alu32 alu(alu_out_data, zero, negative, ALUOp, rd1_data, B_data);

   data_mem data_memory(load_data, alu_out_data, rd2_data, memRTemp, memWTemp, clk, reset);

   mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
   mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);
   
   //Connect your new modules below
   cp0 c1(c0rdData, EPC, TakenInterrupt, rd2_data, wr_regnum, next_PC, MTC0, ERET, TimerInterrupt, clk, reset);
   timer t1(TimerInterrupt, load_data, TimerAddress, rd2_data, alu_out_data, memRTemp, memWTemp, clk, reset);

   mux2v #(30) m1(m1Out, next_PC, EPC, ERET);
   mux2v #(30) m2(m2Out, m1Out, m2In[31:2], TakenInterrupt);
   mux2v m3(m3Out, wr_data, c0rdData, MFC0);

   not n1(NotIO, TimerAddress);
   and a1(memRTemp, MemRead, NotIO);
   and a2(memWTemp, MemWrite, NotIO);

endmodule // machine
