module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_plus4_t, PC_target;
    wire [31:0]  inst, inst_t;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [2:0]   ALUOp_t;
	wire [4:0]   wr_regnum_t;
	
	// ALUOp_t, RegWrite_t, BEQ_t, ALUSrc_t, MemRead_t, MemWrite_t, MemToReg_t, RegDst_t
	wire [14:0]  de_pipeline_out;
	wire [2:0] 	 ALUOp 	  = de_pipeline_out[14:12];
	wire 		 RegWrite = de_pipeline_out[11];
	wire 		 BEQ 	  = de_pipeline_out[10];
	wire 		 ALUSrc   = de_pipeline_out[9];
	wire 		 MemRead  = de_pipeline_out[8];
	wire 		 MemWrite = de_pipeline_out[7];
	wire 		 MemToReg = de_pipeline_out[6];
	wire 		 RegDst   = de_pipeline_out[5];
	wire [4:0]   wr_regnum= de_pipeline_out[4:0];

    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd1_data_f, rd2_data, rd2_data_f, rd2_data_t, B_data, alu_out_data_t, alu_out_data, load_data, wr_data;


	assign n_stall = ~stall;
	assign flush = reset || PCSrc;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */n_stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4_t, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4_t, PC_target, PCSrc);
    assign PCSrc = BEQ_t & zero;
	
	register #(30, 30'd0) if_pipeline1(PC_plus4, PC_plus4_t, clk, n_stall, flush);
	register #(32, 32'd0) if_pipeline2(inst, inst_t, clk, n_stall, flush);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_t, PC[31:2]);

	//ALUop 3, 1, 1, 1, 1, 1, 1, 1, wr_regnum=5 = 15
    mips_decode decode(ALUOp_t, RegWrite_t, BEQ_t, ALUSrc_t, MemRead_t, MemWrite_t, MemToReg_t, RegDst_t,
                      opcode, funct);
	
					  

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data_f, rd2_data_f,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);

    mux2v #(32) imm_mux(B_data, rd2_data_t, imm, ALUSrc_t);
    alu32 alu(alu_out_data_t, zero, ALUOp_t, rd1_data, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data, rd2_data, MemRead, MemWrite, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
    mux2v #(5) rd_mux(wr_regnum_t, rt, rd, RegDst_t);
	
	register #(15, 32'b0) de_pipeline1(de_pipeline_out, {ALUOp_t, RegWrite_t, BEQ_t, ALUSrc_t, MemRead_t, MemWrite_t, MemToReg_t, RegDst_t, wr_regnum_t}, clk, 1'b1, stall);
	register #(32, 32'b0) de_pipeline2(alu_out_data, alu_out_data_t, clk, 1'b1, stall);
	register #(32, 32'b0) de_pipeline3(rd2_data, rd2_data_t, clk, 1'b1, stall);
	
	forwarding_unit fu(ForwardA, ForwardB, rs, rt, wr_regnum, RegWrite);
	
	mux2v #(32) fuA(rd1_data, rd1_data_f, alu_out_data, ForwardA);
	mux2v #(32) fuB(rd2_data_t, rd2_data_f, alu_out_data, ForwardB);
	
	hazard_unit hu(stall, rs, rt, wr_regnum, MemRead);
	
endmodule // pipelined_machine


module forwarding_unit(ForwardA, ForwardB, rs, rt, wr_regnum_MW, RegWrite_MW);
	input [4:0] rs, rt, wr_regnum_MW;
	input RegWrite_MW;
	output ForwardA, ForwardB;
	
	assign ForwardA = (rs == wr_regnum_MW) & RegWrite_MW & !(wr_regnum_MW == 5'b00000);
	assign ForwardB = (rt == wr_regnum_MW) & RegWrite_MW & !(wr_regnum_MW == 5'b00000);
	
endmodule // forwarding unit


module hazard_unit(stall, rs, rt, wr_regnum_MW, MemRead_MW);
    input [4:0] rs, rt, wr_regnum_MW;
    input MemRead_MW;
    output stall;

    assign stall = ((rs == wr_regnum_MW) || (rt == wr_regnum_MW)) & MemRead_MW & !(wr_regnum_MW == 5'b00000);
endmodule