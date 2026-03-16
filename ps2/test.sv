class test extends uvm_test;
`uvm_component_utils(test)
 seqn seq;
enve env;
  
 function new(string name,uvm_component parent);
 super.new(name,parent);
endfunction
  
function void build_phase(uvm_phase phase);
 seq=seqn::type_id::create("uvm_seq");
env=enve::type_id::create("uvm_env",this);
endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agnt.seqr);
    #1;
   phase.drop_objection(this);
  endtask
endclass