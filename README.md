# NPU 2x2 Systolic Array with UVM Testbench

## Overview
A 2x2 Neural Processing Unit using systolic array architecture for matrix multiplication, verified with a complete UVM testbench.

## Architecture
- 4 Processing Elements (PE) in 2x2 systolic array
- FSM-based Controller (IDLE → K0 → K1 → FLUSH → DONE)
- 8-bit signed input, 16-bit signed output
- `clear` signal to reset accumulators between transactions

## UVM Testbench
| Component | Description |
|-----------|-------------|
| Sequence Item | Randomized 2x2 matrices with constraints [-128:127] |
| Driver | Drives input data into systolic array |
| Monitor | Captures input/output from DUT via analysis port |
| Scoreboard | Compares DUT output with golden model |
| Coverage | 83% functional coverage, all coverpoints 100% |

## Results
- 480 random tests + 20 directed tests — **100% PASS**
- QuestaSim 10.7c

## Quick Start
1. Open QuestaSim
2. Compile files: `npu_pkg.sv, all rtl, tb_npu_uvm.sv`
3. Start simulation: `vsim -gui work.tb_npu_uvm`
4. Run: `run -all`