interface npu_if(input logic clk);
    logic rst_n;
    logic start;
    logic done;
    logic signed [7:0] a0,a1,b0,b1;
    logic signed [15:0] c00,c01,c10,c11;
endinterface