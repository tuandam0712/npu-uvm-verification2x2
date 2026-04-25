`timescale 1ns/1ps
import uvm_pkg::*;
import npu_pkg::*;
module tb_npu_uvm;
    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    npu_if vif(clk);
    npu_top dut(
        .clk(clk),
        .rst_n(vif.rst_n),
        .start(vif.start),
        .done(vif.done),
        .a_in0(vif.a0), .a_in1(vif.a1),
        .b_in0(vif.b0), .b_in1(vif.b1),
        .c00(vif.c00), .c01(vif.c01),
        .c10(vif.c10), .c11(vif.c11)
    );
    initial begin
        uvm_config_db #(virtual npu_if)::set(null, "*", "vif", vif);
        run_test("npu_base_test");
    end
endmodule