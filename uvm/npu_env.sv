import uvm_pkg::*;
class npu_env extends uvm_env;
    `uvm_component_utils(npu_env)
    npu_agent agent;
    npu_scoreboard scb;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = npu_agent::type_id::create("agent", this);
        scb = npu_scoreboard::type_id::create("scb", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.analysis_port.connect(scb.analysis_imp);
    endfunction
endclass