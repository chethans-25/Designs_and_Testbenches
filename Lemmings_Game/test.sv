class test extends uvm_test;
    `uvm_component_utils(test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    generator gen;
    env environment;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = env::type_id::create("environment", this);
        generator = generator::type_id::create("generator", this);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        gen.start(environment.agt.seqr);
        #50; // Wait for some time to let the transactions be processed
        phase.drop_objection(this);
    endtask : run_phase
endclass : test
