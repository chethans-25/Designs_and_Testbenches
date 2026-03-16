class seqn extends uvm_sequence#(seq_item);
  `uvm_object_utils(seqn)
  seq_item s_item;
  function new(string name=" ");
    super.new(name);
  endfunction
  
  task body();

    repeat(20) begin
    wait_for_grant();
    $display("sequence");
    s_item=seq_item::type_id::create("s_item");
    s_item.randomize();
    send_request(s_item);
    wait_for_item_done;
    end
     
  endtask
endclass