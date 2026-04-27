VERIFICATION PLAN: 2x2 SYSTOLIC ARRAY NPU

1. Goals
    Verify correctness of signed 2×2 matrix multiplication
    Ensure dataflow follows systolic architecture (A shifts right, B shifts down)
    Verify boundary conditions for 8bit data and FSM states
2. Verification Strategy
    Method: Constrained Random Verification (CRV) combined with Directed Tests
    Reference Model: goldenModel.compute() calculates expected results
    Checker: Scoreboard compares DUT output (C_actual) with reference model (C_expected) upon done signal
3. Test List
    ID  Test Name       Goal                    Description                                                     Status 
    TC1  Reset Test    Verify initial state     Assert rst_n, check all accumulators and outputs = 0            PASS 
    TC2  Max Positive  Check overflow           Force A or B = 127 (max 8bit signed)                            PASS 
    TC3  Max Negative  Check signed bit         Force value = 128 to verify signed computation                  PASS 
    TC4  Zero Matrix   Check accumulator hold   Use dist to inject many zeros, verify accumulator holds value   PASS 
    TC5  BacktoBack    Check pipeline           Send consecutive transactions with no idle gap                  PASS 
    TC6  Randomized    Sanity check             Run 480+ transactions with fully random data                    PASS 
4. Functional Coverage Plan
    Input Range Coverage:
    cp_a: cover {negative, zero, positive} for all A elements
    cp_b: cover {negative, zero, positive} for all B elements
    Cross Coverage:
    cross_axb: combine (A neg × B neg), (A pos × B pos), etc.
    Corner Coverage:
    Hit extreme values (127, 128) at least once per coverpoint
5. Assertion Monitoring (SVA)
    Done Pulse: done signal must be high for exactly 1 clock cycle
    Latency: from start assertion, done must rise exactly 5 cycles later
    Stability: when valid_in = 0 (FLUSH state), PE data must not change
    Reset Integrity: when rst_n = 0, all outputs c00–c11 must be 0
    Dataflow: A shifts right, B shifts down through PE array
    FSM: valid state transitions (IDLE→K0→K1→FLUSH1→FLUSH2→DONE→IDLE)
6. UVM Environment Structure
    Sequencer: sends sequence_item (A, B) to Driver
    Driver: converts matrix data to interface signals (a0, a1, b0, b1) following FSM timing
    Monitor: observes interface, waits for done to capture C_actual and send to Scoreboard
    Scoreboard: computes expected results in parallel and compares
7. Exit Criteria
    Functional Coverage ≥ 83% (coverpoints 100%, cross coverage to be improved)
    100% Pass for all testcases
    0 assertion failures
    500 tests completed
8. Results (Actual)
    Total tests: 500 (480 random + 20 directed)
    Pass: 500 (100%)
    Functional Coverage: 83% (all coverpoints 100%)
    Assertions: 17 total, 0 failures
    Tool: QuestaSim 10.7c