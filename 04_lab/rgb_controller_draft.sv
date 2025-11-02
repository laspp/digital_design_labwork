
module prescaler
    #(parameter PRESCALER_WIDTH = 8)
    (
        input logic clock,
        input logic reset,
        input logic [PRESCALER_WIDTH-1:0] limit,
        output logic pwm_tick
    );

endmodule


// PWM controller
module PWM_controller 
(
    input logic clock,
    input logic reset,
    input logic [1:0] SW,
    input logic pwm_tick,
    output logic PWM
);

   

endmodule


module rgb_controller (
    input logic clock,
    input logic reset,
    input logic [5:0] SW,
    output logic [2:0] RGB
);

// define parameters
localparam PRESCALER_WIDTH =  12;
localparam LIMIT = 3125;

// define the limit_value
logic [PRESCALER_WIDTH-1:0] limit_value;
assign limit_value = LIMIT;

// instantiate the prescaler 
// produces a 32 kHz clock


// instantiate the PWM controller for the red LED



// instantiate the PWM controller for the red LED


// instantiate the PWM controller for the red LED


endmodule