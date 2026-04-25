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
    // property p_pe_reset;
    //     @(posedge clk or negedge rst_n) !rst_n |-> acc == 0;
    // endproperty
    // A_PE_RESET: assert property(p_pe_reset)
    // else $error("[PE BUG] reset but acc != 0");

    // property p_pe_stable;
    //     @(posedge clk) disable iff(!rst_n) !valid |-> $stable(acc);
    // endproperty
    // A_PE_STABLE: assert property(p_pe_stable)
    // else $error("[PE BUG] !valid but acc != acc past");

    // property p_pe_math;
    //     @(posedge clk) disable iff(!rst_n) valid |=> (acc == $past(acc) + ($past(a_in) * $past(b_in)));
    // endproperty
    // A_PE_MATH: assert property(p_pe_math)
    // else $error("[PE BUG] wrong math");

    // assert property(
    //     @(posedge clk) disable iff (!rst_n) (a_out == $past(a_in) && b_out == $past(b_in))
    // ) else $error("[PE BUG] shift wrong");
endmodule