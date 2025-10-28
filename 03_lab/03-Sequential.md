# Third exercise: Designing sequential circuits with SystemVerilog 

Vivado recognizes certain idioms and transforms them into specific sequential circuits. Other coding styles may simulate correctly but may synthesize into circuits with obvious or subtle errors. We will present the proper idioms to describe registers and latches.

## Designing D Flip-Flop in SystemVerilog 

The Verilog code for a D flip-flop (DFF) active on the positive clock edge with a synchronous reset is given below:

```verilog
module DFF (
    input logic clk,
    input logic reset,
    input logic d,
    output logic q
);
    always_ff @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule
```

The `always_ff` has it roots from Verilog language. In Verilog we have `always` statement, written in form: 

```verilog
always @(sensitivity_list)
    statement;
```

In the previous code, the statement is executed only when the event specified in the sensitivity list occurs. For the D-FF example, the event is `posedge clk`, meaning the statements inside `always_ff` will execute on the positive edge of the clock. Inside the `always_ff` block, we use an `if/else` statement for conditional operations. Notice that the non-blocking operator `<=` is used inside the `always_ff` block. On every positive edge of the clock, the block checks if the reset is active. If the reset is active, the output will be set to zero; otherwise, the input will be copied to the output. The `always_ff` construct behaves like the `always` construct but is specifically used to imply flip-flops and allows tools to produce a warning if anything else is implied.

Let us design 4-bit counter, which counts on positive edge and has active high reset

```verilog
module Counter4Bit (
    input logic clk,
    input logic reset,
    output logic [3:0] out
);  
    logic [3:0] counter;

    always_ff @(posedge clk) begin
        if (reset)
            counter <= 4'b0000;
        else
            counter <= counter + 1;
    end

    assign out = counter;
endmodule
```

As in the previous example, every time `posedge clk` occurs, the counter will increment the value of the internal counter `counter` if `reset` is low. Otherwise, the counter will start counting from zero. Finally, we output the state of the internal counter to the output. Note that `assign` and `always_ff` work in parallel.

## Combinational logic with always statement 

We can design the combinational logic using `always` constructs. Let us first describe an inverter using  `always` constructs. 


```verilog
module Inverter (
    input logic a,
    output logic y
);
    always_comb begin
        y = ~a;
    end
endmodule
```

In this example, the `always_comb` block is used to describe combinational logic. The output `y` is always the logical NOT of the input `a`. The `always_comb` construct ensures that the block is always executed whenever any of its inputs change, making it suitable for combinational logic. In the inverter code we use the blocking operator `=`. 

> **Note:**
> 
> In SystemVerilog, a group blocking assignments (`=`) are evaluated in order they appear. They are used for combinational logic. Non-blocking assignments (`<=`) are used in sequential logic. A group of non-blocking statements is evaluated concurently. 

Let us construct 4-to-1 MUX using `always_comb` and `case` construct

```verilog
module Mux4to1 (
    input logic [1:0] sel,
    input logic [3:0] d,
    output logic y
);
    always_comb begin
        case (sel)
            2'b00: y = d[0];
            2'b01: y = d[1];
            2'b10: y = d[2];
            2'b11: y = d[3];
            default: y = 1'b0;
        endcase
    end
endmodule
```

In this example, the `always_comb` block is used to describe the combinational logic for a 4-to-1 multiplexer. The `case` statement selects one of the four input bits `d` based on the 2-bit selector `sel` and assigns it to the output `y`. The `default` case ensures that `y` is set to `0` if `sel` has an unexpected value. Be sure to always give `default` option in the `case` construct, otherwise you will infer a latch in your design. 

## Common mistakes

1. There is no assign construct in always block: 

```verilog
module WrongModule1 (
    input logic a,
    input logic b,
    output logic c
);
    always_comb begin
        assign c = a & b;
    end
endmodule
```

2. Having multiple blocks driving the same net

