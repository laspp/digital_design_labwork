// `timescale 1ns / 1ps
// `include "rgb_controller.sv" 

module rgb_controller_tb;

    // Declare testbench signals
    logic clock;
    logic reset;
    logic [5:0] SW;
    logic [2:0] RGB;

    // Instantiate the rgb_controller module
    rgb_controller uut (
        .clock(clock),
        .reset(reset),
        .SW(SW),
        .RGB(RGB)
    );

    integer i;
    // Parameters
    localparam CL = 10; // Clock period in ns

    // Clock generation
    initial begin
        clock = 0;
        forever #(CL/2) clock = ~clock; // 100 MHz clock
    end

    // Test sequence
    initial begin
        // $dumpfile("tb.vcd");
        // $dumpvars;
        // Initialize signals
        reset = 1;

        #(CL*2);
        reset = 0;

        for (i = 0; i < 32*3125; i=i+1) 
        begin
            SW = 6'b000001;
            #((CL)); 
        end

        for (i = 0; i < 32*3125; i=i+1) 
        begin
            SW = 6'b001000;
            #((CL)); 
        end
        
        for (i = 0; i < 32*3125; i=i+1) 
        begin
            SW = 6'b110000;
            #((CL)); 
        end

        for (i = 0; i < 32*3125; i=i+1) 
        begin
            SW = 6'b110110;
            #((CL)); 
        end

        // $finish;
    end

   

endmodule