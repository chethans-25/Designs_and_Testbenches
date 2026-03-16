`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*; 


`include "intf.sv"
`include "seq_item.sv"
`include "seq.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"





module top;
  
  logic clk;
  logic reset; 

  s_intf intf(.clk(clk),.reset( reset)); 
  
 
  top_module dut(.clk(intf.clk),
                 .reset(intf.reset),
                 .in(intf.in),
                 .done(intf.done));
               
  
  initial begin 
    
    uvm_config_db#(virtual s_intf)::set(null, "*", "active", intf);
  end
  
  
  initial begin
    
    

   
     clk = 0; 
     reset = 1;
    #15 reset = 0;
    #200 $stop();
    
     
    
  end
  
  always  #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0, top); 
  end
  
  initial begin 
    run_test("test"); 
  end
endmodule 
