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
                // Không clear ở đây nữa
            end
            default: ;
        endcase
    end
    assert property(
        @(posedge clk) valid_in |-> (state == K0 || state == K1)
    );
    assert property (
    @(posedge clk) done |-> state == DONE
    );
    assert property (
        @(posedge clk) state == K0 |-> ##1 state == K1
    );
endmodule