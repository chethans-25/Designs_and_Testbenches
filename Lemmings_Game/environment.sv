class env extends uvm_env;
    `uvm_component_utils(env)
    
    agent agt;
    scoreboard sb;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        sb  = scoreboard::type_id::create("sb", this);
        agt = agent::type_id::create("agt", this);
    endfunction : build_phase


    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.send.connect(sb.recv);
    endfunction : connect_phase

endclass : env