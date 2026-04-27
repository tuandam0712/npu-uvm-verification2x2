SPEC – 2x2 Systolic Array NPU
1. Overview
    Module npu_top implements a 2x2 systolic array for signed matrix multiplication.
    Data type: signed integer
    Operation: Multiply-Accumulate (MAC)
    Architecture: 2D systolic array (streaming dataflow)
2. Interface Specification
    Inputs
    clk: system clock
    rst_n: active-low reset
    start: start transaction
    a_in0, a_in1: input vector A (column-wise feed)
    b_in0, b_in1: input vector B (row-wise feed)
    Outputs
    done: indicates computation complete (1 cycle pulse)
    c00, c01, c10, c11: result matrix (2x2)
3. Functional Behavior
    3.1 Operation Description
        DUT computes matrix multiplication:
        C = A X B
        Where:
        A = a00 , a01 B = b00 , b01
            a10 , a11     b10 , b11
        Output:
        Cij = 1∑(k=0) Aik x Bkj
    3.2 Dataflow (IMPORTANT – systolic behavior)
        a data flows left -> right
        b data flows top -> down
        Each PE performs:
            forward data 
            accumulate partial sum
    3.3 Processing Element (PE) Behavior
        Module pe:
            On each valid cycle:
                acc += a_in * b_in
        Pipeline:
            a_out = a_in (1 cycle delay)
            b_out = b_in (1 cycle delay)
        Control:
            clear = 1 -> reset accumulator to 0
            valid = 1 -> enable MAC
            valid = 0 -> accumulator holds value
4. Control Flow (FSM)
    Module sa_controller_2x2
    States:
        IDLE
        K0
        K1
        FLUSH1
        FLUSH2
        DONE
        Sequence:
        IDLE --start--> K0 -> K1 -> FLUSH1 -> FLUSH2 -> DONE -> IDLE
        Behavior:
        clear = 1 at start (reset accumulators)
        valid_in = 1 during:
        K0
        K1
        done = 1 during DONE (1 cycle)
5. Timing Specification
    5.1 Transaction Timeline
        Cycle	State	valid_in	Description
        t0	    IDLE	    0	    wait start
        t1	    K0	        1	    first MAC
        t2	    K1	        1	    second MAC
        t3	    FLUSH1	    0	    pipeline flush
        t4	    FLUSH2	    0	    pipeline flush
        t5	    DONE	    0	    result ready
    5.2 Latency
        Total latency: 5 cycles from start to done
        Valid compute cycles: 2 cycles
6. Data Alignment
    To match systolic timing:
        a_in1 delayed 1 cycle
        b_in1 delayed 1 cycle
    => ensures correct alignment at PE (1,1)
7. Valid Propagation
    Inside systolic_arr_2x2:
    valid_00 = valid_in
    valid_01 = delay(valid_00)
    valid_10 = delay(valid_00)
    valid_11 = valid_01 & valid_10
8. Reset Behavior
    rst_n = 0:
    all accumulators = 0
    pipeline registers cleared
    synchronous operation resumes after reset release
9. Corner Cases / Constraints
    9.1 Input assumptions
        start only asserted in IDLE
        inputs stable during valid cycles
    9.2 Undefined behavior
        asserting start during non-IDLE -> undefined
        changing inputs when valid_in = 0 -> ignored
10. Output Validity
    Outputs c00–c11 are valid at DONE
    Outside DONE:
    values may be intermediate or stale
11. Key Properties (Derived from RTL)
    Exactly 2 valid cycles per transaction
    done is 1-cycle pulse
    Data propagation strictly:
    right shift for A
    down shift for B
12. Derived Properties (for SVA)
    done is 1-cycle pulse
    Exactly 2 valid cycles per transaction
    Data propagation: A shifts right, B shifts down
    Accumulator holds value when !valid
    Output stable when !valid_in