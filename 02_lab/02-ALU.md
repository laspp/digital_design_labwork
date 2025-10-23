# Second exercise: Introduction to (System)Verilog 

<!-- ## SystemVerilog 

SystemVerilog offers several advantages for hardware design and verification:

1. **Unified Language**: Combines hardware description and verification capabilities in a single language, reducing the need for multiple tools and languages.
2. **Advanced Data Types**: Provides a rich set of data types that enhance modeling accuracy and simulation performance.
3. **Assertions**: Built-in support for assertions helps in early detection of design errors and improves verification quality.
4. **Object-Oriented Programming (OOP)**: Supports OOP concepts, enabling more modular, reusable, and maintainable verification code.
5. **Randomization**: Facilitates constrained random stimulus generation, which helps in uncovering corner-case bugs.
6. **Functional Coverage**: Built-in functional coverage constructs allow for comprehensive verification metrics.
7. **Concurrency**: Enhanced concurrency constructs like `fork-join` improve the modeling of parallel processes.
8. **Interfaces**: Simplifies module connections and improves code readability and maintainability.
9. **Tool Support**: Widely supported by major EDA tools, ensuring robust simulation and synthesis capabilities.

These advantages make SystemVerilog a powerful and efficient choice for both designing and verifying complex digital systems. In this course, we will cover only a subset of SystemVerilog constructs, focusing on basic Verilog.  -->

## Types 

Commonly used types in SystemVerilog include:

### Logic (NetList) Types

- `logic`: A 4-state data type (0, 1, X, Z) used for modeling combinational and sequential logic.
- `bit`: A 2-state data type (0, 1) used for modeling binary data.

### Vector Types

- `bit [n-1:0]`: An n-bit unsigned integer.
- `logic [n-1:0]`: An n-bit unsigned integer with 4-state logic.

### Variable Types

- `logic`: A 4-state data type (0, 1, X, Z) used for modeling combinational and sequential logic.
- `byte`: An 8-bit signed integer.
- `shortint`: A 16-bit signed integer.
- `int`: A 32-bit signed integer.
- `longint`: A 64-bit signed integer.
- `integer`: A general-purpose 32-bit signed integer (legacy from Verilog).
- `real`: A 64-bit floating point variable.

### Expressing Numbers Using Different Bases 

```verilog
// Binary representation (base 2)
logic [3:0] binary_num = 4'b1010; // 4-bit binary number 1010 (decimal 10)

// Octal representation (base 8)
logic [5:0] octal_num = 6'o12; // 6-bit octal number 12 (decimal 10)

// Decimal representation (base 10)
logic [7:0] decimal_num = 8'd10; // 8-bit decimal number 10

// Hexadecimal representation (base 16)
logic [7:0] hex_num = 8'hA; // 8-bit hexadecimal number A (decimal 10)
```

## Module 

All system modules in Verilog are encapsulated inside a module. Modules can include instantiation of lower-level modules to support hierarchical designs. The keywords `module` and `endmodule` mark the beginning and the end of the system description.

```verilog
module ModuleName(
    portType signalType Port1_name,
    portType signalType Port2_name, Port3_name,
    .......
    portType signalType PortN_name
);
```

where the `portType` specifies the direction of the port (input, output, or inout), and `signalType` defines the type of the signal, as described in the previous section.

| Port Type | Description |
|-----------|-------------|
| `input`   | Specifies an input port to the module. Data flows into the module through this port. |
| `output`  | Specifies an output port from the module. Data flows out of the module through this port. |
| `inout`   | Specifies a bidirectional port. Data can flow both into and out of the module through this port. |

## Operators 

SystemVerilog supports a variety of operators that are used for different purposes, including arithmetic, logical, relational, and bitwise operations. Here are some common operators with examples:

### Numerical Operators

- `+` : Addition
- `-` : Subtraction
- `*` : Multiplication
- `/` : Division
- `%` : Modulus
  
```verilog
logic [5:0] c;

// in1 and in2 inputs of module 
assign c = in1 + in2; 
```

### Logical Operators

- `&&` : Logical AND
- `||` : Logical OR
- `!` : Logical NOT

```verilog
logic c;

// in1 and in2 inputs of module 
assign c = in1 && in2; 
```

### Relational Operators