```verilog
module WrongModule2
    ....
    always_ff(@posedge clock) begin
        ......
        c <= {x,1'b0};
    end
    ....
    always_comb begin
        ......
        c = x;
    end
    ....
    assign c = in1 + in2;
endmodule
```

3. Infering latch in combinational design: 

```verilog
logic result;
logic status;

always_comb begin
    if (input_button) begin 
        status = 1’b1; 
        result = 1’b0;
    end
    else if (done_signal) begin
            status = 1’b0;
        end 
    end
```

What is the value of `result` when `done_signal` is high? What will happen when `input_button` and `done_signal` are low? The hardware synthesizer will assume the old value, thereby inferring a latch. You do not want a latch in a combinational design.

Correct answer would be: 
```verilog
logic result;
logic status;

always_comb begin
    if (input_button) begin 
        status = 1’b1; 
        result = 1’b0;
    end
    else if (done_signal) begin
            status = 1’b1;
            status = 1’b0;
        end
        else begin
            status = 1’b0;
            result = 1’b0;
        end
    end
```
Remember cover all your cases! 


## Task: Implement a 4-bit Gray Code Counter

Your task is to implement a 4-bit Gray Code counter, that changes its state with the frequency of 1 Hz. 

Steps required:
1. Start with two counters: a modulo 100*10^6 counter and a classical binary counter that counts from 0 to 15.
2. The first counter increments its value every system clock cycle.
3. The other counter changes its value when the first counter reaches the value 100*10^6-1. When the input *up_down* is equal to 0, the counter increments its value; otherwise it decreases. 
4. Convert the state of the binary counter to Gray Code. 


Python code snippet that illustrates the behaviour of gray code counter
```python 
binary_count = 0;

while(1):
    for i in range (0, 100 * 1e6): # the module 100*1e6 counter 
        if(i==100 * 1e6-1):
            if(up_down==0):
                binary_count = binary_count + 1
            else:
                binary_count = binary_count - 1
    
    gray_code = bin2gray(binary_count )
```

```python 
def bin2gray(binary):
    match binary:
        case 0: return 0
        case 1: return 1
        case 2: return 3
        case 3: return 2
        case 4: return 6
        case 5: return 7
        case 6: return 5
        case 7: return 4
        case 8: return 12
        case 9: return 13
        case 10: return 15
        case 11: return 14
        case 12: return 10
        case 13: return 11
        case 14: return 9
        case 15: return 8
        case _: return 0 
```

### Example Code Structure:

