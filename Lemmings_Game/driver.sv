class driver extends uvm_driver #(transaction);
`uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    transaction tr;
    virtual l_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr", this);
        
        if(!uvm_config_db#(virtual l_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")

    virtual task run_phase(uvm_phase phase);
        forever
        begin
            seq_item_port.get_next_item(tr);
            `uvm_info(get_type_name(), $sformatf("Driving transaction: %p", tr), UVM_LOW)
            // Drive the transaction to the DUT here
            // vif.clk = tr.clk;
            vif.areset = tr.areset;
            vif.bump_left = tr.bump_left;
            vif.bump_right = tr.bump_right;
            seq_item_port.item_done();
            #10; // Wait for some time before driving the next transaction
        end
    endtask : run_phase
endclass : driver