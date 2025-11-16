
`include "student_v2.sv"
`timescale 1ns / 1ps

module uart_system_transmitter_tb;

    // Declare testbench signals
    logic clock;
    logic reset;
    logic [7:0] wr_data;
    logic tx;
    logic tx_done;
    logic tx_start;

    // Instantiate the uart_system_transmitter module
    transmitter_system uut (
        .clock(clock),
        .reset(reset),
        .data_in(wr_data),
        .tx(tx),
        .tx_done(tx_done),
        .tx_start(tx_start)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 100 MHz clock
    end

    // Test sequence
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
        // Initialize signals
        reset = 1;
        wr_data = 8'b0;
        tx_start = 0;

        // Apply reset
        #10;
        reset = 0;

        // Test case 1: Transmit data 0x55
        #(10*326);
        wr_data = 8'h55;
        tx_start = 1;
        #10;
        tx_start = 0;

        // Wait for transmission to complete
        wait(tx_done);

        #10;
        // Test case 2: Transmit data 0xAA
        #(20);
        wr_data = 8'hAA;
        tx_start = 1;
        #10;
        tx_start = 0;

        // Wait for transmission to complete
        wait(tx_done);

        // Finish simulation
        #100;   

        reset = 1;
        #(10*326);
        $finish;
    end

    

endmodule