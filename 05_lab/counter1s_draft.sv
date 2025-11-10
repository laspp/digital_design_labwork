// Components for stopwatch
module timer_1s // General Purpose counter        
    #(parameter PRESCALER_WIDTH = 14,
      parameter LIMIT = 10000)
    (
        input logic clock,
        input logic reset,
        input start,
        output logic time_tick
    );

    // implement the counter that counts from 0 t0 LIMIT-1
    // the counter width is PRESCALER_WIDTH
    // when the counter reaches LIMIT, time_tick should be high for one clock cycle

endmodule



// Components for 7-segment display

module anode_assert (
    input logic clock, // 100 MHz
    input logic reset, 
    input logic clock_enable, // will be high every 0.002 seconds
    output logic [7:0] anode_select // 8-bit signal, look at  the image in section Nexys A7 and Seven segment display 
);

    // counter that counts from 0 to 7
    logic [2:0] count;

    // implemet the 3-bit counter which counts when clock_enable is high

    // assert anode_select
    assign anode_select = ~(1 << count);
    
endmodule


module value_to_digit(
    input logic [31:0] value,
    input logic [7:0] anode_select,
    output logic [3:0] digit
);
    
    // if anode_select is 0xFE, then digit is equal to value[3:0]
    // if anode_select is 0xFD, then digit is equal to value[7:4]
    // if anode_select is 0xFB, then digit is equal to value[11:8]
    // if anode_select is 0xF7, then digit is equal to value[15:12]
    // if anode_select is 0xEF, then digit is equal to value[19:16]
    // if anode_select is 0xDF, then digit is equal to value[23:20]
    // if anode_select is 0xBF, then digit is equal to value[27:24]
    // if anode_select is 0x7F, then digit is equal to value[31:28]
endmodule

// purely comb module 

module digit_to_segments (
    input logic [3:0] digit,
    output logic [6:0] segs
);
    // if digit is 0, then segs is 7'b1000000
    // if digit is 1, then segs is 7'b1111001
    // etc.

endmodule


module SevSegDisplay (
    input logic clock,
    input logic reset,
    input logic [3:0] digit1, // Least significant digit
    input logic [3:0] digit2, // Next digit
    input logic [3:0] digit3, // Next digit
    input logic [3:0] digit4,
    input logic [3:0] digit5,
    input logic [3:0] digit6,
    input logic [3:0] digit7,
    input logic [3:0] digit8, // Most significant digit
    output logic [7:0] anode_select,
    output logic [6:0] segs
);

    logic [31:0] digit;

    assign digit = {digit8, digit7, digit6, digit5, digit4, digit3, digit2, digit1};

endmodule


module counter1s (
    input logic clock,
    input logic reset,
    input logic start,
    output logic[7:0] anode_assert,
    output logic[6:0] segs
);

endmodule



