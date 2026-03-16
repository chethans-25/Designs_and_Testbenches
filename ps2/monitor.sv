class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  
  uvm_analysis_port#(seq_item) item_collected_port;

  
  virtual s_intf intf; 

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   
    if (!uvm_config_db#(virtual s_intf)::get(this, "", "active", intf)) begin
      `uvm_fatal("NOVIF", "Virtual interface not set for monitor!")
    end
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item tr; 
      
    tr = seq_item::type_id::create("tr");
    wait(!intf.reset)   
    
    @(posedge intf.clk)
    tr.reset = intf.reset;   
    tr.in = intf.in;
    tr.done = intf.done;
    end
    
  endtask
endclass