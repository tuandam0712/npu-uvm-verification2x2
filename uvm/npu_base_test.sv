import uvm_pkg::*;
class npu_base_test extends uvm_test;
    `uvm_component_utils(npu_base_test)
    npu_env env;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = npu_env::type_id::create("env", this);
    endfunction
    task run_phase(uvm_phase phase);
        npu_sequence seq;
        
        phase.raise_objection(this);
        seq = npu_sequence::type_id::create("seq");
        seq.start(env.agent.sqr);
        phase.drop_objection(this);
    endtask
endclass