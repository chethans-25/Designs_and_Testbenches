class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    uvm_analysis_imp #(transaction, scoreboard) recv;
    transaction tr;

    function new(string name = "scoreboard", uvm_component parent);
        super.new(name, parent);
        recv = new("recv", this);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr= transaction::type_id::create("tr", this);
    endfunction : build_phase
    
    virtual function void write(transaction t);
        tr = t;
        `uvm_info(get_type_name(), $sformatf("Scoreboard received transaction: %p", tr), UVM_LOW)
        // Here you can add checks or comparisons to expected values
    endfunction : write
endclass : scoreboard