import uvm_pkg::*;

class npu_sequencer extends uvm_sequencer #(npu_sequence_item);
    `uvm_component_utils(npu_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        `uvm_info("SQR", "Sequencer run_phase started", UVM_NONE)
        super.run_phase(phase);
    endtask
endclass