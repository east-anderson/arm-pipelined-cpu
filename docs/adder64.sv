// 64 bit adder for PC + 4 and PC + CondAddr19 and BrAddr26
`timescale 1ns/10ps

module adder64 (A, B, Sum); 
    input logic [63:0] A, B;
    output logic [63:0] Sum;
    logic [63:0] carry;

    half_adder adder1 (.A(A[0]), .B(B[0]), .Sum(Sum[0]), .Cout(carry[0]));

    genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) begin : full_adders
            full_adder fa (.A(A[i]), .B(B[i]), .C(carry[i-1]), .Sum(Sum[i]), .Cout(carry[i]));
        end
    endgenerate 
endmodule
