`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)
  
  rand logic [3:0] load;
  rand bit load_enable;
  rand bit counter_enable;
  bit [3:0] q;

  function new( string name = "transaction");
    super.new(name);
  endfunction

endclass

class generator extends uvm_sequence #(transaction);
  `uvm_object_utils(generator)

  function new(string name = "generator");
    super.new(name);
  endfunction

  virtual task body();
    transaction tr;
    tr = transaction::type_id::create("tr");
    start_item(tr);
    assert(tr.randomize());
    `uvm_info("generator", $sformatf("Generated transaction: load=%0d, load_enable=%b, counter_enable=%b", tr.load, tr.load_enable, tr.counter_enable), UVM_MEDIUM)
    finish_item(tr);
  endtask
endclass

class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)

  virtual Counter_if vif;
  transaction tr;

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    if (!uvm_config_db#(virtual Counter_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("CONFIG_DB", "Failed to get the virtual interface from uvm_config_db.")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tr);
      `uvm_info("driver", $sformatf("Driving transaction: load=%0d, load_enable=%b, counter_enable=%b", tr.load, tr.load_enable, tr.counter_enable), UVM_MEDIUM)
      vif.load <= tr.load;
      vif.load_enable <= tr.load_enable;
      vif.counter_enable <= tr.counter_enable;
      seq_item_port.item_done();
    end
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  transaction tr;
  virtual Counter_if vif;
  uvm_analysis_port #(transaction) send;

  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send = new("send", this);
    if (!uvm_config_db#(virtual Counter_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("CONFIG_DB", "Failed to get the virtual interface from uvm_config_db.")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      tr.load = vif.load;
      tr.load_enable = vif.load_enable;
      tr.counter_enable = vif.counter_enable;
      tr.q = vif.q;
      send.write(tr);
      `uvm_info("monitor", $sformatf("Observed transaction: load=%0d, load_enable=%b, counter_enable=%b, q=%0d", tr.load, tr.load_enable, tr.counter_enable, tr.q), UVM_MEDIUM)
    end
  endtask
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)

  generator gen;
  driver drv;
  monitor mon;

  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("gen", this);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)

  agent agt;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt", this);
  endfunction
endclass

  