- `==` : Equality
- `!=` : Inequality
- `<` : Less than
- `<=` : Less than or equal to
- `>` : Greater than
- `>=` : Greater than or equal to

 ```verilog
logic c;

// in1 and in2 inputs of module 
assign c
assign c = in1 >= in2; 
```

### Bitwise Operators

- `&` : Bitwise AND
- `|` : Bitwise OR
- `^` : Bitwise XOR
- `~` : Bitwise NOT
- `<<` : Logical shift left
- `>>` : Logical shift right
- `<<<` : Arithmetic shift left
- `>>>` : Arithmetic shift right
  
```verilog
logic [5:0] c;

// in1 and in2 inputs of module 
assign c = in1 & in2; 
```

### Reduction Operators

- `&` : Reduction AND
- `|` : Reduction OR
- `^` : Reduction XOR
- `~&` : Reduction NAND
- `~|` : Reduction NOR
- `~^` or `^~` : Reduction XNOR

```verilog
logic [5:0] a;
logic c,d;
assign a = 6'b101010;

// in1 and in2 inputs of module 
assign c = &a; // AND reduction result 0
assign c = |a; // OR reduction result 1
```

### Conditional Operator

- `? :` : Conditional (ternary) operator
```verilog
logic [5:0] a,b;
logic c;

assign c = (a > b) ? 1'b1 : 1'b0; // cc = either one or zero
```


### Concatenation and Replication Operators
The concatenation operator `{}` in SystemVerilog is used to join multiple bits, vectors, or expressions into a single vector.

```verilog
logic [3:0] a = 4'b1010;
logic [3:0] b = 4'b0101;
logic [7:0] c;

// Concatenate a and b to form an 8-bit vector
assign c = {a, b}; // c = 8'b10100101
```

You can also use the replication operator `{n{}}` to replicate a bit or vector `n` times.

```verilog
logic [1:0] d = 2'b11;
logic [5:0] e;

// Replicate d three times to form a 6-bit vector
assign e = {3{d}}; // e = 6'b111111
```

## Modeling Concurent functionality in SystemVerilog 


### Continuous assignment 
Continuous assignment in SystemVerilog allows for the assignment of values to nets using the `assign` keyword, ensuring that the assigned value is continuously updated whenever the right-hand side expression changes. A continuous assignment models combinational logic. For example:

```verilog
assign out = a & b; // 'out' is continuously assigned the result of 'a & b'
```

We need to differ continous assignment from assignment in programming languages. 

First example: 

```verilog
assign b = a; 
assign c = b;
```

In programming languages, a similar construct will first assign the value of `a` to `b`, and then pass the value of `b` to `c`. During synthesis, the tool will remove signal `b` and infer `assign c = a`.

Second example: 

```verilog
assign c = a; 
assign c = b;
```

In programming languages, a similar construct will first assign the value of `a` to `c`, and then assign the value of `b` to `c`. The final value of `c` will be determined by the last assignment. During synthesis, the tool will create a net driven by two signals. As these signals by have different values, the net `c` will have an unknown value `X`. This situation must be avoided at all costs.


### 4-bit 4:1 Multiplexer 

The 4-bit multiplexer (MUX) selects one of the four 4-bit inputs to pass to the output based on the 2-bit selection signal.

```verilog
module mux4to1 (
    input logic [3:0] in0, // 4-bit input 0
    input logic [3:0] in1, // 4-bit input 1
    input logic [3:0] in2, // 4-bit input 2
    input logic [3:0] in3, // 4-bit input 3
    input logic [1:0] sel, // 2-bit selection signal
    output logic [3:0] out // 4-bit output
);
    // Nested conditional operator 
    // C = (A > B) ? 1 : (A < B) ? 0 : 1 
    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b10) ? in2 :
                 (sel == 2'b11) ? in3 :
                 4'b0000; // Default case 

endmodule
```

#### Explanation

- **Module Declaration**: The module `mux4to1` is declared with inputs and outputs.
- **Inputs**: Four 4-bit inputs (`in0`, `in1`, `in2`, `in3`) and a 2-bit selection signal (`sel`).
- **Output**: One 4-bit output (`out`).
- **Conditional Statement**: The `assign` statement uses a series of conditional (ternary) operators to select one of the four inputs based on the value of the 2-bit selection signal (`sel`).

