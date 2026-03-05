class generator extends uvm_sequence #(transaction);
    `uvm_object_utils(generator)
    
    function new(string name = "generator");
        super.new(name);
    endfunction : new
    
    virtual task body();
        transaction tr;
        repeat(10)
        begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        `uvm_info(get_type_name(), $sformatf("Generated transaction: %p", tr), UVM_LOW)
        finish_item(tr);
        end
    endtask : body

endclass : generator