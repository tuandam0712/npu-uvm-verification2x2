package npu_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `include "npu_sequence_item.sv"
    `include "npu_sequencer.sv"
    `include "npu_driver.sv"
    `include "npu_monitor.sv"
    `include "npu_scoreboard.sv"
    `include "npu_agent.sv"
    `include "npu_env.sv"
    `include "npu_sequence.sv"
    `include "npu_base_test.sv"   // Phải include test
    
endpackage