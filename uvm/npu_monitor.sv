import uvm_pkg::*;
covergroup npu_input_cg with function sample (npu_sequence_item item);
    cp_a00: coverpoint item.A[0][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cp_b00: coverpoint item.B[0][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab: cross cp_a00, cp_b00;
    cp_a01: coverpoint item.A[0][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cp_b10: coverpoint item.B[1][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab0110: cross cp_a01, cp_b10;
    cp_b01: coverpoint item.B[0][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab0001: cross cp_a00, cpb01;
    cp_b11: coverpoint item.B[1][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab0111: cross cp_a01, cp_b11;
    cp_a10: coverpoint item.A[1][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab1000: cross cp_a10, cp_b00;
    cp_a11: coverpoint item.A[1][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab1110: cross cp_a11, cp_b10;
    cx_ab1001: cross cp_a10, cp_b01;
    cx_ab1111: cross cp_a11, cp_b11;
endgroup
class npu_monitor extends uvm_monitor;
    `uvm_component_utils(npu_monitor)
    npu_input_cg cg;
    virtual npu_if vif;
    uvm_analysis_port #(npu_sequence_item) analysis_port;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cg = new();
        analysis_port = new("analysis_port",this);
        if(!uvm_config_db #(virtual npu_if)::get(this,"","vif",vif)) begin
            `uvm_fatal("NOVIF"," Vif interface not found")
        end
    endfunction
    task run_phase(uvm_phase phase);
        npu_sequence_item item;
        npu_sequence_item item_clone;
        forever begin
            @(posedge vif.clk iff vif.start);
            @(posedge vif.clk);  // Thêm 1 cycle để inputs ổn định
            item = npu_sequence_item::type_id::create("item");
            
            // Input cycle 0
            item.A[0][0] = vif.a0;
            item.A[1][0] = vif.a1;
            item.B[0][0] = vif.b0;
            item.B[0][1] = vif.b1;
            @(posedge vif.clk);
            
            // Input cycle 1
            item.A[0][1] = vif.a0;
            item.A[1][1] = vif.a1;
            item.B[1][0] = vif.b0;
            item.B[1][1] = vif.b1;
            
            // Đợi kết quả tính toán xong
            wait(vif.done == 1);
            
            // Quan trọng: capture output tại cạnh clock NGAY KHI done=1
            @(posedge vif.clk);
            
            item.C_actual[0][0] = vif.c00;
            item.C_actual[0][1] = vif.c01;
            item.C_actual[1][0] = vif.c10;
            item.C_actual[1][1] = vif.c11;
            
            // Đợi done xuống
            wait(vif.done == 0);
            
            // Gửi sang scoreboard
            $cast(item_clone, item.clone());
            sample_coverage(item);
            analysis_port.write(item_clone);
        end
    endtask
    function void sample_coverage(npu_sequence_item item);
        cg.sample(item);
    endfunction
endclass
covergroup npu_input_cg with function sample (npu_sequence_item item);
    cp_a00: coverpoint item.A[0][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cp_b00: coverpoint item.B[0][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab: cross cp_a00, cp_b00;
    cp_a01: coverpoint item.A[0][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cp_b10: coverpoint item.B[1][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab0110: cross cp_a01, cp_b10;
    cp_b01: coverpoint item.B[0][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab0001: cross cp_a00, cpb01;
    cp_b11: coverpoint item.B[1][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab0111: cross cp_a01, cp_b11;
    cp_a10: coverpoint item.A[1][0] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab1000: cross cp_a10, cp_b00;
    cp_a11: coverpoint item.A[1][1] {
        bins zero = {0};
        bins pos = {[1:126]};
        bins neg = {[-127:-1]};
        bins max_pos = {127};
        bins max_neg = {-128};
    }
    cx_ab1110: cross cp_a11, cp_b10;
    cx_ab1001: cross cp_a10, cp_b01;
    cx_ab1111: cross cp_a11, cp_b11;
endgroup