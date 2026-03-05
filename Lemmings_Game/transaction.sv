class transaction extends uvm_transaction;
  rand bit clk;
  rand bit areset;    // Freshly brainwashed Lemmings walk left.
  rand bit bump_left;
  rand bit bump_right;
  bit walk_left;
  bit walk_right;

  `uvm_object_utils_begin(transaction)
    `uvm_field_bit(clk, UVM_ALL_ON)
    `uvm_field_bit(areset, UVM_ALL_ON)
    `uvm_field_bit(bump_left, UVM_ALL_ON)
    `uvm_field_bit(bump_right, UVM_ALL_ON)
    `uvm_field_bit(walk_left, UVM_ALL_ON)
    `uvm_field_bit(walk_right, UVM_ALL_ON)
	`uvm_object_utils_end

  function new(string name = "transaction");
    super.new(name);
  endfunction : new

endclass : transaction