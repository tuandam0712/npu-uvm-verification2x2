module pe #(parameter width = 8) (
    input logic clk, rst_n,
    input logic valid,
    input logic clear,
    input logic signed [width-1:0] a_in, b_in,
    output logic signed [width-1:0] a_out, b_out,
    output logic signed [2*width-1:0] acc
);
    always_ff @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            acc <= '0;
            a_out <= '0;
            b_out <= '0;
        end else begin
            a_out <= a_in;
            b_out <= b_in;
            if (clear) begin
                acc <= '0;  // Reset về 0 khi clear
            end else if (valid) begin
                acc <= acc + a_in * b_in;
            end
        end
    end
    assert property(
        @(posedge clk) !rst_n |-> acc == 0
    ) else $error("[PE BUG] reset but acc != 0");//reset

    assert property(
        @(posedge clk) disable iff(!rst_n) !valid |-> $stable(acc)
    )else $error("[PE BUG] !valid but acc != acc past");//stable

    assert property(
        @(posedge clk) disable iff(!rst_n) valid |=> (acc == $past(acc) + ($past(a_in) * $past(b_in)))
    )else $error("[PE BUG] wrong math");//math

    assert property(
        @(posedge clk) disable iff (!rst_n) (a_out == $past(a_in) && b_out == $past(b_in))
    ) else $error("[PE BUG] shift wrong");
endmodule