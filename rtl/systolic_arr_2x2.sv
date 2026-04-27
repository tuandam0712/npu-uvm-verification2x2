module systolic_arr_2x2 #(
    parameter width = 8
) (
    input logic clk,
    input logic rst_n,
    input logic valid_in,
    input logic clear,

    input logic signed [width-1:0] a_in0,
    input logic signed [width-1:0] a_in1,
    input logic signed [width-1:0] b_in0,
    input logic signed [width-1:0] b_in1,

    output logic signed [2*width-1:0] c00,
    output logic signed [2*width-1:0] c01,
    output logic signed [2*width-1:0] c10,
    output logic signed [2*width-1:0] c11
);
    logic signed [width-1:0] a_wire[0:1][0:2];
    logic signed [width-1:0] b_wire[0:2][0:1];
    logic valid_00,valid_01,valid_10,valid_11;

    logic signed [width-1:0] a_in1_d1;
    logic signed [width-1:0] b_in1_d1;

    always_ff @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            a_in1_d1 <= '0;
            b_in1_d1 <= '0;
        end else begin
            a_in1_d1 <= a_in1;
            b_in1_d1 <= b_in1;
        end
    end

    assign a_wire[0][0] = a_in0;
    assign a_wire[1][0] = a_in1_d1;
    assign b_wire[0][0] = b_in0;
    assign b_wire[0][1] = b_in1_d1;

    assign valid_00 = valid_in;
    always_ff @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            valid_01 <= '0;
            valid_10 <= '0;
            valid_11 <= '0;
        end else begin
            valid_01 <= valid_00;
            valid_10 <= valid_00;
            valid_11 <= valid_01 & valid_10;
        end
    end
    pe #(.width(width)) pe00(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid_00),
        .clear(clear),
        .a_in(a_wire[0][0]),
        .b_in(b_wire[0][0]),
        .a_out(a_wire[0][1]),
        .b_out(b_wire[1][0]),
        .acc(c00)
    );
    pe #(.width(width)) pe01(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid_01),
        .clear(clear),
        .a_in(a_wire[0][1]),
        .b_in(b_wire[0][1]),
        .a_out(a_wire[0][2]),
        .b_out(b_wire[1][1]),
        .acc(c01)
    );
    pe #(.width(width)) pe10(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid_10),
        .clear(clear),
        .a_in(a_wire[1][0]),
        .b_in(b_wire[1][0]),
        .a_out(a_wire[1][1]),
        .b_out(b_wire[2][0]),
        .acc(c10)
    );
    pe #(.width(width)) pe11(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid_11),
        .clear(clear),
        .a_in(a_wire[1][1]),
        .b_in(b_wire[1][1]),
        .a_out(a_wire[1][2]),
        .b_out(b_wire[2][1]),
        .acc(c11)
    );
    assert property(
        @(posedge clk) disable iff (!rst_n) valid_01 |-> (pe01.a_in == $past(pe00.a_out))
    )else $error("[SARR BUG] shift wrong pe00pe01");
    assert property(
        @(posedge clk) disable iff (!rst_n) valid_10 |-> (pe10.b_in == $past(pe00.b_out))
    ) else $error("[SARR BUG] shift wrong pe00pe10");
    assert property(
    @(posedge clk) disable iff (!rst_n) valid_11 |-> (pe11.b_in == $past(pe01.b_out))
    ) else $error("[SARR BUG] shift wrong pe01pe11");
    assert property(
    @(posedge clk) disable iff (!rst_n) valid_11 |-> (pe11.a_in == $past(pe10.a_out))
    ) else $error("[SARR BUG] shift wrong pe10pe11");
    assert property(
        @(posedge clk) disable iff (!rst_n) valid_11 |-> ($past(valid_01) && $past(valid_10))
    ) else $error("[SARR BUG] valid_11 triggered wrong");
    assert property(
        @(posedge clk) disable iff (!rst_n) !valid_in |-> ($stable(c00) && $stable(c11))
    ) else $error("[SARR BUG] output unstable when !valid");
endmodule