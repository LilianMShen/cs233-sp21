`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire [31:0] decoderOut, userStatus;
    wire [29:0] m1Out;
    wire exceptionLevel, o1Out, o2Out, a1Out, a2Out, n1Out;

    wire [31:0] statusRegister = {16'b0, userStatus[15:8], 6'b0, exceptionLevel, userStatus[0]};
    wire [31:0] causeRegister = {16'b0, TimerInterrupt, 15'b0};

    decoder32 d(decoderOut, regnum, MTC0);

    mux2v #(30) m1(m1Out, wr_data[31:2], next_pc, TakenInterrupt);
    mux3v m2(rd_data, statusRegister, causeRegister, {EPC, 2'b0}, regnum);

    register userS(userStatus, wr_data, clock, decoderOut[12], reset);
    register #(1) exceptionL(exceptionLevel, 1'b1, clock, TakenInterrupt, o1Out);
    register #(30) EPCR(EPC, m1Out, clock, o2Out, reset);

    or o1(o1Out, reset, ERET); // Outputs to reset of exception register
    or o2(o2Out, decoderOut[14], TakenInterrupt); // Outputs to enable of EPC register

    and a1(a1Out, causeRegister[15], statusRegister[15]); // Goes into a3
    and a2(a2Out, n1Out, statusRegister[0]); // Goes into a3
    and a3(TakenInterrupt, a1Out, a2Out); // Outputs to TakenInterrupt

    not n1(n1Out, statusRegister[1]);

endmodule