### 4-bit adder

The 4-bit adder adds two 4-bit binary numbers and produces a 4-bit sum and a carry-out bit. 


```verilog
module adder4bit (
    input logic [3:0] a, // 4-bit input a
    input logic [3:0] b, // 4-bit input b
    output logic [3:0] sum, // 4-bit sum output
    output logic carry_out // Carry-out bit
);

    logic c1, c2, c3; // Intermediate carry bits

    // Half Adder for the least significant bit
    assign sum[0] = a[0] ^ b[0];
    assign c1 = a[0] & b[0];

    // Full Adder for the second bit
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (c1 & (a[1] ^ b[1]));

    // Full Adder for the third bit
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (c2 & (a[2] ^ b[2]));

    // Full Adder for the most significant bit
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign carry_out = (a[3] & b[3]) | (c3 & (a[3] ^ b[3]));

endmodule
```

#### Explanation

- **Module Declaration**: The module `adder4bit` is declared with two 4-bit inputs (`a` and `b`), a 4-bit output (`sum`), and a carry-out bit (`carry_out`).
- **Intermediate Carry Bits**: Three intermediate carry bits (`c1`, `c2`, `c3`) are used to store the carry from each adder stage.
- **Half Adder**: The least significant bit is added using a half adder, which produces the sum and the first carry bit (`c1`).
- **Full Adders**: The next three bits are added using full adders, which take into account the carry from the previous stage.
- **Final Carry-Out**: The carry-out from the most significant bit is assigned to `carry_out`.

### User Constraints Files and Pin Planning in Vivado

In Vivado, User Constraints Files (UCF) or Xilinx Design Constraints (XDC) files are used to define the physical constraints of the design, such as pin assignments, timing constraints, and other implementation-specific parameters. Pin planning involves mapping the logical signals in your design to the physical pins on the FPGA. This process ensures that the design interfaces correctly with external components and meets the required performance criteria. Proper pin planning and constraint management are crucial for successful FPGA implementation, as they directly impact signal integrity, timing closure, and overall design functionality.

The [XDC file for Nexys A7](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-100T-Master.xdc) defines the pin placement for external signals of modules. To map the inputs of our `adder4bit` to the switches and the outputs to LEDs, we need to make the following changes:

```tcl
##Switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { a[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { a[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { a[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { a[3] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { b[0] }]; #IO_L12N_T1_MRCC_14 Sch=sw[4]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { b[1] }]; #IO_L7N_T1_D10_14 Sch=sw[5]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { b[2] }]; #IO_L17N_T2_A13_D29_14 Sch=sw[6]
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { b[3] }]; #IO_L5N_T0_D07_14 Sch=sw[7]

##LEDS
## LEDs
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { sum[0] }]; #IO_L18P_T2_A24_15 Sch=led[0]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { sum[1] }]; #IO_L24P_T3_RS1_15 Sch=led[1]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { sum[2] }]; #IO_L17N_T2_A25_15 Sch=led[2]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { sum[3] }]; #IO_L8P_T1_D11_14 Sch=led[3]
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { carry_out }]; #IO_L7P_T1_D09_14 Sch=led[4]
```

It is important to assign the appropriate pin to the `get_ports` function.

## Assignment 

Your task is to implement a "dummy" 6-bit Arithmetic Logic Unit (ALU) with the following interface:
- **a, b**: 6-bit inputs
- **alu_control**: 3-bit input for selecting the operation
- **c**: 6-bit output

| `alu_control` Value | Operation        |
|---------------------|------------------|
| 000                 | Addition         |
| 001                 | Subtraction      |
| 010                 | Bitwise AND      |
| 011                 | Bitwise OR       |
| 100                 | Bitwise XOR      |
| 101                 | Compare (equal)  |
| 110                 | Pass-through `b` |
| 111                 | Pass-through `a` |

Tips: 
1. Employ operators and intermediate signals to obtain the results of each operation.
2. Connect input signals to the rightmost switches (SW0 to SW11), and selection signals to the leftmost switches (SW13 to SW15). The output signal should be connected to LEDs (LED0 to LED5).
3. Employ nested conditionals.





