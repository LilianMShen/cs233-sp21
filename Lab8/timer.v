module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    wire [31:0] CycleCounterOut, InterruptCycleOut, AluOut;
    wire InterruptLineOut, zero, negative, TimerRead, TimerWrite, Acknowledge;

    register CycleCounter(CycleCounterOut, AluOUt, clock, 1'b1, reset);
    register #(width = 32, reset_value = 32'hffffffff) InterruptCycle(InterruptCycleOut, data, clock, TimerWrite, reset);
    register #(1) InterruptLine(InterruptLineOut, 1'b1, clock, InterruptLineEnable, InterruptLineReset);

    alu32 alu(AluOut, zero, negative, 3'b010, CycleCounterOut, 32'b1);

    tristate tri(cycle, CycleCounterOut, TimerRead);

    wire InterruptLineEnable = CycleCounterOut == InterruptCycleOut;
    wire eqOne = 32'hffff001c == address;
    wire eqTwo = 32'hffff006c == address;

    or o1(TimerAddress, eqOne, eqTwo);
    or o2(InteruptLineReset, Acknowledge, reset);

    and a1(Acknowledge, eqOne, eqTwo);
    and a2(TimerRead, eqOne, MemRead);
    and a3(TimeWrite, eqOne, MemWrite);
endmodule