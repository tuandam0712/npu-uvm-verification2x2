import uvm_pkg::*;
class npu_driver extends uvm_driver #(npu_sequence_item);
    `uvm_component_utils(npu_driver)
    virtual npu_if vif;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual npu_if)::get(this,"","vif",vif)) begin
            `uvm_fatal("NOVIF","Virtual interface not found")
        end
    endfunction
    task run_phase(uvm_phase phase);
        npu_sequence_item req;
        vif.rst_n <= 0;
        repeat(5) @(posedge vif.clk);
        vif.rst_n <= 1;
        @(posedge vif.clk);
        forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask 
    task drive_transaction(npu_sequence_item req);
        
        // Start
        vif.start <= 1;
        @(posedge vif.clk);
        vif.start <= 0;
        
        // Gửi cột 0
        vif.a0 <= req.A[0][0];
        vif.a1 <= req.A[1][0];
        vif.b0 <= req.B[0][0];
        vif.b1 <= req.B[0][1];
        @(posedge vif.clk);
        
        // Gửi cột 1
        vif.a0 <= req.A[0][1];
        vif.a1 <= req.A[1][1];
        vif.b0 <= req.B[1][0];
        vif.b1 <= req.B[1][1];
        @(posedge vif.clk);
        
        // Clear
        vif.a0 <= 0; vif.a1 <= 0;
        vif.b0 <= 0; vif.b1 <= 0;
        // Đợi DUT xử lý xong
        wait(vif.done == 1);
        @(posedge vif.clk);
        wait(vif.done == 0);
        @(posedge vif.clk);  // Thêm cycle để ổn định
    endtask
endclass