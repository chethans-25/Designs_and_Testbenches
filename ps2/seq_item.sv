class seq_item extends uvm_sequence_item;
  `uvm_object_utils (seq_item)
  
  function new(string name = "");
    super.new(name);
  endfunction
  
  rand logic [7:0] in;
  rand bit reset;
  bit done;
  

  // constraint case1 {(done && in[3]) == 1;}
  // constraint case1 {done -> ~in[3];}
  
  
endclass
