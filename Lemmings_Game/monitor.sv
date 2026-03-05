class monitor extends uvm_monitor;

`uvm_component_utils(monitor)

uvm_analysis_port #(transaction) send;

    function new(string name = "monitor", uvm_component parent);
        super.new(name, parent);
        send = new("send", this);
    endfunction : new

    virtual l_if vif;
    transaction tr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr", this);
        
        if(!uvm_config_db#(virtual l_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever
        begin
            #10; // Sample signals at regular intervals
            tr.areset = vif.areset;
            tr.bump_left = vif.bump_left;
            tr.bump_right = vif.bump_right;
            tr.walk_left = vif.walk_left;
            tr.walk_right = vif.walk_right;
            `uvm_info(get_type_name(), $sformatf("Observed signals: areset=%b, bump_left=%b, bump_right=%b, walk_left=%b, walk_right=%b", 
                vif.areset, vif.bump_left, vif.bump_right, vif.walk_left, vif.walk_right), UVM_LOW)
            send.write(tr);
        end
    endtask : run_phase
endclass : monitor