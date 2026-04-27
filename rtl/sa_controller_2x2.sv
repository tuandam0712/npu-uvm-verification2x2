module sa_controller_2x2 (
    input logic clk,
    input logic rst_n,
    input logic start,

    output logic valid_in,
    output logic done,
    output logic clear        // ← Thêm dòng này
);
    typedef enum logic [2:0] {IDLE, K0, K1, FLUSH1, FLUSH2, DONE} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin 
        if(!rst_n) state <= IDLE;
        else       state <= next_state;
    end

    always_comb begin 
        next_state = state;
        case (state)
            IDLE : if(start) next_state = K0;
            K0 : next_state = K1;
            K1 : next_state = FLUSH1;
            FLUSH1 : next_state = FLUSH2;
            FLUSH2 : next_state = DONE;
            DONE : next_state = IDLE; 
            default: next_state = IDLE;
        endcase
    end

    always_comb begin 
        valid_in = 0; done = 0; clear = 0;
        case (state)
            IDLE : begin
                if (start) clear = 1;  // Clear ngay khi bắt đầu transaction mới
            end
            K0 : begin
                valid_in = 1;
            end 
            K1 : begin
                valid_in = 1;
            end
            DONE : begin
                done = 1;
            end
            default: ;
        endcase
    end
    assert property(
        @(posedge clk) disable iff (!rstn) valid_in |-> (state == K0 || state == K1)
    );
    assert property (
        @(posedge clk) disable iff (!rstn) done |-> state == DONE
    );
    assert property(
        @(posedge clk) disable iff (!rst_n) state == DONE |=> state == IDLE
    )else $error("[CTRL BUG] DONE not back to IDLE");
    assert property(
        @(posedge clk) disable iff (!rstn) state == IDLE |-> !start
    )else $error("[CTRL BUG] start during busy");
    assert property(
        @(posedge clk) disable iff (!rst_n)
        (state==IDLE) && start |-> (state==K0) ##1 (state == K1) ##1 (state == FLUSH1) ##1 (state == FLUSH2) ##1 (state == DONE)
    )else $error("[CTRL BUG] FSM sequence wrong");
    assert property(
        @(posedge clk) disable iff (!rst_n) $rose(done) |=> !done
    )else $error("[CTRL BUG] done not 1 cycle");
endmodule