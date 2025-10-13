// create module which has input and output ports
module basic_comb(
  input logic a, 
  input logic b, 
  input logic c, 
  output logic [3:0] y);

  // create combinational logic
  assign y[0] = a & b | c;
  assign y[1] = a & c;
  assign y[2] = a | c;
  assign y[3] = a & b & c;
endmodule