```verilog
module gray_code_counter (
    input logic clk, 
    input logic rst, // Button 
    input logic up_down, // Switch for up/down counting 
    output logic [3:0] gray_code // connect the output to LEDs 
);

    logic en;
    logic [3:0] binary_count;

    // Prescaler code & binary counter 


    // Gray Code Converter 
    // employ always_comb and case statement 
    // to convert from code to another 

endmodule



```
Tip: [Binary to graycode converter](https://www.javatpoint.com/binary-to-gray-code-cconversion-in-digital-electronics)
### Pin mapping 

Connect the `clk` signal to the system clock (100 MHz), the `rst` signal to the middle button, the `up_down` signal to the switch, and the `gray_code` signal to the LEDs.

```tcl
## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];


##Switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { up_down }]; #IO_L24N_T3_RS0_15 Sch=sw[0]

## LEDs
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { gray_code[0] }]; #IO_L18P_T2_A24_15 Sch=led[0]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { gray_code[1] }]; #IO_L24P_T3_RS1_15 Sch=led[1]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { gray_code[2] }]; #IO_L17N_T2_A25_15 Sch=led[2]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { gray_code[3] }]; #IO_L8P_T1_D11_14 Sch=led[3]

##Buttons
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { rst }]; #IO_L9P_T1_DQS_14 Sch=btnc
```



<!-- 
## Blocking vs Non-blocking Assignment in Verilog

In Verilog, assignments within procedural blocks ([`always`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fratko.pilipovic%2FLibrary%2FCloudStorage%2FOneDrive-UniverzavLjubljani%2FPredmeti%2FDN%2F2024_25%2FExercises%2F02-Sequential.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A56%2C%22character%22%3A28%7D%7D%5D%2C%22aede7559-ac13-4446-b47c-27c9fc564fb7%22%5D "Go to definition") blocks) can be either blocking or non-blocking. Understanding the difference between these two types of assignments is crucial for designing correct and efficient digital circuits.

### Blocking Assignment (`=`)

Blocking assignments use the `=` operator. They are executed sequentially, meaning that each statement must complete before the next one begins. This is similar to how statements in a typical programming language like C or Python are executed.

Example:
```verilog
always @ (posedge clk) begin
    a = b;
    c = a;
end
```
In this example, `c` will be assigned the value of [`a`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fratko.pilipovic%2FLibrary%2FCloudStorage%2FOneDrive-UniverzavLjubljani%2FPredmeti%2FDN%2F2024_25%2FExercises%2F02-Sequential.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A63%2C%22character%22%3A16%7D%7D%5D%2C%22aede7559-ac13-4446-b47c-27c9fc564fb7%22%5D "Go to definition") after [`a`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fratko.pilipovic%2FLibrary%2FCloudStorage%2FOneDrive-UniverzavLjubljani%2FPredmeti%2FDN%2F2024_25%2FExercises%2F02-Sequential.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A63%2C%22character%22%3A16%7D%7D%5D%2C%22aede7559-ac13-4446-b47c-27c9fc564fb7%22%5D "Go to definition") has been assigned the value of `b`.

### Non-blocking Assignment (`<=`)

Non-blocking assignments use the `<=` operator. They allow for concurrent execution, meaning that all the right-hand side expressions are evaluated at the beginning of the block, and the assignments are made at the end. This is particularly useful in sequential logic where you want to model flip-flop behavior.

Example:
```verilog
always @ (posedge clk) begin
    a <= b;
    c <= a;
end
```
In this example, both [`a`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fratko.pilipovic%2FLibrary%2FCloudStorage%2FOneDrive-UniverzavLjubljani%2FPredmeti%2FDN%2F2024_25%2FExercises%2F02-Sequential.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A63%2C%22character%22%3A16%7D%7D%5D%2C%22aede7559-ac13-4446-b47c-27c9fc564fb7%22%5D "Go to definition") and `c` are updated concurrently. `c` will be assigned the old value of [`a`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fratko.pilipovic%2FLibrary%2FCloudStorage%2FOneDrive-UniverzavLjubljani%2FPredmeti%2FDN%2F2024_25%2FExercises%2F02-Sequential.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A63%2C%22character%22%3A16%7D%7D%5D%2C%22aede7559-ac13-4446-b47c-27c9fc564fb7%22%5D "Go to definition"), not the value assigned to [`a`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fratko.pilipovic%2FLibrary%2FCloudStorage%2FOneDrive-UniverzavLjubljani%2FPredmeti%2FDN%2F2024_25%2FExercises%2F02-Sequential.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A63%2C%22character%22%3A16%7D%7D%5D%2C%22aede7559-ac13-4446-b47c-27c9fc564fb7%22%5D "Go to definition") in the same block.

### Key Differences

- **Execution Order**: Blocking assignments execute sequentially, while non-blocking assignments execute concurrently.
- **Usage**: Blocking assignments are typically used in combinational logic, whereas non-blocking assignments are used in sequential logic (e.g., flip-flops).
- **Simulation Behavior**: Incorrect use of blocking assignments in sequential logic can lead to simulation mismatches and unintended behavior.


--->

## Literature 

1. UC Davis Notes, [Verilog: Common mistakes](https://www.ece.ucdavis.edu/~bbaas/281/notes/Handout14.verilog4.pdf)
