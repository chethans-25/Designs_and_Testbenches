module top_module (
  input clk,
  input reset,      // Synchronous active-high reset
  input counter_enable,     // Enable counting
  input load_enable,        // Enable loading
  input [3:0] load,         // Load value
  output logic [3:0] q);          // Current count value

  initial begin
    q<=1;
  end
  always @(posedge clk ) begin
    if(reset==1 | q>9)
      q <= 1;
    else if(counter_enable && load_enable)
      q <= load;
    else if(counter_enable)
      q <= q+1;
  end
endmodule

interface Counter_if(input logic clk, input logic reset);
  logic load_enable;
  logic counter_enable;
  logic [3:0] load;
  logic [3:0] q;
endinterface