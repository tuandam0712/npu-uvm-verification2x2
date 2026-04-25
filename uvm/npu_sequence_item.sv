import uvm_pkg::*;
class npu_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(npu_sequence_item)

    rand logic signed [7:0] A [2][2];
    rand logic signed [7:0] B [2][2];
    bit signed [15:0] C_expected [2][2];
    bit signed [15:0] C_actual [2][2];

    constraint reasonalble_range {
        foreach(A[i,j]) A[i][j] inside {[-15:15]};
        foreach(B[i,j]) B[i][j] inside {[-15:15]};
    }
    function new(string name = "npu_sequence_item");
        super.new(name);
    endfunction 
    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("A[0][0]", A[0][0], 8);
        printer.print_field("A[0][1]", A[0][1], 8);
        printer.print_field("A[1][0]", A[1][0], 8);
        printer.print_field("A[1][1]", A[1][1], 8);
        printer.print_field("B[0][0]", B[0][0], 8);
        printer.print_field("B[0][1]", B[0][1], 8);
        printer.print_field("B[1][0]", B[1][0], 8);
        printer.print_field("B[1][1]", B[1][1], 8);
        printer.print_field("C_expected[0][0]", C_expected[0][0], 16);
        printer.print_field("C_expected[0][1]", C_expected[0][1], 16);
        printer.print_field("C_expected[1][0]", C_expected[1][0], 16);
        printer.print_field("C_expected[1][1]", C_expected[1][1], 16);
        printer.print_field("C_actual[0][0]", C_actual[0][0], 16);
        printer.print_field("C_actual[0][1]", C_actual[0][1], 16);
        printer.print_field("C_actual[1][0]", C_actual[1][0], 16);
        printer.print_field("C_actual[1][1]", C_actual[1][1], 16);
    endfunction
endclass 