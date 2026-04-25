class npu_sequence extends uvm_sequence #(npu_sequence_item);
    `uvm_object_utils(npu_sequence)
    
    function new(string name = "npu_sequence");
        super.new(name);
    endfunction
    
    task body();
        npu_sequence_item req;
        
        
        if (starting_phase != null)
            starting_phase.raise_objection(this);   // ← Phải có dòng này
        
        repeat(100) begin
            req = npu_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
        
        if (starting_phase != null)
            starting_phase.drop_objection(this);    // ← Và dòng này
        
    endtask
endclass