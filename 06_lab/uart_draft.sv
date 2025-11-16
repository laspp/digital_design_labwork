module baud_rate_generator // General Purpose counter        
    #(parameter PRESCALER_WIDTH = 4,
      parameter LIMIT = 11)
    (
        input logic clock,
        input logic reset,
        output logic baud_rate_tick
    );

    logic [PRESCALER_WIDTH-1:0] count;

    // when the counter reaches the limit, the sample_tick signal is generated

    always_ff @(posedge clock) begin
        if(reset) begin
            count <= 0;
        end else begin
            if(count == LIMIT-1) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

    assign baud_rate_tick = (count == LIMIT-1);
endmodule

module uart_fsm #(
    parameter DATA_WIDTH = 8
) (
    input logic clock,
    input logic reset,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic baud_rate_tick,
    input logic tx_start,
    output logic tx,
    output logic tx_done,
    output logic baud_rst // used for baud rate generator reset
);


    

    // define the states
    typedef enum logic [1:0] { // binary encoding
        IDLE,
        START,
        DATA,
        STOP
    } state_uart_t;
    
 
    state_uart_t state, next_state;

    // signal declarations 
    logic [DATA_WIDTH-1:0] b_reg, b_reg_next;
    logic [3:0] n_counter, n_counter_next; // counter for number of symbols 
    logic tx_done_next, tx_reg, tx_reg_next;


    // state register
    always_ff @(posedge clock) begin
        if (reset) begin
            state <= IDLE;
            b_reg <= 0;
            n_counter <= 0;
            tx_done <= 0;
            tx_reg <= 1; // idle state state of the tx line
        end
        else begin
            state <= next_state;
            b_reg <= b_reg_next;
            n_counter <= n_counter_next;
            tx_done <= tx_done_next;
            tx_reg <= tx_reg_next;
        end
    end

    // state transition logic
    always_comb begin
        next_state = state;
        b_reg_next = b_reg;
        n_counter_next = n_counter;
        tx_done_next = 0;
        tx_reg_next = tx_reg;
        baud_rst = 1'b0;

        case (state)
            IDLE : begin
                tx_reg_next = 1'b1;
                if(tx_start) begin
                    next_state = START;
                    b_reg_next = data_in;
                    baud_rst = 1'b1;
                end
            end 
            START : begin
                tx_reg_next = 1'b0;
                if (baud_rate_tick) begin
                    next_state = DATA;
                    n_counter_next = 0;
                end
            end
            DATA : begin
                tx_reg_next = b_reg[0];
                if (baud_rate_tick) begin
                    if (n_counter == DATA_WIDTH-1) begin
                        next_state = STOP;
                    end
                    else begin
                        n_counter_next = n_counter + 1;
                        b_reg_next = {1'b0, b_reg[7:1]};
                    end
                end
            end
            STOP : begin
                tx_reg_next = 1'b1;
                if (baud_rate_tick) begin
                    begin
                        next_state = IDLE;
                        tx_done_next = 1'b1;
                    end
                end
            end
        endcase
    end

    assign tx = tx_reg;

endmodule

module transmitter_system(
    input logic clock,
    input logic reset,
    input logic tx_start,
    input logic [7:0] data_in,
    output logic tx,
    output logic tx_done
);

    logic baud_rate_tick;
    logic baud_rst;
    logic local_reset;

    
    assign local_reset = reset | baud_rst;

    baud_rate_generator #(
        .PRESCALER_WIDTH(15),
        .LIMIT(5209)
    ) baud_rate_generator_inst (
        .clock(clock),
        .reset(local_reset),
        .baud_rate_tick(baud_rate_tick)
    );

    uart_fsm #(
        .DATA_WIDTH(8)
    ) uart_fsm_inst (
        .clock(clock),
        .reset(reset),
        .data_in(data_in),
        .baud_rate_tick(baud_rate_tick),
        .tx_start(tx_start),
        .tx(tx),
        .tx_done(tx_done),
        .baud_rst(baud_rst)
    );


endmodule


module string_transmitter(
    input logic clock,
    input logic reset,
    input logic button,
    output logic tx,
    output logic done
);

    logic [7:0] char_data [13:0];

 // initalize array 
initial begin
    char_data[0] = 8'h48; // H
    char_data[1] = 8'h65; // e
    char_data[2] = 8'h6C; // l
    char_data[3] = 8'h6C; // l
    char_data[4] = 8'h6F; // o
    char_data[5] = 8'h20; // (space)
    char_data[6] = 8'h57; // W
    char_data[7] = 8'h6F; // o
    char_data[8] = 8'h72; // r
    char_data[9] = 8'h6C; // l
    char_data[10] = 8'h64; // d
    char_data[11] = 8'h21; // !
    char_data[12] = 8'h0D; // Carriage return
    char_data[13] = 8'h0A; // 
end

// state machine
typedef enum logic  { // binary encoding
        IDLE,
        SEND
} state_sender_t;

state_sender_t state, state_next;
logic [3:0] symbol_counter, symbol_counter_next;
logic tx_start, tx_start_next, tx_done;
logic [7:0] symbol, symbol_next;
logic [7:0] done_next;

always_ff @(posedge clock) begin
    if (reset) begin
        state <= IDLE;
        symbol_counter <= 0;
        tx_start <= 0;
        symbol <= 0;
        done <= 0;
    end
    else begin
        state <= state_next;
        symbol_counter <= symbol_counter_next;
        tx_start <= tx_start_next;
        symbol <= symbol_next;
        done <= done_next;
    end
end




endmodule