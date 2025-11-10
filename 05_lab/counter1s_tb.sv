`include "stopwatch.sv"

`timescale 1s / 1us


module tb_counter1s;

    // Declare testbench signals
    logic clock;
    logic reset;
    logic starts;
    logic [7:0] anode_assert;
    logic [6:0] segs;

    // Instantiate the stopwatch module
    counter1s uut (
        .clock(clock),
        .reset(reset),
        .start(starts),
        .anode_assert(anode_assert),
        .segs(segs)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize signals
        $dumpfile("tb_stopwatch.vcd");
        $dumpvars;

        reset = 1;
        starts = 0;

        // Apply reset
        #10;
        reset = 0;

        // Start counting
        #20;
        starts = 1;

        // Run simulation for 5 seconds
        #(50000000);
        $finish;
    end

    // Monitor outputs
    
endmodule