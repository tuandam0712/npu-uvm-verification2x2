import uvm_pkg::*;
class goldenModel;
    function void compute(npu_sequence_item item);
        int i, j, k;
        //reset C
        for(i=0;i<2;i++) for(j=0;j<2;j++) item.C_expected[i][j]=0;

        for(i=0;i<2;i++) begin
            for(j=0;j<2;j++) begin
                for(k=0;k<2;k++) begin
                    item.C_expected[i][j] += item.A[i][k] * item.B[k][j];
                end
            end
        end
    endfunction 
endclass
class npu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(npu_scoreboard)
    uvm_analysis_imp #(npu_sequence_item, npu_scoreboard) analysis_imp;
    int pass_cnt,fail_cnt;
    goldenModel gm;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_imp = new("analysis_imp",this);
        gm = new();
    endfunction
    function void write(npu_sequence_item item);
        bit match;
        gm.compute(item);
        match = 1;
        `uvm_info("SCB", $sformatf("A[0][0]=%0d A[0][1]=%0d A[1][0]=%0d A[1][1]=%0d", 
             item.A[0][0], item.A[0][1], item.A[1][0], item.A[1][1]), UVM_LOW)
        `uvm_info("SCB", $sformatf("B[0][0]=%0d B[0][1]=%0d B[1][0]=%0d B[1][1]=%0d", 
                item.B[0][0], item.B[0][1], item.B[1][0], item.B[1][1]), UVM_LOW)
        `uvm_info("SCB", $sformatf("Expected: c00=%0d c01=%0d c10=%0d c11=%0d", 
                item.C_expected[0][0], item.C_expected[0][1], 
                item.C_expected[1][0], item.C_expected[1][1]), UVM_LOW)
        `uvm_info("SCB", $sformatf("Actual:   c00=%0d c01=%0d c10=%0d c11=%0d", 
                item.C_actual[0][0], item.C_actual[0][1], 
                item.C_actual[1][0], item.C_actual[1][1]), UVM_LOW)
        for (int i = 0; i < 2; i++) begin
            for (int j = 0; j < 2; j++) begin
                if (item.C_actual[i][j] != item.C_expected[i][j]) begin
                    match = 0;
                    `uvm_error("SCB", $sformatf("Mismatch [%0d][%0d]: exp=%0d, act=%0d", 
                             i, j, item.C_expected[i][j], item.C_actual[i][j]))
                end
            end
        end
        if (match) begin
            pass_cnt++;
        end else begin
            fail_cnt++;
        end
    endfunction
endclass
