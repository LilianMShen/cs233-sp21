module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    wire [31:0] CycleCounterOut, InterruptCycleOut, AluOut;
    wire InterruptLineOut, zero, negative, TimerRead, TimerWrite, Acknowledge, InterruptLineReset;

    wire InterruptLineEnable = CycleCounterOut == InterruptCycleOut;
    wire eqOne = 32'hffff001c == address;
    wire eqTwo = 32'hffff006c == address;

    register CycleCounter(CycleCounterOut, AluOut, clock, 1'b1, reset);
    register #(32, 32'hffffffff) InterruptCycle(InterruptCycleOut, data, clock, TimerWrite, reset);
    register #(1) InterruptLine(InterruptLineOut, 1'b1, clock, InterruptLineEnable, InterruptLineReset);

    alu32 alu(AluOut, zero, negative, 3'b010, CycleCounterOut, 32'b1);

    tristate t(cycle, CycleCounterOut, TimerRead);

    or o1(TimerAddress, eqOne, eqTwo);
    or o2(InterruptLineReset, Acknowledge, reset);

    and a1(Acknowledge, eqOne, eqTwo);
    and a2(TimerRead, eqOne, MemRead);
    and a3(TimerWrite, eqOne, MemWrite);
endmodule
