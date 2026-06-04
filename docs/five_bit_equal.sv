`timescale 1ns/10ps
module five_bit_equal (A, B, result);
    input logic [4:0] A, B;
    output logic result;

    logic r1, r2, r3, r4, r5;
    logic andOut1, andOut2;
    xnor #50ps checkBit0 (res0, A[0], B[0]);
    xnor #50ps checkBit1 (res1, A[1], B[1]);
    xnor #50ps checkBit2 (res2, A[2], B[2]);
    xnor #50ps checkBit3 (res3, A[3], B[3]);
    xnor #50ps checkBit4 (res4, A[4], B[4]);
    and #50ps and1 (andOut1, res0, res1, res2);
    and #50ps and2 (andOut2, res3, res4);
    and #50ps finalAnd (result, andOut1, andOut2);
endmodule