class npu_sequence extends uvm_sequence #(npu_sequence_item);
    `uvm_object_utils(npu_sequence)
    
    function new(string name = "npu_sequence");
        super.new(name);
    endfunction
    
    task body();
        npu_sequence_item req;
        
        
        if (starting_phase != null)
            starting_phase.raise_objection(this);   // ← Phải có dòng này
            // Test 1-5: max_pos với pos/neg/zero
        repeat(5) begin
            req = npu_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {
                A[0][0] == 127;  // max_pos
                B[0][0] inside {[-128:127]};
            });
            finish_item(req);
        end
        
        // Test 6-10: max_neg với pos/neg/zero
        repeat(5) begin
            req = npu_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {
                A[0][0] == -128;  // max_neg
                B[0][0] inside {[-128:127]};
            });
            finish_item(req);
        end
        
        // Test 11-15: pos/neg với max_pos
        repeat(5) begin
            req = npu_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {
                B[0][1] == 127;  // max_pos cho cp_b01
            });
            finish_item(req);
        end
        repeat(480) begin
            req = npu_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
        
        if (starting_phase != null)
            starting_phase.drop_objection(this);    // ← Và dòng này
        
    endtask
endclass