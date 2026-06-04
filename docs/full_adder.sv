`timescale 1ns/10ps

module full_adder (A, B, C, Sum, Cout);
	input logic A, B, C;
	output logic Sum, Cout;
	logic top_sum, top_cout, bottom_cout;
	
	half_adder top(.A(A), .B(B), .Sum(top_sum), .Cout(top_cout));
	half_adder bottom(.A(top_sum), .B(C), .Sum(Sum), .Cout(bottom_cout));
	or #50ps orGate (Cout, top_cout, bottom_cout);
	
endmodule
