class driver extends uvm_driver#(seq_item);
  `uvm_component_utils(driver)
  seq_item s_item;
  virtual s_intf  intf;
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual s_intf)::get(this, "", "active", intf)) begin
        `uvm_fatal("CONFIG_DB", "Failed to get the active interface from uvm_config_db.")
    end
  endfunction
 
  task run_phase(uvm_phase phase);
   
    forever begin
      
      seq_item_port.get_next_item(s_item);
      
      drive(s_item); 
      seq_item_port.item_done(); 
    end
  endtask
  
  
  task drive(seq_item s_item);

   @(posedge intf.clk);
    
    intf.in <= s_item.in;
    s_item.done <= intf.done;
   
    

  endtask
endclass
  
    