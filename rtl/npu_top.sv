module npu_top #(
    parameter width = 8
) (
    input logic clk,
    input logic rst_n,
    input logic start,

    input logic signed [width-1:0] a_in0,a_in1,
    input logic signed [width-1:0] b_in0,b_in1,
    output logic done,
    output logic signed [2*width-1:0] c00,c01,c10,c11
);

    logic ctrl_valid_in;
    logic ctrl_clear;

    sa_controller_2x2 u_ctrl(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .clear(ctrl_clear),
        .valid_in(ctrl_valid_in),
        .done(done)
    );

    systolic_arr_2x2 #(.width(width)) u_arr (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(ctrl_valid_in),
        .clear(ctrl_clear),
        .a_in0(a_in0), .a_in1(a_in1),
        .b_in0(b_in0), .b_in1(b_in1),
        .c00(c00), .c01(c01), .c10(c10), .c11(c11)
    );

    // property p_shift_right;
    //     @(posedge clk) disable iff (!rst_n) u_ctrl.state inside{1,2} |-> (u_arr.pe01.a_in == $past(u_arr.pe00.a_out));
    // endproperty

    // A_SHIFT_RIGHT: assert property(p_shift_right)
    //     else $error("[TOP BUG] data not shift right");

    
    // property p_shift_down;
    //     @(posedge clk) disable iff (!rst_n) u_ctrl.state inside{1,2} |-> (u_arr.pe10.b_in == $past(u_arr.pe00.b_out));
    // endproperty

    // A_SHIFT_DOWN: assert property(p_shift_down)
    //     else $error("[TOP BUG] data not shift down");

    // assert property(
    //     @(posedge clk) disable iff (!rst_n) !ctrl_valid_in |->($stable(u_arr.pe00.a_out) && $stable(u_arr.pe00.b_out))
    // );

    // sequence two_valid;
    //     ctrl_valid_in ##1 ctrl_valid_in ##1 !ctrl_valid_in;
    // endsequence

    // assert property(
    //     @(posedge clk) disable iff (!rst_n) start |-> two_valid
    // );
endmodule