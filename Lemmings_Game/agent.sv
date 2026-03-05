class agent extends uvm_agent;
    `uvm_component_utils(agent)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    driver drv;
    monitor mon;
    uvm_sequencer #(transaction) seqr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
        seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
    endfunction : build_phase


    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction : connect_phase
endclass : agent